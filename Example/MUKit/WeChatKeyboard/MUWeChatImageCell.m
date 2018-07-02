//
//  MUWeChatImageCell.m
//  MUSignal_Example
//
//  Created by Jekity on 2018/6/28.
//  Copyright © 2018年 392071745@qq.com. All rights reserved.
//

#import "MUWeChatImageCell.h"


@interface MUWeChatImageCell()

@property (weak, nonatomic) IBOutlet UIImageView *chatImageView;

@end
@implementation MUWeChatImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(MUWeChatModel *)model{
    _model = model;
    CGFloat width = CGImageGetWidth(model.image.CGImage);
    CGFloat height = CGImageGetHeight(model.image.CGImage);
    
    _chatImageView.image = [UIImage imageCompressForSize:model.image targetSize:CGSizeMake(width * 0.1, height * 0.1)];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
