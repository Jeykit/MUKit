//
//  MUSharedManager.m
//  AFNetworking
//
//  Created by Jekity on 2017/11/27.
//

#import "MUSharedManager.h"
//#import "MUSharedObject.h"

@implementation MUSharedManager
+(void)sharedContentToWeChatFriend:(void (^)(MUSharedModel *))model result:(void (^)(BOOL))result{
    
    [[[MUSharedObject alloc]init]sharedContentToWeChatFriend:model result:result];
}

+(void)sharedContentToWeChatCircle:(void (^)(MUSharedModel *))model result:(void (^)(BOOL))result{
    [[[MUSharedObject alloc]init]sharedContentToWeChatCircle:model result:result];
}
+(void)sharedContentToQQFriend:(void (^)(MUSharedModel *))model result:(void (^)(BOOL))result{
    [[[MUSharedObject alloc]init] sharedContentToQQFriend:model result:result];
}
+(void)sharedContentToQQZone:(void (^)(MUSharedModel *))model result:(void (^)(BOOL))result{
    [[[MUSharedObject alloc]init]sharedContentToQQZone:model result:result];
}
+(void)sharedContentToWeiBo:(void (^)(MUSharedModel *))model result:(void (^)(BOOL))result{
    [[[MUSharedObject alloc]init]sharedContentToWeiBo:model result:result];;
}
@end
