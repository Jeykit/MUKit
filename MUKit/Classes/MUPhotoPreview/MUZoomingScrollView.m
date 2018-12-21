//
//  MUZoomingScrollView.m
//  MUKit_Example
//
//  Created by Jekity on 2017/11/10.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "MUZoomingScrollView.h"
#import <objc/runtime.h>

@interface MUPhotoPlayVideoView : UIView

@end


@implementation MUPhotoPlayVideoView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void)drawRect:(CGRect)rect
{
    [[[UIColor whiteColor] colorWithAlphaComponent:.8] setFill];
    // Draw rounded square
    UIBezierPath *squarePath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:CGRectGetWidth(self.bounds)/2];
    squarePath.lineWidth = 1.0;
    squarePath.lineCapStyle = kCGLineCapRound; //线条拐角
    squarePath.lineJoinStyle = kCGLineJoinRound; //终点处理
    [squarePath fill];
    [[UIColor lightGrayColor] setStroke];
    [squarePath stroke];
    
    // Draw triangle
    CGFloat margain = CGRectGetWidth(self.bounds)/2.*.62;
    [[UIColor lightGrayColor] setFill];
    UIBezierPath *trianglePath = [UIBezierPath bezierPath];
    [trianglePath moveToPoint:CGPointMake(CGRectGetWidth(self.bounds)/2.+ margain, CGRectGetHeight(self.bounds)/2.)];
    [trianglePath addLineToPoint:CGPointMake(CGRectGetWidth(self.bounds)/2. - margain/2,CGRectGetWidth(self.bounds)/2.+margain)];
    [trianglePath addLineToPoint:CGPointMake(CGRectGetWidth(self.bounds)/2.- margain/2,CGRectGetWidth(self.bounds)/2.-margain)];
    trianglePath.lineWidth = 1.0;
    trianglePath.lineCapStyle = kCGLineCapRound; //线条拐角
    trianglePath.lineJoinStyle = kCGLineJoinRound; //终点处理
    [trianglePath closePath];
    [[UIColor whiteColor] setStroke];
    [trianglePath fill];
}

@end
@interface MUZoomingScrollView()
@property(nonatomic, strong)MUTapDetectingView *tapView;
@property(nonatomic, strong)MUTapDetectingImageView *photoImageView;
@property (nonatomic,strong)MUPhotoPlayVideoView  *videoIndicatorView;
@end

@implementation MUZoomingScrollView

