//
//  NSObject+MUSignal.m
//  elmsc
//
//  Created by Jekity on 2017/8/17.
//  Copyright © 2017年 Jekity. All rights reserved.
//

#import "NSObject+MUSignal.h"
#import <objc/runtime.h>
#import <objc/message.h>


#import "MUViewControllerDidLoadModel.h"
static NSString const * havedSignal = @"havedSignal_";
@implementation NSObject (MUSignal)

+(void)load{
    
    [[self class] sharedViewControllerArray];
}

+(NSMutableArray *)sharedViewControllerArray{
    
    static NSMutableArray *mArray = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mArray = [NSMutableArray array];
    });
    return mArray;
}

-(void)sendSignal:(NSString *)signalName className:(NSString *)target object:(id)object {
    
    if (!signalName || !target) {
        
        NSLog(@"The method can not be perform if the signalName or object is nil.");
        return;
    }
    
    id responsedObject;
    
    NSEnumerator *enumerrator = [[MUViewControllerDidLoadModel sharedInstance].hashTabel objectEnumerator];
    
    for (id viewController in enumerrator) {
        
        NSString *controllerString = NSStringFromClass([viewController class]);
        if ([controllerString isEqualToString:target]) {
            
            responsedObject = viewController;
            break;
        }
    }
    // Class responsedClass = NSClassFromString(target);
    
    // id responsedObject;
    
    //create a instance with Class
    // #if __has_feature(objc_arc)
    
    // responsedObject = [[responsedClass alloc] init];
    
    // #else
    
    // responsedObject = [[[responsedClass alloc] init] autorelease];
    
    // #endif
    
    //havedSignal_click:
    signalName = [havedSignal stringByAppendingString:signalName];
    
    signalName = [NSString stringWithFormat:@"%@:",signalName];
    
    SEL selector = NSSelectorFromString(signalName);
    
    if (responsedObject != nil&&[responsedObject respondsToSelector:selector]) {
        
        void(*action)(id,SEL,id) = (void(*)(id,SEL,id))objc_msgSend;
        
        action(responsedObject,selector,object);
    }else{
        
        NSLog(@"The target is not found.The selector will not be perform!");
    }
    
    
}

-(void)sendSignal:(NSString *)signalName target:(NSObject *)target object:(id)object{
    
    if (!signalName || !target) {
        
        NSLog(@"The method can not be perform if the signalName or target is nil.");
        return;
    }
    signalName = [havedSignal stringByAppendingString:signalName];
    
    signalName = [NSString stringWithFormat:@"%@:",signalName];
    
    SEL selector = NSSelectorFromString(signalName);
    
    /**end*/
    if ([target respondsToSelector:selector]) {
        
        void(*action)(id,SEL,id) = (void(*)(id,SEL,id))objc_msgSend;
        
        action(target,selector,object);
    }else{
        
        NSLog(@"The target is not found.The selector will not be perform!");
    }
    
}

-(void)sendSignal:(NSString *)signalName target:(NSObject *)target{
    
    [self sendSignal:signalName target:target object:nil];
}

-(id)getViewControllerFromString:(NSString *)viewControllerString{
    
    id responsedObject = nil;
    
    NSEnumerator *enumerrator = [[MUViewControllerDidLoadModel sharedInstance].hashTabel objectEnumerator];
    
    for (id viewController in enumerrator) {
        
        NSString *controllerString = NSStringFromClass([viewController class]);
        if ([controllerString isEqualToString:viewControllerString]) {
            
            responsedObject = viewController;
        }
    }
    return responsedObject;
}
@end
