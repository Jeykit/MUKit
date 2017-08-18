//
//  MUTableViewCell.m
//  elmsc
//
//  Created by zeng ping on 2017/7/7.
//  Copyright © 2017年 Jekity. All rights reserved.
//

#import "MUTableViewCell.h"
#import "MUView.h"
#import "MUTempModel.h"

@interface MUTableViewCell()

@property (weak, nonatomic) IBOutlet UIView *redView;

@property (weak, nonatomic) IBOutlet UILabel *label;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmented;
@property (weak, nonatomic) IBOutlet UIButton *button;

@property (nonatomic ,strong)MUView *infoView;
@end
@implementation MUTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.label.userInteractionEnabled = YES;
//    _infoView = [[MUView alloc]initWithFrame:_redView.bounds];
//    [_redView addSubview:_infoView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(MUTempModel *)model{
    _model = model;
    _label.text = model.name;
}
Click_signal(redView){
    
    UIView *view = (UIView *)object;
    NSIndexPath *indexPath = view.indexPath;
    NSLog(@"%@---------%@-------",NSStringFromClass([object class]),indexPath);
    [self sendSignal:@"redView" target:view.viewController];
}

Click_signal(label){
    UILabel *view = (UILabel *)object;
    NSIndexPath *indexPath = view.indexPath;
    NSLog(@"%@---------%@-------",NSStringFromClass([object class]),indexPath);
}

Click_signal(segmented){
    UISegmentedControl *view = (UISegmentedControl *)object;
    NSIndexPath *indexPath = view.indexPath;
    NSLog(@"%@---------%@-------",NSStringFromClass([object class]),indexPath);
}

Click_signal(button){
    UIButton *view = (UIButton *)object;
    NSIndexPath *indexPath = view.indexPath;
    NSLog(@"%@---------%@-------",NSStringFromClass([object class]),indexPath);
}
Click_signal(infoView){
    NSLog(@"子视图------333333----%@",NSStringFromClass([object class]));
    UIButton *view = (UIButton *)object;
    NSIndexPath *indexPath = view.indexPath;
    NSLog(@"%@---------%@-------%@",NSStringFromClass([object class]),indexPath,NSStringFromClass([view.viewController class]));
}
@end

