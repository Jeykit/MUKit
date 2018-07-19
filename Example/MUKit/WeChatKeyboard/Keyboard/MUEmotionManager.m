//
//  MUEmotionManager.m
//  MUSignal_Example
//
//  Created by Jekity on 2018/6/29.
//  Copyright © 2018年 392071745@qq.com. All rights reserved.
//

#import "MUEmotionManager.h"
#import "MUEmotionModel.h"
#import "MUTextAttachment.h"

static NSMutableArray *_emojiEmotions, *_custumEmotions,*gifEmotions,*owerEmotions;
@implementation MUEmotionManager

+ (void)downLoaFace{
    [MUModel GET:@"api/im/GetEmoticonList" parameters:^(MUParaModel *parameter) {
        
        parameter.type = @"";
        
    } success:^(MUModel *model, NSArray<MUModel *> *modelArray, id responseObject) {
        
        owerEmotions = [modelArray mutableCopy];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error, NSString *errorMsg) {
        
    }];
}

+ (NSArray *)faceWithCustoming{
    return owerEmotions;
}
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
                //                attach.image               = [UIImage imageNamed:face.face_name];
                attach.image               = [UIImage imageNamed:@"1111"];
                // 位置调整Y值就行
                attach.bounds              = CGRectMake(0, -4, lineHeight, lineHeight);
                //                 attach.bounds              = CGRectMake(0, 10, 200, 400);
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


//网络表情
+ (NSMutableAttributedString *)customingFaceWithAttributeString:(NSMutableAttributedString *)attributeString
                                                        message:(NSString *)message
                                                           font:(UIFont *)font
                                                     lineHeight:(CGFloat)lineHeight
                                                       textView:(UITextView*)textView{
    
    NSMutableAttributedString *mAttributeString = nil;
    if (message.length == 0) {
        if (attributeString) {
            return attributeString;
        }
        return mAttributeString;
        
    }
    
    mAttributeString = attributeString?:[[NSMutableAttributedString alloc]initWithString:message];
    NSString *pattern =  @"\\[::emoji\\{([a-zA-Z0-9\\/\\u4e00-\\u9fa5]+)\\}\\::]";
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern: pattern options: NSRegularExpressionCaseInsensitive error: &error];
    if (!regex) {
        NSLog(@"%@",error);
    }
    NSArray *match = [regex matchesInString: mAttributeString.string options:NSMatchingReportProgress range: NSMakeRange(0, [message length])];
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:match.count];
    for (NSTextCheckingResult*result in match) {
        NSString *tagValue = [message substringWithRange:[result rangeAtIndex:1]];  // 分组2所对应的串
        NSArray *faceArr = [MUEmotionManager faceWithCustoming];
//        for (MUModel *face in faceArr) {
//            if ([face.emName isEqualToString:tagValue]) {
//                MUTextAttachment *attach   = [[MUTextAttachment alloc] init];
//                attach.containerView       = textView;
//                attach.bounds              = CGRectMake(0, -4, lineHeight, lineHeight);
//                NSAttributedString *imgStr = [NSAttributedString attributedStringWithAttachment:attach];
//                
//                NSDictionary *dict = @{@"range":[NSValue valueWithRange:result.range],@"name":imgStr};
//                [mutableArray addObject:dict];
//                
//                NSString *url = [face.emUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//                [[SDWebImageManager sharedManager].imageDownloader downloadImageWithURL:[NSURL URLWithString:url] options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
//                    
//                } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
//                    if (image) {
//                        attach.image = image;
//                        attach.imageData = data;
//                        [textView.layoutManager invalidateDisplayForCharacterRange:NSMakeRange(0, [message length])];
//                    }
//                }];
//            }
//        }
        
    }
    for (int i =(int) mutableArray.count - 1; i >= 0; i --) {
        NSRange range;
        [mutableArray[i][@"range"] getValue:&range];
        [mAttributeString replaceCharactersInRange:range withAttributedString:mutableArray[i][@"name"]];
    }
    return mAttributeString;
}

