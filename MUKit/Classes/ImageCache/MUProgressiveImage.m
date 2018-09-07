//
//  MUProgressiveImage.m
//  MUKit_Example
//
//  Created by Jekity on 2018/8/9.
//  Copyright © 2018年 Jeykit. All rights reserved.
//

#import "MUProgressiveImage.h"
#import <pthread.h>
#import <ImageIO/ImageIO.h>
#import <Accelerate/Accelerate.h>
#import "MUSpeedRecorder.h"

#if !defined(PINREMOTELOCK_DEBUG) && defined(DEBUG)
#define PINREMOTELOCK_DEBUG DEBUG
#endif

@interface MURemoteLock ()
{
#if PINREMOTELOCK_DEBUG
    NSLock *_lock;
    NSRecursiveLock *_recursiveLock;
#else
    pthread_mutex_t _lock;
#endif
}

@end

@implementation MURemoteLock

- (instancetype)init
{
    return [self initWithName:@"MUImageCacheRemoteLock"];
}

- (instancetype)initWithName:(NSString *)lockName lockType:(MURemoteLockType)lockType
{
    if (self = [super init]) {
#if PINREMOTELOCK_DEBUG
        if (lockType == MURemoteLockTypeNonRecursive) {
            _lock = [[NSLock alloc] init];
        } else {
            _recursiveLock = [[NSRecursiveLock alloc] init];
        }
        
        if (lockName) {
            [_lock setName:lockName];
            [_recursiveLock setName:lockName];
        }
#else
        pthread_mutexattr_t attr;
        
        pthread_mutexattr_init(&attr);
        if (lockType == MURemoteLockTypeRecursive) {
            pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
        }
        pthread_mutex_init(&_lock, &attr);
#endif
    }
    return self;
}

- (instancetype)initWithName:(NSString *)lockName
{
    return [self initWithName:lockName lockType:MURemoteLockTypeNonRecursive];
}

#if ! PINREMOTELOCK_DEBUG
- (void)dealloc
{
    pthread_mutex_destroy(&_lock);
}
#endif

- (void)lockWithBlock:(dispatch_block_t)block
{
#if PINREMOTELOCK_DEBUG
    [_lock lock];
    [_recursiveLock lock];
#else
    pthread_mutex_lock(&_lock);
#endif
    block();
#if PINREMOTELOCK_DEBUG
    [_lock unlock];
    [_recursiveLock unlock];
#else
    pthread_mutex_unlock(&_lock);
#endif
}

- (void)lock
{
#if PINREMOTELOCK_DEBUG
    [_lock lock];
    [_recursiveLock lock];
#else
    pthread_mutex_lock(&_lock);
#endif
}

- (void)unlock
{
#if PINREMOTELOCK_DEBUG
    [_lock unlock];
    [_recursiveLock unlock];
#else
    pthread_mutex_unlock(&_lock);
#endif
}

@end

@interface MUProgressiveImage ()

@property (nonatomic, weak) NSURLSessionTask *dataTask;
@property (nonatomic, assign) int64_t expectedNumberOfBytes;
@property (nonatomic, assign) CGImageSourceRef imageSource;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) BOOL isProgressiveJPEG;
@property (nonatomic, assign) NSUInteger currentThreshold;
@property (nonatomic, assign) NSUInteger startingBytes;
@property (nonatomic, assign) NSUInteger scannedByte;
@property (nonatomic, assign) NSInteger sosCount;
@property (nonatomic, strong) MURemoteLock *lock;
#if DEBUG
@property (nonatomic, assign) CFTimeInterval scanTime;
#endif

@end
@implementation MUProgressiveImage
@synthesize progressThresholds = _progressThresholds;
@synthesize estimatedRemainingTimeThreshold = _estimatedRemainingTimeThreshold;

- (nonnull instancetype)initWithDataTask:(nonnull NSURLSessionTask *)dataTask
{
    if (self = [super init]) {
        self.lock = [[MURemoteLock alloc] initWithName:@"MUProgressiveImage"];
        
        _dataTask = dataTask;
        _imageSource = CGImageSourceCreateIncremental(NULL);;
        self.size = CGSizeZero;
        self.isProgressiveJPEG = NO;
        self.currentThreshold = 0;
        self.progressThresholds = @[@0.00, @0.35, @0.65];
        self.estimatedRemainingTimeThreshold = -1;
        self.sosCount = 0;
        self.scannedByte = 0;
#if DEBUG
        self.scanTime = 0;
#endif
    }
    return self;
}

