//
//  MUTextAttachment.m
//  ZPWIM_Example
//
//  Created by Jekity on 2018/7/19.
//  Copyright © 2018年 392071745@qq.com. All rights reserved.
//

#import "MUTextAttachment.h"

@interface MUTextAttachment()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation MUTextAttachment
- (UIImageView *)imageView{
    if (_imageView == nil){
        _imageView = [[UIImageView alloc] init];
//        _imageView.backgroundColor = [UIColor redColor];
    }
    return _imageView;
}
- (UIImage *)imageForBounds:(CGRect)imageBounds textContainer:(NSTextContainer *)textContainer characterIndex:(NSUInteger)charIndex {
    [_imageView removeFromSuperview];
    UIImage* image = [super imageForBounds:imageBounds textContainer:textContainer characterIndex:charIndex];
    CGRect frame = imageBounds;
    if (textContainer != nil){
        frame = CGRectMake(frame.origin.x, frame.origin.y - frame.size.height, frame.size.width, frame.size.height);
    }
    self.imageView.frame = frame;
    if (_imageData) {
//        self.imageView.image = [UIImage animatedGIFWithData:self.imageData];
    }
    
    [self.containerView addSubview:_imageView];
    return  image;
}

- (void)reset {
    [_imageView removeFromSuperview];
}

- (void)dealloc
{
    [_imageView removeFromSuperview];
//    NSLog(@"dealloc-----");
}
@end
