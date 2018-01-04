//
//  MUCloudModel.m
//  MUKit_Example
//
//  Created by Jekity on 2018/1/4.
//  Copyright © 2018年 Jeykit. All rights reserved.
//

#import "MUCloudModel.h"
#import <objc/runtime.h>

@interface MUCloudModel ()

@property(nonatomic, assign)id retainObject;
@property(nonatomic, copy)NSString *retainKeyPath;

@end

 static __weak MUCloudModel * instance = nil;
@implementation MUCloudModel
+(instancetype)initWithRetainObject:(NSObject *)object keyPath:(NSString *)keyPath{
   
 __block MUCloudModel *tepModel = [MUCloudModel sharedInstance];
    if (tepModel.retainObject) {
#ifdef DEBUG
        NSLog(@"MUCloudModel已被%@对象持有，属性名称为%@,%@对象将不会持有",NSStringFromClass([tepModel.retainObject class]), tepModel.retainKeyPath,NSStringFromClass([object class]));
#endif
        return nil;
    }else{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *string = [tepModel nameWithInstance:tepModel superView:object];
            if ([string isEqualToString:keyPath]) {
                
                tepModel.retainObject  = object;
                tepModel.retainKeyPath = keyPath;
            }else{
#ifdef DEBUG
                NSLog(@"%@对象没有属性名称为%@的MUCloudModel对象",NSStringFromClass([object class]),keyPath);    
#endif
            }
        });
    }
    return tepModel;
}
+(instancetype)cloudModel{
    
#ifdef DEBUG
    if (!instance) {
        NSLog(@"MUCloudModel对象还未初始化");
    }
    
#endif
    return instance;
}
//初始化
+(instancetype)sharedInstance{
    
    MUCloudModel * strongInstance = instance;
    @synchronized (self) {
        if (strongInstance == nil) {
            strongInstance = [[[self class]alloc]init];
            instance       = strongInstance;
        }
    }
    return strongInstance;
}

+(void)releaseModel{
    
    if (instance) {
        [instance.retainObject setValue:nil forKey:instance.retainKeyPath];
    }
}
-(NSString *)nameWithInstance:(NSObject *)instance superView:(id)superView{
    unsigned int numIvars = 0;
    NSString *key=nil;
    Ivar * ivars = class_copyIvarList([superView class], &numIvars);
    for(int i = 0; i < numIvars; i++) {
        Ivar thisIvar = ivars[i];
        const char *type = ivar_getTypeEncoding(thisIvar);
        NSString *stringType =  [NSString stringWithCString:type encoding:NSUTF8StringEncoding];
        if (![stringType hasPrefix:@"@"]) {
            continue;
        }
        
        if ([stringType containsString:NSStringFromClass([instance class])]) {
            key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
            break;
        }
    }
    free(ivars);
    return key;
    
}
-(void)dealloc{
#ifdef DEBUG
     NSLog(@"%@对象持有MUCloudModel已被销毁，属性名称为%@",NSStringFromClass([self.retainObject class]), self.retainKeyPath);
#endif
}
@end
