//
//  MUImageDataFileManager.h
//  MUKit_Example
//
//  Created by Jekity on 2018/7/30.
//  Copyright © 2018年 Jeykit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MUImageDataFile.h"

@interface MUImageDataFileManager : NSObject
@property (nonatomic, strong, readonly) NSString* folderPath; // folder saved data files.
@property (nonatomic, assign, readonly) BOOL isDiskFull; // Default is NO.

- (instancetype)initWithFolderPath:(NSString*)folderPath;

/**
 *  Create a `FlyImageDataFile` if it doesn't exist.
 */
- (MUImageDataFile*)createFileWithName:(NSString*)name;

/**
 *  Add an exist file.
 */
- (void)addExistFileName:(NSString*)name;

/**
 *  Check the file whether exist or not, no delay.
 */
- (BOOL)isFileExistWithName:(NSString*)name;

/**
 *  Get a `FlyImageDataFile` if it exists.
 */
- (MUImageDataFile*)retrieveFileWithName:(NSString*)name;

/**
 *  Remove data file
 */
- (void)removeFileWithName:(NSString*)name;

/**
 *  Create a `FlyImageDataFile` async.
 */
- (void)asyncCreateFileWithName:(NSString*)name completed:(void (^)(MUImageDataFile* dataFile))completed;

/**
 *  Remove all the data files, except some special files.
 *
 *  @param names     except files' names
 *  @param toSize    expected size of the folder
 *  @param completed callback
 */
- (void)purgeWithExceptions:(NSArray*)names
                     toSize:(NSUInteger)toSize
                  completed:(void (^)(NSUInteger fileCount, NSUInteger totalSize))completed;

/**
 *  Calculate the folder size.
 */
- (void)calculateSizeWithCompletionBlock:(void (^)(NSUInteger fileCount, NSUInteger totalSize))block;

/**
 *  Free space left in the system space.
 */
- (void)freeDiskSpaceWithCompletionBlock:(void (^)(NSUInteger freeSize))block;
@end
