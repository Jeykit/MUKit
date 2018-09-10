//
//  MUKitDemoTableViewCell.m
//  MUKit
//
//  Created by Jekity on 2017/8/18.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "MUKitDemoTableViewCell.h"
#import "MUTempModel.h"
#import "MUTextKitNode.h"
@interface MUKitDemoTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *label;

@property (weak, nonatomic) IBOutlet MUTextKitNode *textKitNode;
@end
@implementation MUKitDemoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.label.userInteractionEnabled = YES;
//    self.label.
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//- (void)layoutSubviews{
//    [super layoutSubviews];
//    if (!CGSizeEqualToSize(self.bounds.size, [self intrinsicContentSize])) {
//        [self invalidateIntrinsicContentSize];
//    }
//}
-(void)setModel:(MUTempModel *)model{
    _model = model;
    _label.text = model.name;
    [self test:model];
}
- (void)test:(MUTempModel *)model{
    MUTextKitNode *tempView = _textKitNode;
    tempView.backgroundColor  = [UIColor whiteColor];
    tempView.isUsedAutoLayout = YES;
//     tempView.preferredMaxLayoutWidth = 200;
    NSMutableAttributedString *mString  = [[NSMutableAttributedString alloc]initWithString:model.name];
    [mString addAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor] ,NSFontAttributeName : [UIFont systemFontOfSize:20.]} range:NSMakeRange(0, mString.length)];
    
    NSMutableAttributedString*tmstring = [[NSMutableAttributedString alloc]initWithString:@"更多"];
    [tmstring addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSBaselineOffsetAttributeName:@(0),NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle),NSUnderlineColorAttributeName:[UIColor clearColor]} range:NSMakeRange(0, tmstring.length)];
    
//    [mString addAttribute:NSLinkAttributeName value:@"2384359" range:[mString.string rangeOfString:@"开始"]];
//    [tmstring addAttribute:NSLinkAttributeName value:@"ksjkfkjsdfl" range:[tmstring.string rangeOfString:@"更多"]];
    tempView.attributedText = mString;
    tempView.truncationAttributedText = tmstring;
    tempView.maximumNumberOfLines = 0;
    
//    weakify(tempView)
//    tempView.textNodeTappedTruncationToken = ^{
//        normalize(tempView)
//        tempView.maximumNumberOfLines = 4;
//        //        tempView.size_Mu = CGSizeMake(kScreenWidth, 100);
//        NSLog(@"------更多-----");
//    };
//    tempView.tappedLinkAttribute = ^(NSString * _Nonnull attribute, id  _Nonnull value, CGPoint point, NSRange textRange) {
//        NSLog(@"------value-----%@",value);
//
//    };
 
}
Click_MUSignal(label){
    
    _textKitNode.maximumNumberOfLines = 0;
//    NSLog(@"=======%@",self.label.indexPath);
}
@end
