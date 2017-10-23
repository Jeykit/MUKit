//
//  MUQRCodeScanTool.m
//  Pods
//
//  Created by Jekity on 2017/10/19.
//
//

#import "MUQRCodeScanTool.h"
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/ImageIO.h>

@interface MUQRCodeScanTool()<AVCaptureMetadataOutputObjectsDelegate,AVCaptureVideoDataOutputSampleBufferDelegate>
@property (nonatomic,strong)AVCaptureSession           *session;
@property (nonatomic,strong)AVCaptureDevice            *device;
@property (nonatomic,strong)AVCaptureDeviceInput       *input;
@property (nonatomic,strong)AVCaptureMetadataOutput    *output;
@property (nonatomic,strong)AVCaptureVideoPreviewLayer *preview;

@property(nonatomic, strong)UIImageView *imageView;//扫描框
@property(nonatomic, strong)UIImageView *scanImageView;//扫描线
@property(nonatomic, strong)UILabel *tipsLabel;//提示文字
@property(nonatomic, strong)NSTimer *timerScan;
@property(nonatomic, assign)BOOL isBottom;
@property(nonatomic, assign)CGFloat num;
@property (strong, nonatomic) AVAudioPlayer        *beepPlayer;
@property(nonatomic, strong)AVCaptureVideoDataOutput *outputVideo;
@end
@implementation MUQRCodeScanTool

-(instancetype)initWithFrame:(CGRect)frame backgroundImage:(UIImage *)backgroundImage scanlineImage:(UIImage *)scanlineImage{
    if (self = [super initWithFrame:frame]) {
        [self configuredUI:backgroundImage scanImage:scanlineImage];
        //初始化照相机
//        [self setupCamera];
    }
    return self;
}
//设置UI
-(void)configuredUI:(UIImage *)backgroundImage scanImage:(UIImage *)scanImage{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.imageView];
    [self addSubview:self.scanImageView];
    [self addSubview:self.tipsLabel];
    self.imageView.image     = backgroundImage;
    self.scanImageView.image = scanImage;
    [self conguredImageView:backgroundImage];
    NSString * wavPath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"wav"];
    NSData* data = [[NSData alloc] initWithContentsOfFile:wavPath];
    _beepPlayer = [[AVAudioPlayer alloc] initWithData:data error:nil];
   
    
}
-(void)conguredImageView:(UIImage *)image{
    if (image) {
        CGRect rect = [self rectByImage:image];
        self.imageView.frame = rect;
        self.imageView.image = image;
        CGFloat imageWithFlex = CGRectGetHeight(self.frame) * .38;
        CGPoint center = self.imageView.center;
        center.y = imageWithFlex;
        self.imageView.center = center;
    }
}

-(void)setTipsString:(NSString *)tipsString{
    _tipsString = tipsString;
    if (tipsString) {
        _tipsLabel.text = tipsString;
        [_tipsLabel sizeToFit];
        CGPoint center = CGPointZero;
        CGFloat height = CGRectGetHeight(_imageView.frame);
        center.x       = _imageView.center.x;
        center.y       = _imageView.center.y + height/2. + 24.;
        _tipsLabel.center = center;
    }
}
//开始扫描
- (void)startScanning;
{
    if (_session) {
        [_session startRunning];
    }
    if(_timerScan){
        [_timerScan invalidate];
        _timerScan = nil;
    }
    if (self.imageView.image) {//有背景图才开始扫描
        _timerScan = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(scanAnimate) userInfo:nil repeats:YES];
    }
}
- (void)stopScanning;
{
    if ([self.session isRunning]) {
        [self.session stopRunning];
    }
    if(_timerScan)
    {
        [_timerScan invalidate];
        _timerScan = nil;
    }
}
- (void)scanAnimate
{
    if (!self.isBottom) {
        
        self.num += 1;
        _scanImageView.frame = CGRectMake(CGRectGetMinX(_imageView.frame)+5.f, CGRectGetMinY(_imageView.frame)+5.f+2*self.num, CGRectGetWidth(_imageView.frame) - 10.f, 2.);
        if (self.num == (NSInteger)((CGRectGetHeight(_imageView.frame) - 10.f)/2.)) {
            
            self.isBottom = YES;
        }
    }else{
        
        self.num -= 1;
        _scanImageView.frame = CGRectMake(CGRectGetMinX(_imageView.frame)+5.f, CGRectGetMinY(_imageView.frame)+5.f+2*self.num, CGRectGetWidth(_imageView.frame) - 10.f, 2.);
        
        if (self.num == 0) {
            
            self.isBottom = NO;
        }
    }
}

