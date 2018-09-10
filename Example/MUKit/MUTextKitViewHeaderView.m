//
//  MUTextKitViewHeaderView.m
//  MUKit_Example
//
//  Created by Jekity on 2018/9/8.
//  Copyright © 2018年 Jeykit. All rights reserved.
//

#import "MUTextKitViewHeaderView.h"
#import "MUTextKitNode.h"

@interface MUTextKitViewHeaderView ()
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet MUTextKitNode *textKitNode;

@end
@implementation MUTextKitViewHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self test];
}
- (void)test{
    MUTextKitNode *tempView = _textKitNode;
    tempView.backgroundColor  = [UIColor whiteColor];
    
    NSMutableAttributedString *mString  = [[NSMutableAttributedString alloc]initWithString:@"ajfshdjksfkkdslflslfkkdsjkgjksajfshdjksfkkdslflslfkkdsjkgjksajfshdjksfkkdslflslfkkdsjkgjksajfshdjksfkkdslflslfkkdsjkgjksajfshdjksfkkdslflslfkkdsjkgjksajfshdjksfkkdslflslfkkdsjkgjksajfshdjksfkkdslflslfkkdsjkgjksajfshdjksfkkdslflslfkkdsjkgjksajfshdjksfkkdslflslfkkdsjkgjks年华开始卡接地极"];
    [mString addAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor] ,NSFontAttributeName : [UIFont systemFontOfSize:20.]} range:NSMakeRange(0, mString.length)];
    
    NSMutableAttributedString*tmstring = [[NSMutableAttributedString alloc]initWithString:@"更多"];
    [tmstring addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSBaselineOffsetAttributeName:@(0),NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle),NSUnderlineColorAttributeName:[UIColor clearColor]} range:NSMakeRange(0, tmstring.length)];
    
    [mString addAttribute:NSLinkAttributeName value:@"2384359" range:[mString.string rangeOfString:@"开始"]];
    [tmstring addAttribute:NSLinkAttributeName value:@"ksjkfkjsdfl" range:[tmstring.string rangeOfString:@"更多"]];
    tempView.attributedText = mString;
    tempView.truncationAttributedText = tmstring;
    tempView.maximumNumberOfLines = 1;
    
    weakify(tempView)
    tempView.textNodeTappedTruncationToken = ^{
        normalize(tempView)
        tempView.maximumNumberOfLines = 4;
        //        tempView.size_Mu = CGSizeMake(kScreenWidth, 100);
        NSLog(@"------更多-----");
    };
    tempView.tappedLinkAttribute = ^(NSString * _Nonnull attribute, id  _Nonnull value, CGPoint point, NSRange textRange) {
        NSLog(@"------value-----%@",value);
        
    };
    //    tempView.shadowColor = [UIColor purpleColor].CGColor;
    //    tempView.shadowRadius = 10;
    //    tempView.shadowOpacity = 0.8;
    //    tempView.shadowOffset = CGSizeMake(3, 3);
    //    tempView.highlightStyle = MUTextNodeHighlightStyleLight;
    //    tempView.highlightRange = NSMakeRange(20, 20);
    //    [tempView setHighlightRange:[mString.string rangeOfString:@"开始"] animated:YES];
    //    tempView.node.attribute = attribute;
    //    tempView.layer.masksToBounds   = YES;
}
Click_MUSignal(button){
    _textKitNode.maximumNumberOfLines = 0;
}
@end
