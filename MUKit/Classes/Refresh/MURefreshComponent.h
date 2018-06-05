//
//  MURefreshComponent.h
//  Pods
//
//  Created by Jekity on 2017/9/1.
//
//

#import <UIKit/UIKit.h>
#import "UIView+MUNormal.h"


typedef NS_ENUM(NSUInteger ,MURefreshingState){
    MURefreshStateNone            = 1,
    MURefreshStateScrolling,
    MURefreshStateReady,
    MURefreshStateRefreshing,
    MURefreshStateWillEndRefresh
};

@interface MURefreshComponent : UIView
@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView; //UIActivityIndicatorView

/**
 Block will be called when refreshing
 */
@property (copy, nonatomic) void (^refreshHandler)(MURefreshComponent * component);

/**
 The threshold for trigger refresh default 1.0 must be set to not less than 1.0,
 
 default value is 1.3, developers can set the value
 */
@property (assign, nonatomic) CGFloat stretchOffsetYAxisThreshold;
/**
 the current position offset of the control as a percentage
 
 of the offset that triggered the refresh
 */
@property (assign, nonatomic) CGFloat progress;
/**
 The UIScrollView to which the control is added, developers may not set
 */
@property (nonatomic, weak, readonly) __kindof UIScrollView *scrollView;

/**
 Whether it is refreshing
 */
@property (nonatomic, readonly, getter=isRefresh) BOOL refresh;

/**
 Control refresh status, developers may not set
 */
@property (nonatomic) MURefreshingState refreshState;

/**
 When the system automatically or manually adjust contentInset,
 
 this value will be saved
 */
@property (assign, nonatomic) UIEdgeInsets preSetContentInsets;

/**
 This value is set to TRUE if the beginRefresh method is called automatically
 
 developers may not set
 */
@property (assign, nonatomic, getter = isAutoRefreshing) BOOL autoRefreshing;

/**
 * when the state of the refresh control changes, the method is called
 *
 * @state KafkaRefreshState
 */
- (void)MURefreshStateDidChange:(MURefreshingState)state;

/**
 * when the state of the refresh control changes, the method is called
 *
 * @progress  the current position offset of the control as a percentage of the offset that triggered the refresh
 *
 * @max the offset that triggered the refresh
 */
- (void)MUDidScrollWithProgress:(CGFloat)progress max:(const CGFloat)max;
/**
 Judge whether the animation is executed when the refresh is over
 */
@property (assign, nonatomic, getter=isAnimating) BOOL animating;

 /**
 if called method "endRefreshingAndNoLongerRefreshingWithAlertText:" to end refresh,
 shouldNoLongerRefresh will set TRUE.
 */
@property (assign, nonatomic,readonly, getter=isShouldNoLongerRefresh) BOOL shouldNoLongerRefresh;
/**
 Called right after initialization is completed
 */
- (void)setupProperties;

/**
 fill colors for points, lines, and faces that appear in this control.
 */
@property (strong, nonatomic) UIColor *textColor;

/**
 When this method is called to end the refresh, there will be a 1.5 second
 animated display of "text". Please note that the length of text, please
 try to be brief, otherwise it will be cut off.
 
 @param text default is nil, and no animation.
 @param completion when text is hidden, this block will be called.
 */
- (void)endRefreshingWithText:(NSString *)text completion:(dispatch_block_t)completion;

/*
 Subclasses override this method
 */
- (void)privateContentOffsetOfScrollViewDidChange:(CGPoint)contentOffset;
- (void)setScrollViewToRefreshLocation;
- (void)setScrollViewToOriginalLocation;

/**
 Trigger refresh
 */
- (void)beginRefreshing;

/**
 end refresh
 */
- (void)endRefreshing;

/**
 [UIView animateWithDuration:0.25
 delay:0
 options:UIViewAnimationOptionCurveLinear
 animations:block
 completion:^(BOOL finished) {
 if (completion) completion();
 }];
 */
- (void)setAnimateBlock:(dispatch_block_t)block completion:(dispatch_block_t)completion;
@end
