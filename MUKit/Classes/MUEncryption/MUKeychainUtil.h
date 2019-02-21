//
//  MUKeychainUtil.h
//  AFNetworking
//
//  Created by Jekity on 2019/2/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MUKeychainUtil : NSObject

//获取KeyChain数据
+ (id)getDataInKeyChainWithKey:(NSString *)key;

//删除KeyChain数据
+ (void) deleteDataInKeyChain:(NSString *)key;


//保存KeyChain数据
+ (void)saveDataInKeyChain:(NSString *)key data:(id)data;
@end

NS_ASSUME_NONNULL_END