- (void)dealloc
{
    [self.lock lock];
    if (self.imageSource) {
        CFRelease(_imageSource);
    }
    [self.lock unlock];
}

#pragma mark - public

- (void)setProgressThresholds:(NSArray *)progressThresholds
{
    // There's no reason to set an empty progress thresholds array, instead don't use the progressive feature
    if (progressThresholds.count > 0) {
        [self.lock lock];
        _progressThresholds = [progressThresholds copy];
        [self.lock unlock];
    }
}

- (NSArray *)progressThresholds
{
    [self.lock lock];
    NSArray *progressThresholds = _progressThresholds;
    [self.lock unlock];
    return progressThresholds;
}

- (void)setEstimatedRemainingTimeThreshold:(CFTimeInterval)estimatedRemainingTimeThreshold
{
    [self.lock lock];
    _estimatedRemainingTimeThreshold = estimatedRemainingTimeThreshold;
    [self.lock unlock];
}

- (CFTimeInterval)estimatedRemainingTimeThreshold
{
    [self.lock lock];
    CFTimeInterval estimatedRemainingTimeThreshold = _estimatedRemainingTimeThreshold;
    [self.lock unlock];
    return estimatedRemainingTimeThreshold;
}

- (CFTimeInterval)estimatedRemainingTime
{
    __block CFTimeInterval estimatedRemainingTime;
    [self.lock lockWithBlock:^{
        estimatedRemainingTime = [self l_estimatedRemainingTime];
    }];
    return estimatedRemainingTime;
}

- (CFTimeInterval)l_estimatedRemainingTime
{
    if (_dataTask.countOfBytesExpectedToReceive == NSURLSessionTransferSizeUnknown) {
        return MAXFLOAT;
    }
    NSUInteger remainingBytes = (NSUInteger)_dataTask.countOfBytesExpectedToReceive - (NSUInteger)_dataTask.countOfBytesReceived;
    if (remainingBytes == 0) {
        return 0;
    }
    
    float bytesPerSecond = [[MUSpeedRecorder sharedRecorder] weightedAdjustedBytesPerSecondForHost:[_dataTask.currentRequest.URL host]];
    if (bytesPerSecond == -1) {
        return MAXFLOAT;
    }
    return remainingBytes / bytesPerSecond;
}

- (void)updateProgressiveImageWithData:(nonnull NSData *)data expectedNumberOfBytes:(int64_t)expectedNumberOfBytes
{
    [self.lock lock];
      self.expectedNumberOfBytes = expectedNumberOfBytes;
    
    while ([self l_hasCompletedFirstScan] == NO && self.scannedByte < data.length) {
#if DEBUG
        CFTimeInterval start = CACurrentMediaTime();
#endif
        NSUInteger startByte = self.scannedByte;
        if (startByte > 0) {
            startByte--;
        }
        if ([self l_scanForSOSinData:data startByte:startByte scannedByte:&_scannedByte]) {
            self.sosCount++;
        }
#if DEBUG
        CFTimeInterval total = CACurrentMediaTime() - start;
        self.scanTime += total;
#endif
    }
    
    if (self.imageSource) {
        CGImageSourceUpdateData(self.imageSource, (CFDataRef)data, NO);
        data = NULL;
    }
    [self.lock unlock];
}

