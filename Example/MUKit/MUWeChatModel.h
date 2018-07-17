//
//  MUWeChatModel.h
//  MUSignal_Example
//
//  Created by Jekity on 2018/6/27.
//  Copyright © 2018年 392071745@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MUWeChatModel : NSObject
@property (nonatomic,copy) NSString *text;
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,assign) BOOL isImage;
@property (nonatomic,copy) NSString *chatID;
@property (nonatomic,copy) NSString *photo;
@property (nonatomic,copy) NSAttributedString *attributeString;
@end
