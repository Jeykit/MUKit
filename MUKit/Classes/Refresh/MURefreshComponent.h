//
//  MURefreshComponent.h
//  Pods
//
//  Created by Jekity on 2017/9/1.
//
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger ,MURefreshingState){
    MURefreshingStateNormal = 0,
    MURefreshingStateWillRefresh,
    MURefreshingStateRefreshing,
    MURefreshingStateRefreDone,
    MURefreshingStateNoMoreData
};

typedef NS_ENUM(NSUInteger ,MURefreshingType) {
    
    MURefreshingTypeHeader = 0,
    MURefreshingTypeFooter
};

@interface MURefreshComponent : UIView
@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView; //UIActivityIndicatorView

-(instancetype)initWithFrame:(CGRect)frame type:(MURefreshingType)type backgroundImage:(UIImage *)backgroundImage;
-(void)updateRefreshing:(MURefreshingType)type state:(MURefreshingState)state;
@end
