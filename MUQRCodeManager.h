//
//  MUQRCodeManager.h
//  MUKit
//
//  Created by Jekity on 2018/5/24.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface MUQRCodeManager : NSObject
-(instancetype)initWithView:(UIView *)view backgroundImage:(UIImage *)backgroundImage scanlineImage:(UIImage *)scanlineImage;
@property(nonatomic, copy)NSString *tipsString;
@property(nonatomic, copy)void(^QRCodeScanedResult)(NSArray<AVMetadataMachineReadableCodeObject*> *result,NSString *resultString);
//开始扫描
- (void)startScanning;
//停止扫描
- (void)stopScanning;
@end
