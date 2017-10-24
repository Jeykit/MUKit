//
//  UIView+MUSignal.h
//  elmsc
//
//  Created by Jekity on 2017/8/17.
//  Copyright © 2017年 Jekity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (MUSignal)
@property(nonatomic,readonly)UIViewController* viewController;
/**signal name*/
@property (nonatomic,copy)NSString *clickSignalName;

@property (nonatomic,readonly)NSIndexPath *indexPath;

@property (nonatomic,assign)UIView *(^setSignalName)(NSString * signalName);

@property (nonatomic,assign)UIView *(^enforceTarget)(NSObject *target);

@property (nonatomic,assign)UIView *(^controlEvents)(UIControlEvents event);

@property (nonatomic,assign,readonly)NSUInteger sections;//returns nil or a integer,when you want to use it,you should associated  UITableViewHeaderFooterView "tag" protery assignment a intgeter value

@property(nonatomic,assign) UIControlEvents allControlEvents;
@end

@interface NSObject (MUSignal)

-(void)sendSignal:(NSString *)signalName target:(NSObject *)target object:(id)object;

-(void)sendSignal:(NSString *)signalName target:(NSObject *)target;

@end
