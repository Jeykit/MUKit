//
//  MUSpeedRecorder.h
//  MUKit_Example
//
//  Created by Jekity on 2018/8/9.
//  Copyright © 2018年 Jeykit. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum : NSUInteger {
    MUSpeedRecorderConnectionStatusNotReachable,
    MUSpeedRecorderConnectionStatusWWAN,
    MUSpeedRecorderConnectionStatusWiFi
} MUSpeedRecorderConnectionStatus;

@interface MUSpeedRecorder : NSObject
+ (MUSpeedRecorder *)sharedRecorder;
+ (NSUInteger)appropriateImageIdxForURLsGivenHistoricalNetworkConditions:(NSArray <NSURL *> *)urls
                                                  lowQualityQPSThreshold:(float)lowQualityQPSThreshold
                                                 highQualityQPSThreshold:(float)highQualityQPSThreshold;

- (void)processMetrics:(NSURLSessionTaskMetrics *)metrics forTask:(NSURLSessionTask *)task NS_AVAILABLE(10_12, 10_0);

/*
 Returns a weighted average of the bytes per second of a transfer with the time to first byte subtracted.
 More specifically, we get the time to first byte for every task that completes,
 subtract it from the total transfer time, calulate bytes per second
 and add it to an existing average using exponential weighted average and adjusting
 for starting bias.
 This is all done on a per host basis.
 */
- (float)weightedAdjustedBytesPerSecondForHost:(NSString *)host;

/*
 Returns a weighted average of time to first byte for the specified host.
 More specifically, we get the time to first byte for every task that completes
 and add it to an existing average using exponential weighted average and adjusting
 for starting bias.
 This is all done on a per host basis.
 */
- (NSTimeInterval)weightedTimeToFirstByteForHost:(NSString *)host;

- (MUSpeedRecorderConnectionStatus)connectionStatus;

#if DEBUG
- (void)setCurrentBytesPerSecond:(float)currentBPS;
#endif
@end
