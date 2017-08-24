//
//  MUHookMethodHelper.m
//  Pods
//
//  Created by Jekity on 2017/8/24.
//
//

#import "MUHookMethodHelper.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

void MUHookMethodDefalut(const char * originalClassName ,SEL originalSEL ,SEL defalutSEL,const char * newClassName ,SEL newSEL)//if 'originalSEL' method not found in original Class,then we auto add a 'defalutSEL' method to it;
{
    Class originalClass = objc_getClass(originalClassName);//get a class through a string
    if (originalClass == 0) {
        NSLog(@"I can't find a class through a 'originalClassName'");
        return;
    }
    Class newClass     = objc_getClass(newClassName);
    if (newClass == 0) {
        NSLog(@"I can't find a class through a 'newClassName'");
        return;
    }
    class_addMethod(originalClass, newSEL, class_getMethodImplementation(newClass, newSEL), nil);//if newSEL not found in originalClass,it will auto add a method to this class;
    class_addMethod(originalClass, originalSEL, class_getMethodImplementation(newClass, defalutSEL), nil);///if 'originalSEL' method not found in original Class,then we auto add a 'defalutSEL' method to it;
    Method oldMethod = class_getInstanceMethod(originalClass, originalSEL);
    assert(oldMethod);
    Method newMethod = class_getInstanceMethod(originalClass, newSEL);
    assert(newMethod);
    method_exchangeImplementations(oldMethod, newMethod);
    
}

void MUHookMethod(const char * originalClassName ,SEL originalSEL ,const char * newClassName ,SEL newSEL){
    
    Class originalClass = objc_getClass(originalClassName);//get a class through a string
    if (originalClass == 0) {
        NSLog(@"I can't find a class through a 'originalClassName'");
        return;
    }
    Class newClass     = objc_getClass(newClassName);
    if (newClass == 0) {
        NSLog(@"I can't find a class through a 'newClassName'");
        return;
    }
    class_addMethod(originalClass, newSEL, class_getMethodImplementation(newClass, newSEL), nil);//if newSEL not found in originalClass,it will auto add a method to this class;
    Method oldMethod = class_getInstanceMethod(originalClass, originalSEL);
    assert(oldMethod);
    Method newMethod = class_getInstanceMethod(originalClass, newSEL);
    assert(newMethod);
    method_exchangeImplementations(oldMethod, newMethod);
}
@implementation MUHookMethodHelper
+(void)muHookMethod:(NSString *)originalClassName orignalSEL:(SEL)originalSEL newClassName:(NSString *)newClassName newSEL:(SEL)newSEL{
    
    const char * originalName = [originalClassName UTF8String];
    const char * newName      = [newClassName UTF8String];
    MUHookMethod(originalName, originalSEL, newName, newSEL);
}

+(void)muHookMethod:(NSString *)originalClassName orignalSEL:(SEL)originalSEL defalutSEL:(SEL)defalutSEL newClassName:(NSString *)newClassName newSEL:(SEL)newSEL{
    const char * originalName = [originalClassName UTF8String];
    const char * newName      = [newClassName UTF8String];
    MUHookMethodDefalut(originalName, originalSEL, defalutSEL, newName, newSEL);
}
@end
