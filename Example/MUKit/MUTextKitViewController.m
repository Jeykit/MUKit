//
//  MUTextKitViewController.m
//  MUKit_Example
//
//  Created by Jekity on 2018/9/7.
//  Copyright © 2018年 Jeykit. All rights reserved.
//

#import "MUTextKitViewController.h"
#import "MUTextKitNode.h"
#import "MUTextKitViewHeaderView.h"

@interface MUTextKitViewController ()
@property (nonatomic,strong) UIView *testView;
@property (nonatomic,strong) UIButton *button;
@property (nonatomic,strong) MUTextKitViewHeaderView *headerView;
@end

@implementation MUTextKitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
//    self.view.frame = kScreenBounds;
//
    CGFloat width = (kScreenWidth - 48.)/2-12.;
    CGFloat y  =  self.view.centerY_Mu - 240.;
    self.testView = [[UIView alloc]initWithFrame:CGRectMake(24., y, width, 49.)];
    self.testView.backgroundColor = [UIColor redColor];

    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0., 0, width, 49.)];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"UIView(点我)";
    [self.testView addSubview:label];
    [self.view addSubview:self.testView];

    self.button = [[UIButton alloc]initWithFrame:CGRectMake(24.+width+12., y, width, 49.)];
    _button.titleStringMu = @"UIButton(点我)";
    _button.titleColorMu = [UIColor whiteColor];
    self.button.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.button];
//
//    self.tableView.tableHeaderView = [MUTextKitViewHeaderView viewForXibMuWithRetainObject:self];
    [self test];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)test{
    MUTextKitNode *tempView = [[MUTextKitNode alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.button.frame)+ 64., UIScreen.mainScreen.bounds.size.width, 32)];
//    MUTextKitNode *tempView = [MUTextKitNode new];
//    tempView.backgroundColor  = [UIColor whiteColor];
//    tempView.preferredMaxLayoutWidth = 200;
      NSMutableAttributedString *mString  = [[NSMutableAttributedString alloc]initWithString:@"ajfshdjksfkkdslflslfkkdsjkgjksajfshdjksfkkdslflslfkkdsjkgjksajfshdjksfkkdslflslfkkdsjkgjksajfshdjksfkkdslflslfkkdsjkgjksajfshdjksfkkdslflslfkkdsjkgjksajfshdjksfkkdslflslfkkdsjkgjksajfshdjksfkkdslflslfkkdsjkgjksajfshdjksfkkdslflslfkkdsjkgjksajfshdjksfkkdslflslfkkdsjkgjks年华开始卡接地极\n"];
//    [mString setValue:NSParagraphStyle forKey:NSParagraphStyleAttributeName];
//    NSMutableParagraphStyle *style  = [[NSMutableParagraphStyle alloc] init];
//    style.alignment = NSTextAlignmentCenter;// type NSTextAlignment
//    NSDictionary *attributtes = @{NSParagraphStyleAttributeName : style,};
    
    [mString addAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor] ,NSFontAttributeName : [UIFont systemFontOfSize:20.]} range:NSMakeRange(0, mString.length)];
 
    NSMutableAttributedString*tmstring = [[NSMutableAttributedString alloc]initWithString:@"更多"];
    [tmstring addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSBaselineOffsetAttributeName:@(0),NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle),NSUnderlineColorAttributeName:[UIColor clearColor]} range:NSMakeRange(0, tmstring.length)];
    
 
        NSTextAttachment *attach   = [[NSTextAttachment alloc] init];
        attach.image               = [UIImage imageNamed:@"icon_store"];
    attach.bounds = CGRectMake(0, 0, 100, 130);
      NSAttributedString *imgStr = [NSAttributedString attributedStringWithAttachment:attach];
    [mString appendAttributedString:imgStr];
    [mString addAttribute:NSLinkAttributeName value:@"2384359" range:[mString.string rangeOfString:@"开始"]];
    
    [tmstring addAttribute:NSLinkAttributeName value:@"ksjkfkjsdfl" range:[tmstring.string rangeOfString:@"更多"]];
    tempView.attributedText = mString;
    tempView.truncationAttributedText = tmstring;
    tempView.maximumNumberOfLines = 1;
    
    weakify(tempView)
    tempView.textNodeTappedTruncationToken = ^{
        normalize(tempView)
        tempView.maximumNumberOfLines = 0;
        [tempView sizeToFit];
//        tempView.size_Mu = CGSizeMake(kScreenWidth, 100);
        NSLog(@"------更多-----");
    };
    tempView.tappedLinkAttribute = ^(NSString * _Nonnull attribute, id  _Nonnull value, CGPoint point, NSRange textRange) {
        normalize(tempView)
         tempView.maximumNumberOfLines = 2;
         [tempView sizeToFit];
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
    [self.view addSubview:tempView];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