- (UIImage *)currentImageBlurred:(BOOL)blurred renderedImageQuality:(out CGFloat *)renderedImageQuality dataLength:(CGFloat)length
{
    [self.lock lock];
    if (self.imageSource == nil) {
        [self.lock unlock];
        return nil;
    }
    
    if (self.currentThreshold == _progressThresholds.count) {
        [self.lock unlock];
        return nil;
    }
    
    if (_estimatedRemainingTimeThreshold > 0 && [self l_estimatedRemainingTime] < _estimatedRemainingTimeThreshold) {
        [self.lock unlock];
        return nil;
    }
    
    if ([self l_hasCompletedFirstScan] == NO) {
        [self.lock unlock];
        return nil;
    }
    
#if DEBUG
    if (self.scanTime > 0) {
        NSLog(@"scan time: %f", self.scanTime);
        self.scanTime = 0;
    }
#endif
    UIImage *currentImage = nil;
     @autoreleasepool{
         //Size information comes after JFIF so jpeg properties should be available at or before size?
         if (self.size.width <= 0 || self.size.height <= 0) {
             //attempt to get size info
             NSDictionary *imageProperties = (NSDictionary *)CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(self.imageSource, 0, NULL));
             CGSize size = self.size;
             if (size.width <= 0 && imageProperties[(NSString *)kCGImagePropertyPixelWidth]) {
                 size.width = [imageProperties[(NSString *)kCGImagePropertyPixelWidth] floatValue];
             }
             
             if (size.height <= 0 && imageProperties[(NSString *)kCGImagePropertyPixelHeight]) {
                 size.height = [imageProperties[(NSString *)kCGImagePropertyPixelHeight] floatValue];
             }
             
             self.size = size;
             
             NSDictionary *jpegProperties = imageProperties[(NSString *)kCGImagePropertyJFIFDictionary];
             NSNumber *isProgressive = jpegProperties[(NSString *)kCGImagePropertyJFIFIsProgressive];
             self.isProgressiveJPEG = jpegProperties && [isProgressive boolValue];
         }
         
         float progress = 0;
         if (self.expectedNumberOfBytes > 0) {
             progress = length / (float)self.expectedNumberOfBytes;
         }
         
         //    Don't bother if we're basically done
         if (progress >= 0.99) {
             [self.lock unlock];
             return nil;
         }
         
         if (self.isProgressiveJPEG && self.size.width > 0 && self.size.height > 0 && progress > [_progressThresholds[self.currentThreshold] floatValue]) {
             while (self.currentThreshold < _progressThresholds.count && progress > [_progressThresholds[self.currentThreshold] floatValue]) {
                 self.currentThreshold++;
             }
             NSLog(@"Generating preview image");
             CGImageRef image = CGImageSourceCreateImageAtIndex(self.imageSource, 0, NULL);
             if (image) {
                 if (blurred) {
                     currentImage = [self l_postProcessImage:[UIImage imageWithCGImage:image] withProgress:progress];
                 } else {
                     currentImage = [UIImage imageWithCGImage:image];
                 }
                 CGImageRelease(image);
                 if (renderedImageQuality) {
                     *renderedImageQuality = progress;
                 }
             }
         }
     }
    
    [self.lock unlock];
 
    return currentImage;
}


#pragma mark - private

- (BOOL)l_scanForSOSinData:(NSData *)data startByte:(NSUInteger)startByte scannedByte:(NSUInteger *)scannedByte
{
    //check if we have a complete scan
    Byte scanMarker[2];
    //SOS marker
    scanMarker[0] = 0xFF;
    scanMarker[1] = 0xDA;
    
    //scan one byte back in case we only got half the SOS on the last data append
    NSRange scanRange;
    scanRange.location = startByte;
    scanRange.length = data.length - scanRange.location;
    NSRange sosRange = [data rangeOfData:[NSData dataWithBytes:scanMarker length:2] options:0 range:scanRange];
    if (sosRange.location != NSNotFound) {
        if (scannedByte) {
            *scannedByte = NSMaxRange(sosRange);
        }
        return YES;
    }
    if (scannedByte) {
        *scannedByte = NSMaxRange(scanRange);
    }
    return NO;
}

- (BOOL)l_hasCompletedFirstScan
{
    return self.sosCount >= 2;
}