//内部表情
+ (NSMutableAttributedString *)customingEmojiWithAttributeString:(NSMutableAttributedString *)attributeString
                                                         message:(NSString *)message
                                                            font:(UIFont *)font
                                                      lineHeight:(CGFloat)lineHeight{
    
    NSMutableAttributedString *mAttributeString = nil;
    if (message.length == 0) {
        if (attributeString) {
            return attributeString;
        }
        return mAttributeString;
        
    }
    mAttributeString = attributeString?:[[NSMutableAttributedString alloc]initWithString:message];
    NSString *pattern =  @"\\[::emoji\\{(\\[[a-zA-Z0-9\\/\\u4e00-\\u9fa5]+\\])\\}\\::]";
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern: pattern options: NSRegularExpressionCaseInsensitive error: &error];
    if (!regex) {
        NSLog(@"%@",error);
    }
    NSArray *match = [regex matchesInString: message options:NSMatchingReportProgress range: NSMakeRange(0, [message length])];
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:match.count];
    for (NSTextCheckingResult*result in match) {
        //        NSString *subStr = [message substringWithRange:result.range];
        NSString *tagValue = [message substringWithRange:[result rangeAtIndex:1]];  // 分组2所对应的串
        //          NSLog(@"number====%ld,tagvalue = %@",result.numberOfRanges,tagValue);
        NSArray *faceArr = [MUEmotionManager customEmotionWithURL:nil];
        for (MUEmotionModel *face in faceArr) {
            if ([face.face_name isEqualToString:tagValue]) {
                NSTextAttachment *attach   = [[NSTextAttachment alloc] init];
                attach.image               = [UIImage imageNamed:face.face_name];
                // 位置调整Y值就行
                attach.bounds              = CGRectMake(0, -4, lineHeight, lineHeight);
                NSAttributedString *imgStr = [NSAttributedString attributedStringWithAttachment:attach];
                NSMutableDictionary *imagDic   = [NSMutableDictionary dictionaryWithCapacity:2];
                [imagDic setObject:imgStr forKey:@"image"];
                [imagDic setObject:[NSValue valueWithRange:result.range] forKey:@"range"];
                [mutableArray addObject:imagDic];
            }
        }
        
    }
    for (int i =(int) mutableArray.count - 1; i >= 0; i --) {
        NSRange range;
        [mutableArray[i][@"range"] getValue:&range];
        [mAttributeString replaceCharactersInRange:range withAttributedString:mutableArray[i][@"image"]];
    }
    return mAttributeString;
}

+ (NSMutableAttributedString *)customingImgageMD5WithAttributeString:(NSMutableAttributedString *)attributeString
                                                             message:(NSString *)message
                                                           notLoaded:(BOOL)notLoaded
                                                               count:(NSUInteger *)count
                                                            textView:(UITextView*)textView{
    NSMutableAttributedString *mAttributeString = nil;
    if (message.length == 0) {
        if (attributeString) {
            return attributeString;
        }
        return mAttributeString;
        
    }
    mAttributeString = attributeString?:[[NSMutableAttributedString alloc]initWithString:message];
    NSString *pattern =  @"\\[::image\\[(\\d+,\\d+)\\]\\{MD5:URI-\\d;TYPE-([jpgpn]*);([a-zA-Z\\d;]+)\\}::\\]";
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern: pattern options: NSRegularExpressionCaseInsensitive error: &error];
    if (!regex) {
        NSLog(@"%@",error);
    }
    NSArray *match = [regex matchesInString: message options:NSMatchingReportProgress range: NSMakeRange(0, [message length])];
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:match.count];
    for (NSTextCheckingResult*result in match) {
        //        NSString *subStr = [message substringWithRange:result.range];
        NSString *tagValue = [message substringWithRange:[result rangeAtIndex:1]];  //图片尺寸
        NSArray *sizeArray = [tagValue componentsSeparatedByString:@","];
        //        NSLog(@"number====%ld,result==%@,tagvalue = %@",result.numberOfRanges,subStr,tagValue);
        NSTextAttachment *attach   = [[NSTextAttachment alloc] init];
        *count += 1;
        // 位置调整Y值就行
        CGFloat maxWidth = kScreenWidth - (38.+24.)*2.;
        CGFloat width = [sizeArray[0] doubleValue]/2.;
        if (width>maxWidth) {
            width = maxWidth;
        }
        CGFloat rate = width/([sizeArray[0] doubleValue]/2.);
        attach.bounds              = CGRectMake(0, 0,width, ([sizeArray[1] doubleValue]/2.)*rate);
        NSAttributedString *imgStr = [NSAttributedString attributedStringWithAttachment:attach];
        NSMutableDictionary *imagDic   = [NSMutableDictionary dictionaryWithCapacity:2];
        [imagDic setObject:imgStr forKey:@"image"];
        [imagDic setObject:[NSValue valueWithRange:result.range] forKey:@"range"];
        if (CGRectGetWidth(attach.bounds) > CGRectGetHeight(attach.bounds)) {
            attach.image = [UIImage imageCompressForSize:UIImageNamed(@"picture-h-zw") targetSize:attach.bounds.size];
        }else{
            attach.image = [UIImage imageCompressForSize:UIImageNamed(@"picture-s-zw") targetSize:attach.bounds.size];
        }
        
        if (!notLoaded) {
            NSString *ImageType = [message substringWithRange:[result rangeAtIndex:2]];  //图片类型
            NSString *ImageMD5 = [message substringWithRange:[result rangeAtIndex:3]];  //图片MD5
//            NSString *urlStrng = [NSString stringWithFormat:@"%@/upload/ChatImImg/%@.%@",[MUUserDataModel sharedInstance].imageDomain,ImageMD5,ImageType];
                        NSString *urlStrng = @"";
            [[SDWebImageManager sharedManager].imageDownloader downloadImageWithURL:[NSURL URLWithString:urlStrng] options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                
            } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                if (image) {
                    attach.image = [UIImage imageCompressForSize:image targetSize:attach.bounds.size];
                    [textView.layoutManager invalidateDisplayForCharacterRange:result.range];
                }
            }];
        }
        [mutableArray addObject:imagDic];
    }
    
    for (int i =(int) mutableArray.count - 1; i >= 0; i --) {
        NSRange range;
        [mutableArray[i][@"range"] getValue:&range];
        [mAttributeString replaceCharactersInRange:range withAttributedString:mutableArray[i][@"image"]];
    }
    return mAttributeString;
}

