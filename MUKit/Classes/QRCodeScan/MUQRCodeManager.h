//
//  MUQRCodeManager.h
//  Pods
//
//  Created by Jekity on 2017/10/19.
//
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface MUQRCodeManager : NSObject

/**
 Unavailable. Please use initWithView:backgroundImage:scanlineImage method
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 Unavailable. Please use initWithView:backgroundImage:scanlineImage method
 */
- (instancetype) new NS_UNAVAILABLE;
- (instancetype)initWithView:(UIView *)view backgroundImage:(UIImage *)backgroundImage scanlineImage:(UIImage *)scanlineImage;


@property(nonatomic, copy) NSString *tipsString;

/**
 Detected result
 */
@property(nonatomic, copy) void(^QRCodeScanedResult)(NSArray<AVMetadataMachineReadableCodeObject*> *result,NSString *resultString);

/**
start to scan
 */
- (void)startScanning;

/**
 stop to scan
 */
- (void)stopScanning;
@end