//Heavily cribbed from https://developer.apple.com/library/ios/samplecode/UIImageEffects/Listings/UIImageEffects_UIImageEffects_m.html#//apple_ref/doc/uid/DTS40013396-UIImageEffects_UIImageEffects_m-DontLinkElementID_9
- (UIImage *)l_postProcessImage:(UIImage *)inputImage withProgress:(float)progress
{
    UIImage *outputImage = nil;
    CGImageRef inputImageRef = CGImageRetain(inputImage.CGImage);
    if (inputImageRef == nil) {
        return nil;
    }
    
    CGSize inputSize = inputImage.size;
    if (inputSize.width < 1 ||
        inputSize.height < 1) {
        CGImageRelease(inputImageRef);
        return nil;
    }
    CGFloat imageScale = inputImage.scale;

    CGFloat radius = (inputImage.size.width / 25.0) * MAX(0, 1.0 - progress);
    radius *= imageScale;
    
    //we'll round the radius to a whole number below anyway,
    if (radius < FLT_EPSILON) {
        CGImageRelease(inputImageRef);
        return inputImage;
    }
    
    CGContextRef ctx;
    UIGraphicsBeginImageContextWithOptions(inputSize, YES, imageScale);
    ctx = UIGraphicsGetCurrentContext();

    
    if (ctx) {
        CGContextScaleCTM(ctx, 1.0, -1.0);
        CGContextTranslateCTM(ctx, 0, -inputSize.height);
        
        vImage_Buffer effectInBuffer;
        vImage_Buffer scratchBuffer;
        
        vImage_Buffer *inputBuffer;
        vImage_Buffer *outputBuffer;
        
        vImage_CGImageFormat format = {
            .bitsPerComponent = 8,
            .bitsPerPixel = 32,
            .colorSpace = NULL,
            // (kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little)
            // requests a BGRA buffer.
            .bitmapInfo = kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little,
            .version = 0,
            .decode = NULL,
            .renderingIntent = kCGRenderingIntentDefault
        };
        
        vImage_Error e = vImageBuffer_InitWithCGImage(&effectInBuffer, &format, NULL, inputImage.CGImage, kvImagePrintDiagnosticsToConsole);
        if (e == kvImageNoError)
        {
            e = vImageBuffer_Init(&scratchBuffer, effectInBuffer.height, effectInBuffer.width, format.bitsPerPixel, kvImageNoFlags);
            if (e == kvImageNoError) {
                inputBuffer = &effectInBuffer;
                outputBuffer = &scratchBuffer;
                
                // A description of how to compute the box kernel width from the Gaussian
                // radius (aka standard deviation) appears in the SVG spec:
                // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
                //
                // For larger values of 's' (s >= 2.0), an approximation can be used: Three
                // successive box-blurs build a piece-wise quadratic convolution kernel, which
                // approximates the Gaussian kernel to within roughly 3%.
                //
                // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
                //
                // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
                //
                if (radius - 2. < __FLT_EPSILON__)
                    radius = 2.;
                uint32_t wholeRadius = floor((radius * 3. * sqrt(2 * M_PI) / 4 + 0.5) / 2);
                
                wholeRadius |= 1; // force wholeRadius to be odd so that the three box-blur methodology works.
                
                //calculate the size necessary for vImageBoxConvolve_ARGB8888, this does not actually do any operations.
                NSInteger tempBufferSize = vImageBoxConvolve_ARGB8888(inputBuffer, outputBuffer, NULL, 0, 0, wholeRadius, wholeRadius, NULL, kvImageGetTempBufferSize | kvImageEdgeExtend);
                void *tempBuffer = malloc(tempBufferSize);
                
                if (tempBuffer) {
                    //errors can be ignored because we've passed in allocated memory
                    vImageBoxConvolve_ARGB8888(inputBuffer, outputBuffer, tempBuffer, 0, 0, wholeRadius, wholeRadius, NULL, kvImageEdgeExtend);
                    vImageBoxConvolve_ARGB8888(outputBuffer, inputBuffer, tempBuffer, 0, 0, wholeRadius, wholeRadius, NULL, kvImageEdgeExtend);
                    vImageBoxConvolve_ARGB8888(inputBuffer, outputBuffer, tempBuffer, 0, 0, wholeRadius, wholeRadius, NULL, kvImageEdgeExtend);
                    
                    free(tempBuffer);
                    
                    //switch input and output
                    vImage_Buffer *temp = inputBuffer;
                    inputBuffer = outputBuffer;
                    outputBuffer = temp;
                    
                    CGImageRef effectCGImage = vImageCreateCGImageFromBuffer(inputBuffer, &format, &cleanupBuffer, NULL, kvImageNoAllocate, NULL);
                    if (effectCGImage == NULL) {
                        //if creating the cgimage failed, the cleanup buffer on input buffer will not be called, we must dealloc ourselves
                        free(inputBuffer->data);
                    } else {
                        // draw effect image
                        CGContextSaveGState(ctx);
                        CGContextDrawImage(ctx, CGRectMake(0, 0, inputSize.width, inputSize.height), effectCGImage);
                        CGContextRestoreGState(ctx);
                        CGImageRelease(effectCGImage);
                    }
                    // Cleanup
                    free(outputBuffer->data);

                    outputImage = UIGraphicsGetImageFromCurrentImageContext();
    
                }
            } else {
                if (scratchBuffer.data) {
                    free(scratchBuffer.data);
                }
                free(effectInBuffer.data);
            }
        } else {
            if (effectInBuffer.data) {
                free(effectInBuffer.data);
            }
        }
    }
    
#if PIN_TARGET_IOS
    UIGraphicsEndImageContext();
#endif
    
    CGImageRelease(inputImageRef);
    
    return outputImage;
}

//  Helper function to handle deferred cleanup of a buffer.
static void cleanupBuffer(void *userData, void *buf_data)
{
    free(buf_data);
}

@end
