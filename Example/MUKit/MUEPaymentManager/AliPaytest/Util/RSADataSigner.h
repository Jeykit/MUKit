//
//  RSADataSigner.h
//  AliSDKDemo
//
//  Created by 亦澄 on 16-8-12.
//  Copyright (c) 2016年 Alipay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSADataSigner : NSObject {
	NSString * _privateKey;
}

- (id)initWithPrivateKey:(NSString *)privateKey;

- (NSString *)signString:(NSString *)string withRSA2:(BOOL)rsa2;

@end
