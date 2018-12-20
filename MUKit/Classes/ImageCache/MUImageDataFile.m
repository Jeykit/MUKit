//
//  MUImageDataFile.m
//  MUKit_Example
//
//  Created by Jekity on 2018/7/30.
//  Copyright © 2018年 Jeykit. All rights reserved.
//

#import "MUImageDataFile.h"
#import "MUImageCacheUtils.h"
#import <sys/mman.h>

@implementation MUImageDataFile {
    NSString* _filePath;
    int _fileDescriptor;
    size_t _maxLength; // default is 1000Mb.
    
    NSRecursiveLock* _lock;
}

- (instancetype)initWithPath:(NSString*)path
{
    if (self = [super init]) {
        _filePath = [path copy];
        _maxLength = 1024 * 1024 * 1024;
        _pointer = 0;
        _lock = [[NSRecursiveLock alloc] init];
        _fileDescriptor = -1;
        _open = NO;
    }
    return self;
}

- (void)dealloc
{
    // should close the file if it's not be used again.
    [self close];
}
- (NSString *)filePath{
    
    [_lock lock];
    NSString *path = [_filePath copy];
    [_lock unlock];
    
    return path;
}
- (BOOL)open
{
    
    [_lock lock];
    _fileDescriptor = open([_filePath fileSystemRepresentation], O_RDWR | O_CREAT, 0666);
    if (_fileDescriptor < 0) {
        MUImageErrorLog(@"can't file at %@", _filePath);
        [_lock unlock];
        _open = NO;
        return NO;
    }
    [_lock unlock];
     _open = YES;
    _fileLength = lseek(_fileDescriptor, 0, SEEK_END);
    if (_fileLength == 0) {
        [self increaseFileLength:(size_t)1];
    } else {
        [self mmap];
    }
    
    return YES;
}

- (void)close
{
    if (_fileDescriptor < 0) {
        return;
    }
    
    [_lock lock];
    
    close(_fileDescriptor);
    _fileDescriptor = -1;
    [_lock unlock];
    
    // 取消内存映射
    [self munmap];
    
}

- (void)munmap
{
    if (_address == NULL) {
        return;
    }
    
    [_lock lock];
    munmap(_address, (size_t)_fileLength);
    _address = NULL;
    [_lock unlock];
}

- (void)mmap
{
    _address = mmap(NULL, (size_t)_fileLength, (PROT_READ | PROT_WRITE), (MAP_FILE | MAP_SHARED), _fileDescriptor, 0);
    _pointer = _fileLength;//如果文件长度大于0指针指向末尾,初始化指针位置
}

- (BOOL)prepareAppendDataWithOffset:(size_t)offset length:(size_t)length
{
    NSAssert(_fileDescriptor > -1, @"open this file first.");
    
    [_lock lock];
    
    // can't exceed maxLength
    if (offset + length > _maxLength) {
        [_lock unlock];
        return NO;
    }
    
    // Check the file length, if it is not big enough, then increase the file length with step.
    if (offset + length > _fileLength) {
        if (![self increaseFileLength:length]) {
            [_lock unlock];
            return NO;
        }
    }
    
    [_lock unlock];
    return YES;
}

- (BOOL)appendDataWithOffset:(size_t)offset length:(size_t)length
{
    NSAssert(_fileDescriptor > -1, @"open this file first.");
    
    [_lock lock];
     /**aligned page .avoid crash 同步时进行page对齐，防止拷贝出错*/
    int pageSize = [MUImageCacheUtils pageSize];
    void *address = _address;
    size_t pageIndex = (size_t)address / pageSize;
    void *pageAlignedAddress = (void *)(pageIndex * pageSize);
    size_t bytesBeforeData = address - pageAlignedAddress;
    size_t bytesToFlush = (bytesBeforeData + length);
    //end
    int result = msync(pageAlignedAddress, bytesToFlush, MS_SYNC);
    if (result < 0) {
        MUImageErrorLog(@"append data failed");
        [_lock unlock];
        return NO;
    }
    
    // move the pointer
    if (offset + length > _pointer) {
        _pointer = offset + length;
    }
    
    [_lock unlock];
    
    return YES;
}

- (BOOL)increaseFileLength:(size_t)length
{
   
    // cancel map first
    [self munmap];
    [_lock lock];
    int newFileDescriptor = _fileDescriptor;
    size_t newFileLength = _fileLength + length;
    // change file length
    int result = ftruncate(newFileDescriptor, newFileLength);
    if (result < 0) {
        MUImageErrorLog(@"can't truncate data file");
        [_lock unlock];
        return NO;
    }
    // remap
    _fileLength = lseek(_fileDescriptor, 0, SEEK_END);
    [self mmap];
    _pointer = _fileLength - length;//复原
    [_lock unlock];
    
    return YES;
}

@end
