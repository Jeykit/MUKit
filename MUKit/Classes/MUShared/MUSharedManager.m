//
//  MUSharedManager.m
//  AFNetworking
//
//  Created by Jekity on 2017/11/27.
//

#import "MUSharedManager.h"
//#import "MUSharedObject.h"

@implementation MUSharedManager
+(void)sharedContentToWeChatFriend:(void (^)(MUSharedModel *))model result:(void (^)(BOOL))result faiure:(void (^)(BOOL))faiure{
    [[[MUSharedObject alloc]init]sharedContentToWeChatFriend:model result:result faiure:faiure];
}

+(void)sharedContentToWeChatCircle:(void (^)(MUSharedModel *))model result:(void (^)(BOOL))result faiure:(void (^)(BOOL))faiure{
    [[[MUSharedObject alloc]init]sharedContentToWeChatCircle:model result:result faiure:faiure];
}
+(void)sharedContentToQQFriend:(void (^)(MUSharedModel *))model result:(void (^)(BOOL))result faiure:(void (^)(BOOL))faiure{
    [[[MUSharedObject alloc]init] sharedContentToQQFriend:model result:result faiure:faiure];
}
+(void)sharedContentToQQZone:(void (^)(MUSharedModel *))model result:(void (^)(BOOL))result faiure:(void (^)(BOOL))faiure{
    [[[MUSharedObject alloc]init]sharedContentToQQZone:model result:result faiure:faiure];
}
+(void)sharedContentToWeiBo:(void (^)(MUSharedModel *))model result:(void (^)(BOOL))result faiure:(void (^)(BOOL))faiure{
    [[[MUSharedObject alloc]init]sharedContentToWeiBo:model result:result faiure:faiure];
}
@end
