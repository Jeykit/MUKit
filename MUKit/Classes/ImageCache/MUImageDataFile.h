//
//  MUImageDataFile.h
//  MUKit_Example
//
//  Created by Jekity on 2018/7/30.
//  Copyright © 2018年 Jeykit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MUImageDataFile : NSObject
/**
 *  Wrapper of data file, map the disk file to the memory.
 *
 *  Only support `append` operation, we can move the pointer to replace the data.
 *
 */

@property (nonatomic, assign, readonly) void* address;
@property (nonatomic, assign, readonly) off_t fileLength; // total length of the file.
@property (nonatomic, assign, readonly) off_t pointer; // append the data after the pointer. Default is 0.
@property (nonatomic, copy ,readonly) NSString *filePath;
@property (readonly ,getter=isOpening) BOOL open;//YES when the file is opening.defalut is NO.

- (instancetype)initWithPath:(NSString*)path;

- (BOOL)open;

- (void)close;

/**
 *  Check the file length, if it is not big enough, then increase the file length with step.
 *
 *  @param offset start position
 *  @param length data length
 *
 *  @return success or failed
 */
- (BOOL)prepareAppendDataWithOffset:(size_t)offset length:(size_t)length;

/**
 *  Append the data after pointer.
 *
 *  Must execute `prepareAppendDataWithOffset:length` first.
 *
 *  @param offset start position
 *  @param length data length
 *
 *  @return success or failed
 */
- (BOOL)appendDataWithOffset:(size_t)offset length:(size_t)length;

@end
