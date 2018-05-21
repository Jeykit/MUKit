//
//  MUKitDemoSignalCell.m
//  MUKit
//
//  Created by Jekity on 2017/8/19.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "MUKitDemoSignalCell.h"
#import "MUKitDemoSignalView.h"

@interface MUKitDemoSignalCell()

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *_button;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedController;
@property (weak, nonatomic) IBOutlet UITextField *textFile;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UISwitch *muswitch;
@property (weak, nonatomic) IBOutlet MUKitDemoSignalView *blueView_view;
@property (weak, nonatomic) IBOutlet UIImageView *mmimageView;
@property (weak, nonatomic) IBOutlet UIStepper *stepper;
@end
@implementation MUKitDemoSignalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    //label和imageview使用信号时需要打开交互
    self.label.text = [self.label.text stringByReplacingIndex:3 count:4 withString:@"-"];
    self.label.userInteractionEnabled = YES;
    self.mmimageView.userInteractionEnabled = YES;
    self._button.swapPositionMu = YES;
    self._button.cornerRadius_Mu = 12.;
    [self.blueView_view setMUCornerRadius:22. borderWidth:1. borderColor:[UIColor redColor]];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -如果这里实现了响应事件，则会拦截控制器的响应
//UILabel
Click_MUSignal(label){
    
    UILabel *view = object;
    NSIndexPath *indexPath = view.indexPath;
    NSLog(@"我是cell上的子控件%@\n在%@内被调用\n属于的cell的indexpath:%@\n属于的控制器是%@\n",NSStringFromClass([object class]),NSStringFromClass([self class]),indexPath,NSStringFromClass([view.viewController class]));
}
//UIButton
Click_MUSignal(_button){
    UIButton *view = object;
    NSIndexPath *indexPath = view.indexPath;
    NSLog(@"我是cell上的子控件%@\n在%@内被调用\n属于的cell的indexpath:%@\n属于的控制器是%@\n",NSStringFromClass([object class]),NSStringFromClass([self class]),indexPath,NSStringFromClass([view.viewController class]));
}
//UISegmentedControl
Click_MUSignal(segmentedController){
    UISegmentedControl *view = object;
    NSIndexPath *indexPath = view.indexPath;
    NSLog(@"我是cell上的子控件%@\n在%@内被调用\n属于的cell的indexpath:%@\n属于的控制器是%@\n",NSStringFromClass([object class]),NSStringFromClass([self class]),indexPath,NSStringFromClass([view.viewController class]));
}
//UITextField
Click_MUSignal(textFile){
    UITextField *view = object;
    NSIndexPath *indexPath = view.indexPath;
    NSLog(@"我是cell上的子控件%@\n在%@内被调用\n属于的cell的indexpath:%@\n属于的控制器是%@\n",NSStringFromClass([object class]),NSStringFromClass([self class]),indexPath,NSStringFromClass([view.viewController class]));
}
//UISlider
Click_MUSignal(slider){
    UISlider *view = object;
    NSIndexPath *indexPath = view.indexPath;
    NSLog(@"我是cell上的子控件%@\n在%@内被调用\n属于的cell的indexpath:%@\n属于的控制器是%@\n",NSStringFromClass([object class]),NSStringFromClass([self class]),indexPath,NSStringFromClass([view.viewController class]));
}
//UISwitch
Click_MUSignal(muswitch){
    UISwitch *view = object;
    NSIndexPath *indexPath = view.indexPath;
    NSLog(@"我是cell上的子控件%@\n在%@内被调用\n属于的cell的indexpath:%@\n属于的控制器是%@\n",NSStringFromClass([object class]),NSStringFromClass([self class]),indexPath,NSStringFromClass([view.viewController class]));
}

//UIView
Click_MUSignal(blueView_view){
    UIView *view = object;
    NSIndexPath *indexPath = view.indexPath;
    NSLog(@"我是cell上的子控件%@\n在%@内被调用\n属于的cell的indexpath:%@\n属于的控制器是%@\n",NSStringFromClass([object class]),NSStringFromClass([self class]),indexPath,NSStringFromClass([view.viewController class]));
}
//UIImageView
Click_MUSignal(mmimageView){
    UIImageView *view = object;
    NSIndexPath *indexPath = view.indexPath;
    NSLog(@"我是cell上的子控件%@\n在%@内被调用\n属于的cell的indexpath:%@\n属于的控制器是%@\n",NSStringFromClass([object class]),NSStringFromClass([self class]),indexPath,NSStringFromClass([view.viewController class]));
}

//UIStepper
Click_MUSignal(stepper){
    UIStepper *view = object;
    NSIndexPath *indexPath = view.indexPath;
    NSLog(@"我是cell上的子控件%@\n在%@内被调用\n属于的cell的indexpath:%@\n属于的控制器是%@\n",NSStringFromClass([object class]),NSStringFromClass([self class]),indexPath,NSStringFromClass([view.viewController class]));
}

#warning 注意这里-----
//MUKitDemoSignalView
Click_MUSignal(infoView){//如果我没有被调用，你就去看看MUKitDemoSignalView是不是把我拦截了
    
    MUKitDemoSignalView *view = object;
    NSIndexPath *indexPath = view.indexPath;
    NSLog(@"我是cell上的子控件%@\n在%@内被调用\n属于的的自定义view是MUKitDemoSignalView属于的cell的indexpath:%@\n属于的控制器是%@\n",NSStringFromClass([object class]),NSStringFromClass([self class]),indexPath,NSStringFromClass([view.viewController class]));
}
@end