+ (NSMutableAttributedString *)customingImgageURLWithAttributeString:(NSMutableAttributedString *)attributeString message:(NSString *)message textView:(UITextView*)textView{
    NSMutableAttributedString *mAttributeString = nil;
    if (message.length == 0) {
        if (attributeString) {
            return attributeString;
        }
        return mAttributeString;
        
    }
    mAttributeString = attributeString?:[[NSMutableAttributedString alloc]initWithString:message];
    NSString *pattern = @"\\[::image\\[(\\d+,\\d+)\\]\\{([(http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?]+)\\}::\\]";
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern: pattern options: NSRegularExpressionCaseInsensitive error: &error];
    if (!regex) {
        NSLog(@"%@",error);
    }
    NSArray *match = [regex matchesInString: message options:NSMatchingReportProgress range: NSMakeRange(0, [message length])];
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:match.count];
    for (NSTextCheckingResult*result in match) {
        //                NSString *subStr = [message substringWithRange:result.range];
        NSString *tagValue = [message substringWithRange:[result rangeAtIndex:1]];  //图片尺寸
        NSArray *sizeArray = [tagValue componentsSeparatedByString:@","];
        NSTextAttachment *attach   = [[NSTextAttachment alloc] initWithData:nil ofType:nil];
        // 位置调整Y值就行
        CGFloat maxWidth = kScreenWidth - (38.+24.)*2.;
        CGFloat width = [sizeArray[0] doubleValue]/2.;
        if (width>maxWidth) {
            width = maxWidth;
        }
        CGFloat rate = width/([sizeArray[0] doubleValue]/2.);
        attach.bounds              = CGRectMake(0, 0,width, ([sizeArray[1] doubleValue]/2.)*rate);
        NSAttributedString *imgStr = [NSAttributedString attributedStringWithAttachment:attach];
        NSMutableDictionary *imagDic   = [NSMutableDictionary dictionaryWithCapacity:2];
        [imagDic setObject:imgStr forKey:@"image"];
        [imagDic setObject:[NSValue valueWithRange:result.range] forKey:@"range"];
        [mutableArray addObject:imagDic];
        NSString *ImageUrl = [message substringWithRange:[result rangeAtIndex:2]];  //图片链接
        if (CGRectGetWidth(attach.bounds) > CGRectGetHeight(attach.bounds)) {
            attach.image = [UIImage imageCompressForSize:UIImageNamed(@"picture-h-zw") targetSize:attach.bounds.size];
        }else{
            attach.image = [UIImage imageCompressForSize:UIImageNamed(@"picture-s-zw") targetSize:attach.bounds.size];
        }
        [[SDWebImageManager sharedManager].imageDownloader downloadImageWithURL:[NSURL URLWithString:ImageUrl] options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            if (image) {
                attach.image = [UIImage imageCompressForSize:image targetSize:attach.bounds.size];
                [textView.layoutManager invalidateDisplayForCharacterRange:result.range];
            }
        }];
    }
    
    for (int i =(int) mutableArray.count - 1; i >= 0; i --) {
        NSRange range;
        [mutableArray[i][@"range"] getValue:&range];
        [mAttributeString replaceCharactersInRange:range withAttributedString:mutableArray[i][@"image"]];
    }
    return mAttributeString;
}
@end
