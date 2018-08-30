//
//  MUProgressiveImage.h
//  MUKit_Example
//
//  Created by Jekity on 2018/8/9.
//  Copyright © 2018年 Jeykit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/** The type of lock, either recursive or non-recursive */
typedef NS_ENUM(NSUInteger, MURemoteLockType) {
    /** A non-recursive version of the lock. The default. */
    MURemoteLockTypeNonRecursive = 0,
    /** A recursive version of the lock. More expensive. */
    MURemoteLockTypeRecursive,
};
NS_ASSUME_NONNULL_BEGIN
@interface MURemoteLock : NSObject

- (instancetype )initWithName:(NSString *)lockName lockType:(MURemoteLockType)lockType NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithName:(NSString *)lockName;
- (void)lockWithBlock:(dispatch_block_t)block;

- (void)lock;
- (void)unlock;

@end


//From PINRemoteImage
@interface MUProgressiveImage : NSObject
@property (atomic, copy, nonnull) NSArray *progressThresholds;
@property (atomic, assign) CFTimeInterval estimatedRemainingTimeThreshold;

//@property (nonatomic, weak, readonly, nonnull) NSURLSessionDataTask * dataTask;
@property (nonatomic, readonly) CFTimeInterval estimatedRemainingTime;

- (nonnull instancetype)init NS_UNAVAILABLE;
- (nonnull instancetype)initWithDataTask:(nonnull NSURLSessionTask *)dataTask;

- (void)updateProgressiveImageWithData:(nonnull NSData *)data expectedNumberOfBytes:(int64_t)expectedNumberOfBytes;

/**
 Returns the latest image based on thresholds, returns nil if no new image is generated.
 
 @param blurred A boolean to indicate if the image should be blurred.
 or width of this dimension, the image will *not* be blurred regardless of the blurred parameter.
 @param renderedImageQuality Value between 0 and 1. Computed by dividing the received number of bytes by the expected number of bytes.
 @return PINImage A progressive scan of the image or nil if a new one has not been generated.
 */
- (nullable UIImage *)currentImageBlurred:(BOOL)blurred renderedImageQuality:(nonnull out CGFloat *)renderedImageQuality dataLength:(CGFloat)length;



@end
NS_ASSUME_NONNULL_END
