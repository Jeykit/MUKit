//
//  MUAddedPropertyModel.h
//  SigmaTableViewModel
//
//  Created by Jekity on 2017/8/10.
//  Copyright © 2017年 Jekity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,MUAddedPropertyType){
    
    MUAddedPropertyTypeAssign = 0,
    MUAddedPropertyTypeRetain = 1
};
@interface MUAddedPropertyModel : NSObject

-(BOOL)addProperty:(id)object propertyName:(NSString *)name type:(MUAddedPropertyType)type;
-(CGFloat)getValueFromObject:(id)object name:(NSString *)name;
-(void)setValueToObject:(id)object name:(NSString *)name value:(CGFloat)value;

-(NSObject *)getObjectFromObject:(id)object name:(NSString *)name;
-(void)setObjectToObject:(id)object name:(NSString *)name value:(NSObject *)value;

-(CGSize)getSizeFromObject:(id)object name:(NSString *)name;
-(void)setSizeToObject:(id)object name:(NSString *)name value:(CGSize)newValue;
@end
