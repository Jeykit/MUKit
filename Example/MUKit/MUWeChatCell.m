//
//  MUWeChatCell.m
//  MUSignal_Example
//
//  Created by Jekity on 2018/6/27.
//  Copyright © 2018年 392071745@qq.com. All rights reserved.
//

#import "MUWeChatCell.h"
#import "MUEmotionManager.h"


@interface MUWeChatCell()

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *chatImageView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end
@implementation MUWeChatCell
-(void)awakeFromNib{
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    CGFloat top = _chatImageView.image.size.height/2.0;
    CGFloat left = _chatImageView.image.size.width/2.0;
    CGFloat bottom = _chatImageView.image.size.height/2.0;
    CGFloat right = _chatImageView.image.size.width/2.0;
    _chatImageView.image = [UIImage resizeWithImage:_chatImageView.image edgeInsets:UIEdgeInsetsMake(top+5, left, bottom, right+5)];
    _messageLabel.hidden = YES;
    _textView.textColor = [UIColor whiteColor];

}



-(void)setModel:(MUWeChatModel *)model{
    _model = model;
    _textView.text = model.text;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
