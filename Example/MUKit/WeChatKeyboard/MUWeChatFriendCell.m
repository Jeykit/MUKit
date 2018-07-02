//
//  MUWeChatFriendCell.m
//  MUSignal_Example
//
//  Created by Jekity on 2018/6/28.
//  Copyright © 2018年 392071745@qq.com. All rights reserved.
//

#import "MUWeChatFriendCell.h"


@interface MUWeChatFriendCell()

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *chatImageView;

@end
@implementation MUWeChatFriendCell

-(void)awakeFromNib{
    [super awakeFromNib];
//    self.contentView.backgroundColor = [UIColor whiteColor];
    
    CGFloat top = _chatImageView.image.size.height/2.0;
    
    CGFloat left = _chatImageView.image.size.width/2.0;
    
    CGFloat bottom = _chatImageView.image.size.height/2.0;
    
    CGFloat right = _chatImageView.image.size.width/2.0;
    
    [self.contentView sendSubviewToBack:_chatImageView];
    //
    //    return[image resizableImageWithCapInsets:UIEdgeInsetsMake(top+10, left, bottom, right+10)resizingMode:UIImageResizingModeStretch];
    _chatImageView.image = [UIImage resizeWithImage:_chatImageView.image edgeInsets:UIEdgeInsetsMake(top+5, left, bottom, right+5)];
    
    
    
}
-(void)setModel:(MUWeChatModel *)model{
    _model = model;
    if (_model.attributeString.length > 0) {
        _messageLabel.attributedText = _model.attributeString;
    }else{
        _messageLabel.text = model.text;
    }
    if (model.image) {
        _messageLabel.text = @"";
        CGFloat width = CGImageGetWidth(model.image.CGImage);
        CGFloat height = CGImageGetHeight(model.image.CGImage);
        
        _chatImageView.image = [UIImage imageCompressForSize:model.image targetSize:CGSizeMake(width * 0.5, height * 0.5)];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
