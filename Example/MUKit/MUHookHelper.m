//
//  MUHookHelper.m
//  MUKit
//
//  Created by Jekity on 2017/8/24.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "MUHookHelper.h"
#import <MUHookMethodHelper.h>



@implementation MUHookHelper
+ (void)load
{
    NSLog(@"MUHookHelper load");
   

//    [MUHookMethodHelper muHookMethod:@"MUKitDemoAppDelegate" orignalSEL:@selector(application:didFinishLaunchingWithOptions:) defalutSEL:@selector(defaultApplication:didFinishLaunchingWithOptions:) newClassName:@"MUHookHelper" newSEL:@selector(hookedApplication:didFinishLaunchingWithOptions:)];
//  
//    [MUHookMethodHelper muHookMethod:@"MUKitDemoAppDelegate" orignalSEL:@selector(application:handleOpenURL:) defalutSEL:@selector(defaultApplication:handleOpenURL:) newClassName:@"MUHookHelper" newSEL:@selector(hookedApplication:handleOpenURL:)];
 
    [MUHookMethodHelper muHookMethod:@"MUKitDemoAppDelegate" orignalSEL:@selector(application:didFinishLaunchingWithOptions:) newClassName:@"MUHookHelper" newSEL:@selector(hookedApplication:didFinishLaunchingWithOptions:)];
    
//    [MUHookMethodHelper muHookMethod:@"MUKitDemoAppDelegate" orignalSEL:@selector(application:handleOpenURL:) newClassName:@"MUHookHelper" newSEL:@selector(hookedApplication:handleOpenURL:)];

//    hookMethod(@selector(application:openURL:sourceApplication:annotation:)
//               , @selector(defaultApplication:openURL:sourceApplication:annotation:)
//               , @selector(hookedApplication:openURL:sourceApplication:annotation:));
//    
////    hookMethod(@selector(application:supportedInterfaceOrientationsForWindow:)
////               , @selector(defaultApplication:supportedInterfaceOrientationsForWindow:)
////               , @selector(hookedApplication:supportedInterfaceOrientationsForWindow:)
////               );
//    hookMethod(@selector(applicationDidBecomeActive:)
//               , @selector(defaultApplicationDidBecomeActive:)
//               , @selector(hookedApplicationDidBecomeActive:)
//               );
    
//    hookMethod(@selector(init)
//               , @selector(init)
//               , @selector(hookedInit)
//               );
}
-(BOOL)hookedApplication:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)dic
{
    
    NSLog(@"hooked didFinishLaunchingWithOptions");
    [self hookedApplication:application didFinishLaunchingWithOptions:dic];
    return YES;
}

-(id)hookedInit
{
    NSLog(@"hooked init!!!");
    return [self hookedInit];
}

- (BOOL)hookedApplication:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    NSLog(@"hooked handleOpenURL");
    [self hookedApplication:application handleOpenURL:url];
    return YES;
}

- (BOOL)hookedApplication:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"hooked openURL sourceApplication annotation");
    [self hookedApplication:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    return YES;
}

//- (NSUInteger) hookedApplication:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
//{
//    NSLog(@"hooked supportedInterfaceOrientationsForWindow");
//    [self hookedApplication:application supportedInterfaceOrientationsForWindow:window ];
//    return 0;
//}

//- (void)hookedApplicationDidBecomeActive:(UIApplication *)application
//{
//    [self hookedApplicationDidBecomeActive:application];
//    NSLog(@"hooked applicationDidBecomeActive");
//}
//
//
- (BOOL)defaultApplication:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)dic{
    
    
    
    return YES;
}
- (BOOL)defaultApplication:(UIApplication *)application handleOpenURL:(NSURL *)url{return YES;}
- (BOOL)defaultApplication:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{return YES;}
- (NSUInteger) defaultApplication:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{return 0;}
//- (void)defaultApplicationDidBecomeActive:(UIApplication *)application{}
//- (id)init
//{
//    self = [super init];
//    if (self) {
//        
//    }
//    return self;
//}
@end
