//
//  UIApplication+MUSignal.m
//  MUKit_Example
//
//  Created by Jekity on 2019/1/25.
//  Copyright © 2019 Jeykit. All rights reserved.
//

#import "UIApplication+MUSignal.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation UIApplication (MUSignal)
+(void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL safeSel=@selector(sendEvent:);
        SEL unsafeSel=@selector(MUSignal_sendEvent:);
        Class myClass = [self class];
        Method safeMethod=class_getInstanceMethod (myClass, safeSel);
        Method unsafeMethod=class_getInstanceMethod (myClass, unsafeSel);
        method_exchangeImplementations(unsafeMethod, safeMethod);
        
    });
    
    
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
- (void)MUSignal_sendEvent:(UIEvent *)event
{
    NSSet *set= event.allTouches;
    NSArray *array=[set allObjects];
    UITouch *touchEvent= [array lastObject];
    UIView *view=[touchEvent view];
    
    
    
    if (touchEvent.phase==UITouchPhaseEnded) {
        CGPoint point = [touchEvent locationInView:view];
        UIView *fitview = [self hitTest:point withEvent:event withView:view];
        
        if(fitview)
        {
             void(*action)(id,SEL,id,id) = (void(*)(id,SEL,id,id))objc_msgSend;
             action(fitview,@selector(MUTouchesEnded: withEvent:),set,event);
        }
    }
    
    [self MUSignal_sendEvent:event];
    
    
}
#pragma clang diagnostic pop
// 因为所有的视图类都是继承BaseView
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event withView:(UIView *)view{
    // 1.判断当前控件能否接收事件
    if (view.userInteractionEnabled == NO || view.hidden == YES || view.alpha <= 0.01) return nil;
    // 2. 判断点在不在当前控件
    if ([view pointInside:point withEvent:event] == NO) return nil;
    // 3.从后往前遍历自己的子控件
    NSInteger count = view.subviews.count;
    for (NSInteger i = count - 1; i >= 0; i--) {
        UIView *childView = view.subviews[i];
        // 把当前控件上的坐标系转换成子控件上的坐标系
        CGPoint childP = [view convertPoint:point toView:childView];
        UIView *fitView = [childView hitTest:childP withEvent:event];
        if (fitView) { // 寻找到最合适的view
            return fitView;
        }
    }
    // 循环结束,表示没有比自己更合适的view
    return view;
    
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    
    return YES;
}
@end
