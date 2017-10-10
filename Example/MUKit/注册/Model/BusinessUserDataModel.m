//
//  BusinessUserDataModel.m
//  MUKit
//
//  Created by Jekity on 2017/9/15.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "BusinessUserDataModel.h"

static BusinessUserDataModel *model = nil;
@implementation BusinessUserDataModel

+(instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        model = [BusinessUserDataModel new];
    });
    return model;
}
#pragma mark -token
-(void)setToken:(NSString *)token{
    NSString *currentToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"token"];
    if (![token isEqualToString:currentToken]) {
        [[NSUserDefaults standardUserDefaults]setObject:token forKey:@"token"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}
-(NSString *)token{
    NSString *currentToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"token"];
    return currentToken;
}
    
#pragma mark -seller_id
-(void)setSeller_id:(NSString *)seller_id{
    NSString *currentSeller_id= [[NSUserDefaults standardUserDefaults] valueForKey:@"seller_id"];
    if (![seller_id isEqualToString:currentSeller_id]) {
        [[NSUserDefaults standardUserDefaults]setObject:seller_id forKey:@"seller_id"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
-(NSString *)seller_id{
    NSString *currentSeller_id = [[NSUserDefaults standardUserDefaults] valueForKey:@"seller_id"];
    return currentSeller_id;
}
    
#pragma mark -store_id
-(void)setStore_id:(NSString *)store_id{
    NSString *currentStore_id= [[NSUserDefaults standardUserDefaults] valueForKey:@"store_id"];
    if (![store_id isEqualToString:currentStore_id]) {
        [[NSUserDefaults standardUserDefaults]setObject:store_id forKey:@"store_id"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
-(NSString *)store_id{
        
    NSString *currentStore_id = [[NSUserDefaults standardUserDefaults] valueForKey:@"store_id"];
    return currentStore_id;
}
@end
