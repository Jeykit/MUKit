//
//  MUWeChatFriendCell.m
//  MUSignal_Example
//
//  Created by Jekity on 2018/6/28.
//  Copyright © 2018年 392071745@qq.com. All rights reserved.
//

#import "MUWeChatFriendCell.h"
#import "MUEmotionManager.h"


@interface MUWeChatFriendCell()

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *chatImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end
@implementation MUWeChatFriendCell

-(void)awakeFromNib{
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    CGFloat top = _chatImageView.image.size.height/2.0;
    CGFloat left = _chatImageView.image.size.width/2.0;
    CGFloat bottom = _chatImageView.image.size.height/2.0;
    CGFloat right = _chatImageView.image.size.width/2.0;
    [self.contentView sendSubviewToBack:_chatImageView];
    _chatImageView.image = [UIImage resizeWithImage:_chatImageView.image edgeInsets:UIEdgeInsetsMake(top+5, left, bottom, right+5)];
    _messageLabel.hidden = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(MUWeChatModel *)model{
    _model = model;
    _messageLabel.text = model.text;
}
@end
