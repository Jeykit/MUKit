//
//  UIViewController+MUDecription.m
//  elmsc
//
//  Created by Jekity on 2017/8/17.
//  Copyright © 2017年 Jekity. All rights reserved.
//

#import "UIViewController+MUDecription.h"
#import <objc/runtime.h>
#import "MUViewControllerDidLoadModel.h"
#import "MUSignal.h"


static NSString  * const MUNavigationBarItem = @"Click_MUNavigationBarItemWithTitle_";
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
    
    
    //viewDidLoad swizzing
    Method  preViewDidload = class_getInstanceMethod([UIViewController class], @selector(viewDidLoad));
    
    Method  newViewDidload = class_getInstanceMethod([UIViewController class], @selector(MU_ViewDidLoad));
    
    method_exchangeImplementations(preViewDidload, newViewDidload);
}
-(void)setTitle:(NSString *)title color:(UIColor *)color{
    
    self.title = title;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:color};
}
-(void)MU_Dealloc{
#if DEBUG
    NSLog(@"%@ ---------------  dealloc",NSStringFromClass([self class]));
#endif
    [self MU_Dealloc];
}

//-(void)MU_Init{
//    
//    [[MUViewControllerDidLoadModel sharedInstance].hashTabel addObject:self];
//    [self MU_Init];
//}
-(void)MU_ViewDidLoad{
//    [self Click_MUNavigationBarItemWithTitle_123:nil];
//    Class currentClass=[self class];
//    while (currentClass) {
//        unsigned int methodCount;
//        Method *methodList = class_copyMethodList(currentClass, &methodCount);
//        unsigned int i = 0;
//        for (; i < methodCount; i++) {
//            NSLog(@"%@ - %@", [NSString stringWithCString:class_getName(currentClass) encoding:NSUTF8StringEncoding], [NSString stringWithCString:sel_getName(method_getName(methodList[i])) encoding:NSUTF8StringEncoding]);
//        }
//        
//        free(methodList);
//        currentClass = class_getSuperclass(currentClass);
//    }
    [self MU_ViewDidLoad];
  
}
//Click_MUNavigationBarItemWithTitle(123){
//    
//}
@end