#pragma mark -lazy loading
//背景图片
-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView        = [[UIImageView alloc]initWithFrame:CGRectZero];
    }
    return _imageView;
}
//扫描线
-(UIImageView *)scanImageView{
    if (!_scanImageView) {
        _scanImageView        = [[UIImageView alloc]initWithFrame:CGRectZero];
    }
    return _scanImageView;
}
-(UILabel *)tipsLabel{
    if (!_tipsLabel) {
        
        _tipsLabel = [UILabel new];
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.font = [UIFont systemFontOfSize:12.];
        _tipsLabel.textColor = [UIColor lightGrayColor];
    }
    return _tipsLabel;
}
-(CGRect)rectByImage:(UIImage *)image{
    CGFloat imageWithFlex = CGRectGetWidth(self.frame) * .62;
    CGFloat imageWidth    = CGImageGetWidth(image.CGImage)/2.;
    CGFloat imageHeight   = CGImageGetHeight(image.CGImage)/2.;
    if (imageWidth > imageWithFlex) {
        imageWidth = imageHeight = imageWithFlex;
    }
    CGFloat imageX        = (CGRectGetWidth(self.bounds) - imageWidth)/2.;
    CGFloat imageY        = (CGRectGetHeight(self.bounds) - imageHeight)/2.;
    return CGRectMake(imageX, imageY, imageWidth, imageHeight);
}
//单独设置照相机
- (void)setupCamera{

    if (![self authority]) {
        NSString *errorStr = @"请在设置-隐私-相机中设置";
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"未授权使用相机" message:errorStr preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction         = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            
            if([[UIApplication sharedApplication] canOpenURL:url]) {
                
                NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
                
                [[UIApplication sharedApplication] openURL:url];
                
            }
        }];
        [controller addAction:sureAction];
        [self.window.rootViewController presentViewController:controller animated:YES completion:nil];
        return;
    }
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];// Device
    NSError *error;
    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];// Input
    
    _output= [[AVCaptureMetadataOutput alloc]init];// Output
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
 
    _outputVideo = [[AVCaptureVideoDataOutput alloc]init];
    [_outputVideo setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    
    _session= [[AVCaptureSession alloc]init];// Session
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    if([_session canAddInput:_input]){
        [_session addInput:_input];
    }
    if([_session canAddOutput:_output]){
        [_session addOutput:_output];
    }
    if ([self.session canAddOutput:_outputVideo]) {
        [self.session addOutput:_outputVideo];
    }
    //条码类型AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes=@[
                                        
                                        AVMetadataObjectTypeQRCode,
                                        AVMetadataObjectTypeUPCECode,
                                        AVMetadataObjectTypeEAN8Code,
                                        AVMetadataObjectTypeEAN13Code,
                                        AVMetadataObjectTypeAztecCode,
                                        AVMetadataObjectTypeCode39Code,
                                        AVMetadataObjectTypeCode93Code,
                                        AVMetadataObjectTypePDF417Code,
                                        AVMetadataObjectTypeCode128Code,
                                        AVMetadataObjectTypeCode39Mod43Code,
                                        
                                        ];
    
    dispatch_async(dispatch_get_main_queue(), ^{
    
        //更新界面
        _preview=[AVCaptureVideoPreviewLayer layerWithSession:_session];
        _preview.videoGravity=AVLayerVideoGravityResizeAspectFill;
        _preview.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
         [self.layer insertSublayer:_preview atIndex:0];
//     [_preview setAffineTransform:CGAffineTransformMakeScale(1.5,1.5)];
  
        CGRect rect = self.imageView.frame;
        [_output setRectOfInterest:CGRectMake(rect.origin.y/_preview.frame.size.height,rect.origin.x/_preview.frame.size.width,rect.size.height/ _preview.frame.size.height ,rect.size.width/ _preview.frame.size.width )];
        [_preview setAffineTransform:CGAffineTransformMakeScale(1.5,1.5)];
        self.clipsToBounds       = YES;
        self.layer.masksToBounds = YES;
    });
    
}
#pragma mark - AVCaptureMetadataOutputObjects Delegate Methods

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    [self stopScanning];
     [_beepPlayer play];
    for(AVMetadataObject *current in metadataObjects) {
        if ([current isKindOfClass:[AVMetadataMachineReadableCodeObject class]])// && [current.type isEqualToString:AVMetadataObjectTypeQRCode]
         {
            NSString *scannedResult = [(AVMetadataMachineReadableCodeObject *) current stringValue];
            if (self.QRCodeScanedResult) {
                self.QRCodeScanedResult(current ,current.type, scannedResult);
            }
        }
    }
}
#pragma mark- AVCaptureVideoDataOutputSampleBufferDelegate的方法
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    CFDictionaryRef metadataDict = CMCopyDictionaryOfAttachments(NULL,sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    NSDictionary *metadata = [[NSMutableDictionary alloc] initWithDictionary:(__bridge NSDictionary*)metadataDict];
    CFRelease(metadataDict);
    NSDictionary *exifMetadata = [[metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary] mutableCopy];
    float brightnessValue = [[exifMetadata objectForKey:(NSString *)kCGImagePropertyExifBrightnessValue] floatValue];
    
    NSLog(@"%f",brightnessValue);
    
    
    // 根据brightnessValue的值来打开和关闭闪光灯
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    BOOL result = [device hasTorch];// 判断设备是否有闪光灯
    if ((brightnessValue < 0) && result) {// 打开闪光灯
        
        [device lockForConfiguration:nil];
        
        [device setTorchMode: AVCaptureTorchModeOn];//开
        
        [device unlockForConfiguration];
        
    }else if((brightnessValue > 0) && result) {// 关闭闪光灯
        
        [device lockForConfiguration:nil];
        [device setTorchMode: AVCaptureTorchModeOff];//关
        [device unlockForConfiguration];
        
    }
}
#pragma mark - 检测相机是否可用
-(BOOL)authority{
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    if (authStatus == AVAuthorizationStatusAuthorized) {
        return YES;
    }
    return NO;
}

@end
