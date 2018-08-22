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
        _maxLength = 1024 * 1024 * 1000;
        _step = 1;
        _pointer = 0;
        _lock = [[NSRecursiveLock alloc] init];
        _fileDescriptor = -1;
    }
    return self;
}

- (void)dealloc
{
    // should close the file if it's not be used again.
    [self close];
}
- (NSString *)filePath{
    
    return _filePath;
}
- (BOOL)open
{
    _fileDescriptor = open([_filePath fileSystemRepresentation], O_RDWR | O_CREAT, 0666);
    if (_fileDescriptor < 0) {
        MUImageErrorLog(@"can't file at %@", _filePath);
        return NO;
    }
    
    _fileLength = lseek(_fileDescriptor, 0, SEEK_END);
    if (_fileLength == 0) {
        [self increaseFileLength:_step];
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
    
    // 取消内存映射
    [self munmap];
    
    [_lock unlock];
}

- (void)munmap
{
    if (_address == NULL) {
        return;
    }
    
    munmap(_address, (size_t)_fileLength);
    _address = NULL;
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
        size_t correctLength = ceill((length * 1.0 / _step)) * _step;
        if (![self increaseFileLength:correctLength]) {
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
    
    int result = msync(_address + offset, length, MS_SYNC);
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
    [_lock lock];
    
    // cancel map first
    [self munmap];
    
    // change file length
    int result = ftruncate(_fileDescriptor, _fileLength + length);
    if (result < 0) {
        MUImageErrorLog(@"can't truncate data file");
        [_lock unlock];
        return NO;
    }
    
    // remap
    _fileLength = lseek(_fileDescriptor, 0, SEEK_END);
    [self mmap];
    
    [_lock unlock];
    
    return YES;
}

@end
