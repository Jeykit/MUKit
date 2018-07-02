//
//  MUEmotionManager.m
//  MUSignal_Example
//
//  Created by Jekity on 2018/6/29.
//  Copyright © 2018年 392071745@qq.com. All rights reserved.
//

#import "MUEmotionManager.h"
#import "MUEmotionModel.h"

static NSMutableArray *_emojiEmotions, *_custumEmotions,*gifEmotions;
@implementation MUEmotionManager

+ (NSArray *)emojiEmotionWithURL:(NSString *)urlPath{
    
    if (_emojiEmotions.count > 0) {
        return _emojiEmotions;
    }
    NSString *path = @"";
    if (!urlPath) {
        path = [[NSBundle mainBundle] pathForResource:@"emoji.plist" ofType:nil];
    }else{
        path = urlPath;
    }
    NSArray *emotionArray = [NSArray arrayWithContentsOfFile:path];
    _emojiEmotions = [NSMutableArray arrayWithCapacity:emotionArray.count];
    for (NSDictionary *dict in emotionArray) {
        MUEmotionModel *model = [MUEmotionModel yy_modelWithDictionary:dict];
        [_emojiEmotions addObject:model];
    }
    return _emojiEmotions;
}

+ (NSArray *)customEmotionWithURL:(NSString *)urlPath{
    if (_custumEmotions.count > 0) {
        return _custumEmotions;
    }
    NSString *path = @"";
    if (!urlPath) {
        path = [[NSBundle mainBundle] pathForResource:@"normal_face.plist" ofType:nil];
    }else{
        path = urlPath;
    }
    NSArray *emotionArray = [NSArray arrayWithContentsOfFile:path];
    _custumEmotions = [NSMutableArray arrayWithCapacity:emotionArray.count];
    for (NSDictionary *dict in emotionArray) {
        MUEmotionModel *model = [MUEmotionModel yy_modelWithDictionary:dict];
        [_custumEmotions addObject:model];
    }
    return _custumEmotions;
}


+ (NSArray *)gifEmotionWithURL:(NSString *)urlPath{
    if (gifEmotions.count > 0) {
        return gifEmotions;
    }
    NSString *path = @"";
    if (!urlPath) {
        path = [[NSBundle mainBundle] pathForResource:@"normal_face.plist" ofType:nil];
    }else{
        path = urlPath;
    }
    NSArray *emotionArray = [NSArray arrayWithContentsOfFile:path];
    gifEmotions = [NSMutableArray arrayWithCapacity:emotionArray.count];
    for (NSDictionary *dict in emotionArray) {
        MUEmotionModel *model = [MUEmotionModel yy_modelWithDictionary:dict];
        [gifEmotions addObject:model];
    }
    return gifEmotions;
}

+ (NSMutableAttributedString *)transferMessageString:(NSString *)message
                                                font:(UIFont *)font
                                          lineHeight:(CGFloat)lineHeight
{
    NSMutableAttributedString *attributeStr
    = [[NSMutableAttributedString alloc] initWithString:message];
    NSString *regEmj  = @"\\[[a-zA-Z0-9\\/\\u4e00-\\u9fa5]+\\]";// [微笑]、［哭］等自定义表情处理
    NSError *error    = nil;
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:regEmj options:NSRegularExpressionCaseInsensitive error:&error];
    if (!expression) {
        NSLog(@"%@",error);
        return attributeStr;
    }
    [attributeStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attributeStr.length)];
    NSArray *resultArray = [expression matchesInString:message options:0 range:NSMakeRange(0, message.length)];
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:resultArray.count];
    for (NSTextCheckingResult *match in resultArray) {
        NSRange range    = match.range;
        NSString *subStr = [message substringWithRange:range];
        NSArray *faceArr = [MUEmotionManager customEmotionWithURL:nil];
        for (MUEmotionModel *face in faceArr) {
            if ([face.face_name isEqualToString:subStr]) {
                NSTextAttachment *attach   = [[NSTextAttachment alloc] init];
                attach.image               = [UIImage imageNamed:face.face_name];
                // 位置调整Y值就行
                attach.bounds              = CGRectMake(0, -4, lineHeight, lineHeight);
                NSAttributedString *imgStr = [NSAttributedString attributedStringWithAttachment:attach];
                NSMutableDictionary *imagDic   = [NSMutableDictionary dictionaryWithCapacity:2];
                [imagDic setObject:imgStr forKey:@"image"];
                [imagDic setObject:[NSValue valueWithRange:range] forKey:@"range"];
                [mutableArray addObject:imagDic];
            }
        }
    }
    for (int i =(int) mutableArray.count - 1; i >= 0; i --) {
        NSRange range;
        [mutableArray[i][@"range"] getValue:&range];
        [attributeStr replaceCharactersInRange:range withAttributedString:mutableArray[i][@"image"]];
    }
    return attributeStr;
}

@end
