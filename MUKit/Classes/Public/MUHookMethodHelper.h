//
//  MUHookMethodHelper.h
//  Pods
//
//  Created by Jekity on 2017/8/24.
//
//

#import <Foundation/Foundation.h>

@interface MUHookMethodHelper : NSObject
+(void)muHookMethod:(NSString *)originalClassName orignalSEL:(SEL)original newClassName:(NSString *)newClassName newSEL:(SEL)newSEL;
+(void)muHookMethod:(NSString *)originalClassName orignalSEL:(SEL)originalSEL defalutSEL:(SEL)defalutSEL newClassName:(NSString *)newClassName newSEL:(SEL)newSEL;
@end
