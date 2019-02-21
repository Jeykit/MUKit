//
//  MUKitDemoAppDelegate.m
//  MUKit
//
//  Created by Jeykit on 08/17/2017.
//  Copyright (c) 2017 Jeykit. All rights reserved.
//

#import "MUKitDemoAppDelegate.h"
#import "MUKitDemoTableViewController.h"
#import "MUNavigation.h"
#import "UIImage+MUColor.h"
#import <MUNavigationController.h>
#import "MULaunchImageADView.h"
#import "MUKeychainUtil.h"

NSString * const KEY_USERNAME = @"com.company.app.username";
NSString * const KEY_PASSWORD = @"com.company.app.password";
NSString * const KEY_USERNAME_PASSWORD = @"com.company.app.usernamepassword";
@implementation MUKitDemoAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSMutableDictionary *userNamePasswordKVPairs = [NSMutableDictionary dictionary];
    [userNamePasswordKVPairs setObject:@"userName" forKey:KEY_USERNAME];
    [userNamePasswordKVPairs setObject:@"password" forKey:KEY_PASSWORD];
    NSLog(@"%@", userNamePasswordKVPairs); //有KV值
    
    id data =   [MUKeychainUtil getDataInKeyChainWithKey:KEY_USERNAME_PASSWORD];
    if (data) {
        // B、从keychain中读取用户名和密码
        NSMutableDictionary *readUsernamePassword = [MUKeychainUtil getDataInKeyChainWithKey:KEY_USERNAME_PASSWORD];
        NSString *userName = [readUsernamePassword objectForKey:KEY_USERNAME];
        NSString *password = [readUsernamePassword objectForKey:KEY_PASSWORD];
        NSLog(@"username = %@", userName);
        NSLog(@"password = %@", password);
    }else{
        // A、将用户名和密码写入keychain
        [MUKeychainUtil saveDataInKeyChain:KEY_USERNAME_PASSWORD data:userNamePasswordKVPairs];
    }
    
    
    // B、从keychain中读取用户名和密码
//    NSMutableDictionary *readUsernamePassword = [MUKeychainUtil getDataInKeyChainWithKey:KEY_USERNAME_PASSWORD];
//    NSString *userName = [readUsernamePassword objectForKey:KEY_USERNAME];
//    NSString *password = [readUsernamePassword objectForKey:KEY_PASSWORD];
    
  
    
    // C、将用户名和密码从keychain中删除
//    [MUKeychainUtil deleteDataInKeyChain:KEY_USERNAME_PASSWORD];
    // Override point for customization after application launch.
    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];

    MULaunchImageADView *adView = [[MULaunchImageADView alloc]initWithFrame:kScreenBounds];
    adView.carouselView.autoScroll = NO;
    adView.ADConfigured = ^(UIImageView * _Nonnull imageView, NSUInteger index, id  _Nonnull model) {
        
        [imageView setImageURLString:model];
    };
    adView.carouselView.imageArray = @[@"http://img.zcool.cn/community/01316b5854df84a8012060c8033d89.gif"];
    //全局导航设置
    MUNavigationController *navigationController = [[MUNavigationController alloc]initWithRootViewController:[MUKitDemoTableViewController new]];
    navigationController.navigationBarBackgroundImageMu = [UIImage imageFromColorMu:[UIColor colorWithHexString:@"#FF8000"]];
    navigationController.titleColorMu = [UIColor whiteColor];
    navigationController.navigationBarTintColor = [UIColor whiteColor];
    navigationController.barStyleMu                     = UIBarStyleBlack;
    navigationController.statusBarStyleMu               = UIStatusBarStyleLightContent;
    
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    [self.window addSubview:adView];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


//使用微信支付时需定义此方法
//- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
//
//
//    return YES;
//}
@end
