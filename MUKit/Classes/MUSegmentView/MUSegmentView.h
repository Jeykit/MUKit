//
//  MUSegmentView.h
//  ZPApp
//
//  Created by Jekity on 2018/9/18.
//  Copyright © 2018年 Jekity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MUSegmentAppearance.h"
#import "MUSegment.h"


typedef NS_ENUM(NSUInteger ,MUSegmentOrganiseMode) {
    
     MUSegmentOrganiseModeHorizontal = 1,
     MUSegmentOrganiseModeVertical
};
NS_ASSUME_NONNULL_BEGIN

@interface MUSegmentView : UIControl

@property (nonatomic,assign) MUSegmentOrganiseMode organiseMode;

@property (nonatomic,assign) NSUInteger maxinumCount;

@property (nonatomic,assign) NSInteger selectedSegmentIndex;

- (instancetype)initWithFrame:(CGRect)frame dividerColor:(UIColor *)dividerColor dividerWidth:(CGFloat)dividerWidth;
- (void)addSegmentWithSegment:(MUSegment *)segment;
@end

NS_ASSUME_NONNULL_END
