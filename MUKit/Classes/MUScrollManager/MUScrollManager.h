//
//  MUScrollManager.h
//  ZPWApp_Example
//
//  Created by Jekity on 2018/5/28.
//  Copyright © 2018年 Jekity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MUScrollManager : NSObject

/**
 @param scrollView MUScrollManager不会持有传递过来的scrollView
 @param nestScrollView MUScrollManager不会持有传递过来的nestScrollView
 @param offset 偏移的距离
 这个方法的意思是scrollView嵌套nestScrollView，当scrollView滚动offset时，nestScrollView才会滚动
 */
-(instancetype)initWithScrollView:(UIScrollView *)scrollView nestedScrollView:(UIScrollView *)nestScrollView offset:(CGFloat)offset;

//菜单的高度
@property (nonatomic,assign) CGFloat marginHeight;

//偏移的距离
@property (nonatomic,assign) CGFloat offsetMU;

//被嵌套的UIScrollView
@property (nonatomic,weak) UIScrollView *nestScrollViewMU;
@end
