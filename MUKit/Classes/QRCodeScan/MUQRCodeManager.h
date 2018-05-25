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
-(instancetype)init NS_UNAVAILABLE;

/**
 Unavailable. Please use initWithView:backgroundImage:scanlineImage method
 */
-(instancetype) new NS_UNAVAILABLE;
-(instancetype)initWithView:(UIView *)view backgroundImage:(UIImage *)backgroundImage scanlineImage:(UIImage *)scanlineImage;
@property(nonatomic, copy)NSString *tipsString;
@property(nonatomic, copy)void(^QRCodeScanedResult)(NSArray<AVMetadataMachineReadableCodeObject*> *result,NSString *resultString);
//开始扫描
- (void)startScanning;
//停止扫描
- (void)stopScanning;
@end
