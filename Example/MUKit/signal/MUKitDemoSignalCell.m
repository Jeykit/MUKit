//
//  MUKitDemoSignalCell.m
//  MUKit
//
//  Created by Jekity on 2017/8/19.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "MUKitDemoSignalCell.h"
#import "MUView.h"
@interface MUKitDemoSignalCell()

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *button;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedController;
@property (weak, nonatomic) IBOutlet UITextField *textFile;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UISwitch *muswitch;
@property (weak, nonatomic) IBOutlet MUView *greenView;

@property (weak, nonatomic) IBOutlet UIView *blueView;
@property (weak, nonatomic) IBOutlet UIImageView *mmimageView;
@property (weak, nonatomic) IBOutlet UIStepper *stepper;
@end
@implementation MUKitDemoSignalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    //label和imageview使用信号时需要打开交互
    self.label.userInteractionEnabled = YES;
    self.mmimageView.userInteractionEnabled = YES;
    
    self.button.allControlEvents = UIControlEventTouchDown;
    //可以修改UIControler的触发事件
    self.textFile.allControlEvents = UIControlEventEditingDidEndOnExit;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//Click_signal(label){
//    
//    UILabel *view = (UILabel *)object;
//    NSIndexPath *indexPath = view.indexPath;
//    NSLog(@"我是cell上子控件的信号------%@-----控制器信号被我拦截了----%@-------",NSStringFromClass([object class]),indexPath);
//}
//
//Click_signal(button){
//    UIButton *view = (UIButton *)object;
//    NSIndexPath *indexPath = view.indexPath;
//    NSLog(@"我是cell上子控件的信号-----%@-----控制器信号被我拦截了----%@-------",NSStringFromClass([object class]),indexPath);
//}
//
//Click_signal(segmentedController){
//    UISegmentedControl *view = (UISegmentedControl *)object;
//    NSIndexPath *indexPath = view.indexPath;
//    NSLog(@"我是cell上子控件的信号------%@-----控制器信号被我拦截了----%@-------",NSStringFromClass([object class]),indexPath);
//}
//
Click_signal(textFile){
    UITextField *view = (UITextField *)object;
    NSIndexPath *indexPath = view.indexPath;
    NSLog(@"我是cell上子控件的信号%@------控制器信号被我拦截了---------%@-------%@",NSStringFromClass([object class]),indexPath,view.text);
}
//
//Click_signal(slider){
//    UISlider *view = (UISlider *)object;
//    NSIndexPath *indexPath = view.indexPath;
//    NSLog(@"我是cell上子控件的信号%@------控制器信号被我拦截了---%@-------%@",NSStringFromClass([object class]),indexPath,NSStringFromClass([view.viewController class]));
//}
//
//Click_signal(muswitch){
//    UISwitch *view = (UISwitch *)object;
//    NSIndexPath *indexPath = view.indexPath;
//    NSLog(@"我是cell上子控件的信号-----%@----控制器信号被我拦截了-----%@-------",NSStringFromClass([object class]),indexPath);
//}
//
//Click_signal(greenView){
//    MUView *view = (MUView *)object;
//    NSIndexPath *indexPath = view.indexPath;
//    NSLog(@"我是cell上子控件的信号------%@---控制器信号被我拦截了------%@-------",NSStringFromClass([object class]),indexPath);
//}
//
//Click_signal(blueView){
//    UIView *view = (UIView *)object;
//    NSIndexPath *indexPath = view.indexPath;
//    NSLog(@"我是cell上子控件的信号%@-----控制器信号被我拦截了----%@-------",NSStringFromClass([object class]),indexPath);
//}
//
//Click_signal(mmimageView){
//    UIImageView *view = (UIImageView *)object;
//    NSIndexPath *indexPath = view.indexPath;
//    NSLog(@"我是cell上子控件的信号%@------控制器信号被我拦截了---%@------",NSStringFromClass([object class]),indexPath);
//}
//
//Click_signal(stepper){
//    UIStepper *view = (UIStepper *)object;
//    NSIndexPath *indexPath = view.indexPath;
//    NSLog(@"我是cell上子控件的信号%@----控制器信号被我拦截了-----%@------",NSStringFromClass([object class]),indexPath);
//}
@end
