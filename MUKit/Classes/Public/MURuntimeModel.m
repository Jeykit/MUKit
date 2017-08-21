//
//  MURuntimeModel.m
//  Pods
//
//  Created by Jekity on 2017/8/19.
//
//

#import "MURuntimeModel.h"
#import <objc/runtime.h>

@implementation MURuntimeModel
-(void)getPropertyList:(id)object{
    unsigned int outCount = 0;
    objc_property_t * properties = class_copyPropertyList([object class], &outCount);
    for (unsigned int i = 0; i < outCount; i ++) {
        objc_property_t property = properties[i];
        //属性名
        const char * name = property_getName(property);
        //属性描述
        const char * propertyAttr = property_getAttributes(property);
        NSLog(@"属性描述为 %s 的 %s ", propertyAttr, name);
        
        //属性的特性
        unsigned int attrCount = 0;
        objc_property_attribute_t * attrs = property_copyAttributeList(property, &attrCount);
        for (unsigned int j = 0; j < attrCount; j ++) {
            objc_property_attribute_t attr = attrs[j];
            const char * name = attr.name;
            const char * value = attr.value;
            NSLog(@"属性的描述：%s 值：%s", name, value);
        }
        free(attrs);
        NSLog(@"\n");
    }
    free(properties);
}
@end
