//
//  MUSegmentAppearance.h
//  ZPApp
//
//  Created by Jekity on 2018/9/18.
//  Copyright © 2018年 Jekity. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger  ,MUTitleGravityStyle){
    
    MUTitleGravityStyleRight = 0,
    MUTitleGravityStyleBottom = 1,
    MUTitleGravityStyleLeft =  2,
    MUTitleGravityStyleTop = 3
};

NS_ASSUME_NONNULL_BEGIN

@interface MUSegmentAppearance : NSObject

@property (nonatomic,strong) UIFont *titleFont;

@property (nonatomic,strong) UIFont *titleHightlightFont;

@property (nonatomic,strong) UIColor *titleColor;

@property (nonatomic,strong) UIColor *titleHightlightColor;

@property (nonatomic,assign) MUTitleGravityStyle titleGravityStyle;

@property (nonatomic,strong) UIImage *iconImage;

@property (nonatomic,strong) UIImage *iconHightlightImage;

@property (nonatomic,strong) UIColor *segmentColor;

@property (nonatomic,strong) UIColor *segmentHightlightColor;

@property (nonatomic,assign) CGFloat contentVerticalMargin;

@property (nonatomic,copy) NSString *titleString;

- (UIColor *)segmentTouchDownColor;
@end

NS_ASSUME_NONNULL_END
