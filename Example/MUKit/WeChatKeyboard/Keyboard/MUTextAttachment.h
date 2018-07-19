//
//  MUTextAttachment.h
//  ZPWIM_Example
//
//  Created by Jekity on 2018/7/19.
//  Copyright © 2018年 392071745@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MUTextAttachment : NSTextAttachment
@property (nonatomic,strong) NSData *imageData;
@property (nonatomic, weak) UIView *containerView;
@end
