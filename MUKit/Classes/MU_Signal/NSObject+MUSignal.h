//
//  NSObject+MUSignal.h
//  elmsc
//
//  Created by Jekity on 2017/8/17.
//  Copyright © 2017年 Jekity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (MUSignal)
//expand method for signal
-(void)sendSignal:(NSString *)signalName className:(NSString *)target object:(id)object;

-(void)sendSignal:(NSString *)signalName target:(NSObject *)target object:(id)object;

-(void)sendSignal:(NSString *)signalName target:(NSObject *)target;

-(id)getViewControllerFromString:(NSString *)viewControllerString;

+(NSMutableArray *)sharedViewControllerArray;
@end
