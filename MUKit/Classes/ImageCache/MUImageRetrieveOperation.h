//
//  MUImageRetrieveOperation.h
//  MUKit_Example
//
//  Created by Jekity on 2018/7/30.
//  Copyright © 2018年 Jeykit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MUImageCacheUtils.h"


@interface MUImageRetrieveOperation : NSOperation

@property (nonatomic,copy) NSString *filePath;
/**
 *  Internal class. In charge of retrieving and sending UIImage.
 */

/**
 *  When the operation start running, the block will be executed,
 *  and require an uncompressed UIImage.
 */
- (instancetype)initWithRetrieveBlock:(RetrieveOperationBlock)block;

/**
 *  Allow to add multiple blocks
 *
 *  @param block handler block
 */
- (void)addBlock:(MUImageCacheRetrieveBlock)block;

/**
 *  Callback with result image, which can be nil.
 */
- (void)executeWithImage:(UIImage*)image;
@end
