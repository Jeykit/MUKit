//
//  MUEncryptionUtil.h
//  MUKit
//
//  Created by Jekity on 2018/4/14.
//

#import <Foundation/Foundation.h>

@interface MUEncryptionUtil : NSObject

#pragma mark-DES加密解密
+ (NSString *)DESEncryMU:(NSString *)string key:(NSString *)key;
+ (NSString *)DESDecryMU:(NSString *)string key:(NSString *)key;

#pragma mark-AES256加密解密
+ (NSString *)AES256EncryMU:(NSString *)string key:(NSString *)key;
+ (NSString *)AES256DecryMU:(NSString *)string key:(NSString *)key;

#pragma mark-RSA加密解密
/**在iOS中使用RSA加密解密，需要用到.der和.p12后缀格式的文件，其中.der格式的文件存放的是公钥（Public key）用于加密，.p12格式的文件存放的是私钥（Private key）用于解密.*/

/**
 *  加密方法
 *
 *  @param string   需要加密的字符串
 *  @param path  '.der'格式的公钥文件路径
 */
+ (NSString *)RSAEncryMU:(NSString *)string publicKeyWithContentsOfFile:(NSString *)path;

/**
 *  解密方法
 *
 *  @param string       需要解密的字符串
 *  @param path      '.p12'格式的私钥文件路径
 *  @param password  私钥文件密码
 */
+ (NSString *)RSADecryMU:(NSString *)string privateKeyWithContentsOfFile:(NSString *)path password:(NSString *)password;

/**
 *  加密方法
 *
 *  @param string    需要加密的字符串
 *  @param publicKey 公钥字符串
 */
+ (NSString *)RSAEncryMU:(NSString *)string publicKey:(NSString *)publicKey;

/**
 *  解密方法
 *
 *  @param string     需要解密的字符串
 *  @param privateKey 私钥字符串
 */
+ (NSString *)RSADecryMU:(NSString *)string privateKey:(NSString *)privateKey;

@end