-(instancetype)init{
    if (self = [super init]) {
        // Tap view for background
        _tapView = [[MUTapDetectingView alloc] initWithFrame:self.bounds];
        _tapView.tapDelegate = self;
        _tapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tapView.backgroundColor = [UIColor blackColor];
        [self addSubview:_tapView];
        
        // Image view
        _photoImageView = [[MUTapDetectingImageView alloc] initWithFrame:CGRectZero];
        _photoImageView.tapDelegate = self;
        _photoImageView.contentMode = UIViewContentModeCenter;
        _photoImageView.backgroundColor = [UIColor blackColor];
        [self addSubview:_photoImageView];
        
        _imageView = [UIImageView new];
        [_imageView addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        //        _imageView.image;
        
        _videoIndicatorView =  [[MUPhotoPlayVideoView alloc]initWithFrame:CGRectMake(0,0, 60., 60.)];
        _videoIndicatorView.hidden = YES;
        [self addSubview:_videoIndicatorView];
        
        // Setup
        self.backgroundColor = [UIColor blackColor];
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return self;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context

{
    
    if ([keyPath isEqualToString:@"image"]) {
        UIImageView *imageView = object;
        if (imageView.image != nil) {
            self.image = imageView.image;
            
        }
        
    }
    
}
-(void)setImage:(UIImage *)image{
    if (image == nil) {
        return;
    }
    _image = image;
    [self displayImage:_image];
}
// Get and display image
- (void)displayImage:(UIImage *)image {
    // Reset
    self.maximumZoomScale = 1;
    self.minimumZoomScale = 1;
    self.zoomScale = 1;
    self.contentSize = CGSizeMake(0, 0);
    
    // Get image from browser as it handles ordering of fetching
    if (image) {
        
        // Set image
        _photoImageView.image = image;
        _photoImageView.hidden = NO;
        
        // Setup photo frame
        CGRect photoImageViewFrame;
        photoImageViewFrame.origin = CGPointZero;
        photoImageViewFrame.size = image.size;
        _photoImageView.frame = photoImageViewFrame;
        self.contentSize = photoImageViewFrame.size;
        
        // Set zoom to minimum zoom
        [self setMaxMinZoomScalesForCurrentBounds];
        
    }
    [self setNeedsLayout];
}
#pragma mark - Setup

- (CGFloat)initialZoomScaleWithMinScale {
    CGFloat zoomScale = self.minimumZoomScale;
    if (_photoImageView) {
        // Zoom image to fill if the aspect ratios are fairly similar
        CGSize boundsSize = self.bounds.size;
        CGSize imageSize = _photoImageView.image.size;
        CGFloat boundsAR = boundsSize.width / boundsSize.height;
        CGFloat imageAR = imageSize.width / imageSize.height;
        CGFloat xScale = boundsSize.width / imageSize.width;    // the scale needed to perfectly fit the image width-wise
        CGFloat yScale = boundsSize.height / imageSize.height;  // the scale needed to perfectly fit the image height-wise
        // Zooms standard portrait images on a 3.5in screen but not on a 4in screen.
        if (ABS(boundsAR - imageAR) < 0.17) {
            zoomScale = MAX(xScale, yScale);
            // Ensure we don't zoom in or out too far, just in case
            zoomScale = MIN(MAX(self.minimumZoomScale, zoomScale), self.maximumZoomScale);
        }
    }
    return zoomScale;
}

- (void)setMaxMinZoomScalesForCurrentBounds {
    
    // Reset
    self.maximumZoomScale = 1;
    self.minimumZoomScale = 1;
    self.zoomScale = 1;
    
    // Bail if no image
    if (_photoImageView.image == nil) return;
    
    // Reset position
    _photoImageView.frame = CGRectMake(0, 0, _photoImageView.frame.size.width, _photoImageView.frame.size.height);
    
    // Sizes
    CGSize boundsSize = self.bounds.size;
    CGSize imageSize = _photoImageView.image.size;
    
    // Calculate Min
    CGFloat xScale = boundsSize.width / imageSize.width;    // the scale needed to perfectly fit the image width-wise
    CGFloat yScale = boundsSize.height / imageSize.height;  // the scale needed to perfectly fit the image height-wise
    CGFloat minScale = MIN(xScale, yScale);                 // use minimum of these to allow the image to become fully visible
    
    // Calculate Max
    CGFloat maxScale = 3;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // Let them go a bit bigger on a bigger screen!
        maxScale = 4;
    }
    
    // Image is smaller than screen so no zooming!
    if (xScale >= 1 && yScale >= 1) {
        minScale = 1.0;
    }
    
    // Set min/max zoom
    self.maximumZoomScale = maxScale;
    self.minimumZoomScale = minScale;
    
    // Initial zoom
    self.zoomScale = [self initialZoomScaleWithMinScale];
    
    // If we're zooming to fill then centralise
    if (self.zoomScale != minScale) {
        
        // Centralise
        self.contentOffset = CGPointMake((imageSize.width * self.zoomScale - boundsSize.width) / 2.0,
                                         (imageSize.height * self.zoomScale - boundsSize.height) / 2.0);
        
    }
    
    // Disable scrolling initially until the first pinch to fix issues with swiping on an initally zoomed in photo
    self.scrollEnabled = NO;
    // Layout
    [self setNeedsLayout];
    
}
#pragma mark - Layout

- (void)layoutSubviews {
    
    // Update tap view frame
    _tapView.frame = self.bounds;
    // Super
    [super layoutSubviews];
    
    // Center the image as it becomes smaller than the size of the screen
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = _photoImageView.frame;
    
    // Horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = floorf((boundsSize.width - frameToCenter.size.width) / 2.0);
    } else {
        frameToCenter.origin.x = 0;
    }
    // Vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = floorf((boundsSize.height - frameToCenter.size.height) / 2.0);
    } else {
        frameToCenter.origin.y = 0;
    }
    
    // Center
    if (!CGRectEqualToRect(_photoImageView.frame, frameToCenter))
        _photoImageView.frame = frameToCenter;
    if (self.mediaType == 2) {
        _videoIndicatorView.hidden = NO;
        _videoIndicatorView.center = _photoImageView.center;
        
    }else{
        _videoIndicatorView.hidden = YES;
    }
    
}
#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _photoImageView;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([self.tapDelegate respondsToSelector:@selector(muZoomingScrollViewDragging:cancle:)]) {
        
        [self.tapDelegate muZoomingScrollViewDragging:self cancle:YES];
    }
}
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    self.scrollEnabled = YES; // reset
    if ([self.tapDelegate respondsToSelector:@selector(muZoomingScrollViewDragging:cancle:)]) {
        
        [self.tapDelegate muZoomingScrollViewDragging:self cancle:YES];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([self.tapDelegate respondsToSelector:@selector(muZoomingScrollViewDragging:cancle:)]) {
        
        [self.tapDelegate muZoomingScrollViewDragging:self cancle:NO];
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self setNeedsLayout];
    [self layoutIfNeeded];
}
#pragma mark - Tap Detection

