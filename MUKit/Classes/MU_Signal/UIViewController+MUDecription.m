//
//  UIViewController+MUDecription.m
//  elmsc
//
//  Created by Jekity on 2017/8/17.
//  Copyright © 2017年 Jekity. All rights reserved.
//

#import "UIViewController+MUDecription.h"
#import <objc/runtime.h>
#import "MUSignal.h"


@implementation UIViewController (MUDecription)
+(void)load{
    //init swizzing
//    Method  preInit = class_getInstanceMethod([UIViewController class], @selector(init));
//    
//    Method  newInit = class_getInstanceMethod([UIViewController class], @selector(MU_Init));
//    
//    method_exchangeImplementations(preInit, newInit);
    
    //dealloc swizzing
    Method  preDealloc = class_getInstanceMethod([UIViewController class], NSSelectorFromString(@"dealloc"));
    
    Method  newDealloc = class_getInstanceMethod([UIViewController class], @selector(MU_Dealloc));
    
    method_exchangeImplementations(preDealloc, newDealloc);
    
    
 
}
-(void)MU_Dealloc{
#if DEBUG
    NSLog(@"%@ ---------------  dealloc",NSStringFromClass([self class]));
#endif
    [self MU_Dealloc];
}
@end
