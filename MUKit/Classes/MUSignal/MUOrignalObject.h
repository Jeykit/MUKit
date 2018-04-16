//
//  MUOrignalObject.h
//  AFNetworking
//
//  Created by Jekity on 2018/4/16.
//

#import <Foundation/Foundation.h>

typedef void (^DeallocBlock)(void);
@interface MUOrignalObject : NSObject
@property (nonatomic, copy) DeallocBlock block;
-(instancetype)initWithBlock:(DeallocBlock)block;
@end
