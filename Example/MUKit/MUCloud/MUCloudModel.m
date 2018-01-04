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
        tepModel.retainObject  = object;
        tepModel.retainKeyPath = keyPath;
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
-(id)object{
    return self.retainObject;
}
-(NSString *)keyPath{
    return self.retainKeyPath;
}
-(void)dealloc{
#ifdef DEBUG
     NSLog(@"%@对象持有MUCloudModel已被销毁，属性名称为%@",NSStringFromClass([self.retainObject class]), self.retainKeyPath);
#endif
}
@end
