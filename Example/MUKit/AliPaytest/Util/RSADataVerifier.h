//
//  RSADataVerifier.h
//  AliSDKDemo
//
//  Created by 亦澄 on 16-8-12.
//  Copyright (c) 2016年 Alipay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSADataVerifier : NSObject {
	NSString *_publicKey;
}

- (id)initWithPublicKey:(NSString *)publicKey;

- (BOOL)verifyString:(NSString *)string withSign:(NSString *)signString withRSA2:(BOOL)rsa2;

@end
