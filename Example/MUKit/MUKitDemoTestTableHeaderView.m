//
//  MUKitDemoTestTableHeaderView.m
//  MUKit
//
//  Created by Jekity on 2017/9/30.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "MUKitDemoTestTableHeaderView.h"

@interface MUKitDemoTestTableHeaderView()
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *testLabel;

@end
@implementation MUKitDemoTestTableHeaderView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.testLabel.userInteractionEnabled = YES;
    self.label1.userInteractionEnabled = YES;
}
Click_MUSignal(label1){
    NSLog(@"header=====%@",NSStringFromClass([self class]));
}
Click_MUSignal(testLabel){
    NSLog(@"testLabelheader=====%@",NSStringFromClass([self class]));
}
@end