- (void)handleDoubleTap:(CGPoint)touchPoint {
    // Zoom
    if (self.zoomScale != self.minimumZoomScale && self.zoomScale != [self initialZoomScaleWithMinScale]) {
        
        // Zoom out
        [self setZoomScale:self.minimumZoomScale animated:YES];
        
    } else {
        
        // Zoom in to twice the size
        CGFloat newZoomScale = ((self.maximumZoomScale + self.minimumZoomScale) / 2);
        CGFloat xsize = self.bounds.size.width / newZoomScale;
        CGFloat ysize = self.bounds.size.height / newZoomScale;
        [self zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
        
    }
    if ([self.tapDelegate respondsToSelector:@selector(muZoomingScrollViewDragging:cancle:)]) {
        
        [self.tapDelegate muZoomingScrollViewDragging:self cancle:NO];
    }
    
}
- (void)handleSingleTap:(CGPoint)touchPoint {
    
    if ([self.tapDelegate respondsToSelector:@selector(muZoomingScrollView:mediaType:)]) {
        
        [self.tapDelegate muZoomingScrollView:self mediaType:self.mediaType];
    }
}

// Image View
- (void)imageView:(UIImageView *)imageView doubleTapDetected:(UITouch *)touch {
    [self handleDoubleTap:[touch locationInView:imageView]];
}
-(void)imageView:(UIImageView *)imageView singleTapDetected:(UITouch *)touch{
    if (self.mediaType == 2) {
        if ([self.tapDelegate respondsToSelector:@selector(muPlayVideo:mediaType:)]) {
            [self.tapDelegate muPlayVideo:self mediaType:self.mediaType];
        }
    }else{
        
        [self handleSingleTap:[touch locationInView:imageView]];
    }
}
// Background View
- (void)view:(UIView *)view singleTapDetected:(UITouch *)touch {
    // Translate touch location to image view location
    CGFloat touchX = [touch locationInView:view].x;
    CGFloat touchY = [touch locationInView:view].y;
    touchX *= 1/self.zoomScale;
    touchY *= 1/self.zoomScale;
    touchX += self.contentOffset.x;
    touchY += self.contentOffset.y;
    [self handleSingleTap:CGPointMake(touchX, touchY)];
    
}
- (void)view:(UIView *)view doubleTapDetected:(UITouch *)touch {
    // Translate touch location to image view location
    CGFloat touchX = [touch locationInView:view].x;
    CGFloat touchY = [touch locationInView:view].y;
    touchX *= 1/self.zoomScale;
    touchY *= 1/self.zoomScale;
    touchX += self.contentOffset.x;
    touchY += self.contentOffset.y;
    [self handleDoubleTap:CGPointMake(touchX, touchY)];
}
- (void)dealloc{
    [_imageView removeObserver:self forKeyPath:@"image"];
}
@end
