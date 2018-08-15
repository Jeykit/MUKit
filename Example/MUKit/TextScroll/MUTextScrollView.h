//
//  MUTextScrollView.h
//  ZPApp
//
//  Created by Jekity on 2018/8/9.
//  Copyright © 2018年 Jekity. All rights reserved.
//

#import <UIKit/UIKit.h>






@interface MUTextScrollView : UIView


@property(strong, nonatomic) NSArray *tittleAray;

@property (nonatomic, copy) void(^clickedTextBlock)(NSUInteger index);
// defalut 2s
@property(assign ,nonatomic) NSTimeInterval duration;

// auto scroll
@property (assign ,nonatomic, getter=isAutoScroll) BOOL autoScroll;

@property(nonatomic, assign) NSUInteger currentIndex;

@property(nonatomic, copy)void (^doneUpdateCurrentIndex)(NSUInteger index);


@end
