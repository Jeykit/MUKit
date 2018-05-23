//
//  MUQRCodeScanTool.h
//  Pods
//
//  Created by Jekity on 2017/10/19.
//
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface MUQRCodeScanTool : UIView
-(instancetype)initWithFrame:(CGRect)frame backgroundImage:(UIImage *)backgroundImage scanlineImage:(UIImage *)scanlineImage;
@property(nonatomic, copy)NSString *tipsString;
@property(nonatomic, copy)void(^QRCodeScanedResult)(NSArray<AVMetadataMachineReadableCodeObject*> *result,NSString *resultString);
@property(nonatomic, copy)void(^clickedClosed)(void);
//开始扫描
- (void)startScanning;
//停止扫描
- (void)stopScanning;
@end
