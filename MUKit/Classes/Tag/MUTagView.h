//
//  UITagView.h
//  ZPApp
//
//  Created by Jekity on 2018/8/14.
//  Copyright © 2018年 Jekity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MUTagView : UIView
/**
 array 如果不是字符串数组，则需要手动在configuredLabel进行类型转换并给label赋值
 */
- (instancetype)initWithFrame:(CGRect)frame withAarray:(NSArray *)array itemHeight:(CGFloat)itemHeight;
/**
 array 如果不是字符串数组，则需要手动在configuredLabel进行类型转换并给label赋值
 */
- (instancetype)initWithFrame:(CGRect)frame withAarray:(NSArray *)array;
/**
 可对label样式进行自定义，如果不设置则使用默认的，
 */
@property (nonatomic,copy) void (^configuredLabel)(UILabel *label ,NSUInteger index ,id model);
/**
 label点击后的响应block
 */
@property (nonatomic,copy) void (^TapedLabel)(UILabel *label ,NSUInteger index ,id model);
@property (nonatomic,assign ,readonly) CGFloat needHeight;
@end
