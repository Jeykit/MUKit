//
//  MUViewControllerDidLoadModel.m
//  e联盟商家
//
//  Created by Jekity on 3/11/16.
//  Copyright © 2016年 Jekity. All rights reserved.
//

#import "MUViewControllerDidLoadModel.h"
#import <objc/runtime.h>

@implementation MUViewControllerDidLoadModel

-(NSHashTable *)hashTabel{
    if (_hashTabel == nil) {
        
        _hashTabel = [NSHashTable weakObjectsHashTable];
    }
    
    return _hashTabel;
}

+(instancetype)sharedInstance{
    
    static MUViewControllerDidLoadModel *controller = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        controller = [[MUViewControllerDidLoadModel alloc]init];
    });
    
    return controller;
}

@end
