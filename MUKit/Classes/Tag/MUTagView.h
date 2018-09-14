//
//  UITagView.h
//  ZPApp
//
//  Created by Jekity on 2018/8/14.
//  Copyright © 2018年 Jekity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MUTagView : UIView

@property (nonatomic,assign) CGFloat itemHeight;

@property (nonatomic,assign) CGFloat itemWidth;

@property (nonatomic,assign) CGFloat margain;
//
@property (nonatomic,strong) NSArray *modelArray;
//
@property (nonatomic,copy) void (^configured)(UILabel *label ,NSUInteger index ,id model);
/**
 label点击后的响应block
 */
@property (nonatomic,copy) void (^TapedLabel)(UILabel *label ,NSUInteger index ,id model);

@property (nonatomic,assign ,readonly) CGFloat needHeight;
@end
