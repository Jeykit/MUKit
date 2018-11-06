//
//  MUView.m
//  elmsc
//
//  Created by zeng ping on 2017/7/6.
//  Copyright © 2017年 Jekity. All rights reserved.
//

#import "MUView.h"
#import "MUCheckbox.h"
#import "UIButton+MUImageCache.h"

@interface MUView()
@property (nonatomic ,strong)UIView *infoView;//纯代码属性
@property (weak, nonatomic) IBOutlet UIButton *button;//xib上的控件与view关联，所以属于此view上的控件
@property (nonatomic,strong) UITextView *textView;

@property (weak, nonatomic) IBOutlet MUCheckbox *checkBox;

@end
@implementation MUView
-(void)awakeFromNib{
    [super awakeFromNib];
    _checkBox.layer.masksToBounds = YES;
    _checkBox.borderStyle = MUBorderStyleCircle;
//    _checkBox.isChecked = YES;
    _checkBox.checkmarkStyle = MUCheckmarkStyleTick;
    _checkBox.borderWidth = 1.;
//    _checkBox.checkmarkColor = [UIColor purpleColor];
//    _checkBox.uncheckedBorderColor = [UIColor orangeColor];
//    _checkBox.checkedBorderColor = [UIColor purpleColor];
    _checkBox.checkmarkSize = 0.5;
    _checkBox.valueChanged = ^(BOOL isChecked) {
        
    };
    _infoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-48., 49.)];
    _infoView.backgroundColor = [UIColor redColor];
    UILabel *label = [UILabel new];
    label.textColor = [UIColor whiteColor];
    label.text = @"UIView(点我)";
    [label sizeToFit];
    [_infoView addSubview:label];
    label.center = _infoView.center;
    [self addSubview:_infoView];
    _infoView.center = CGPointMake(self.button.centerX_Mu, self.centerY_Mu - 44.);
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(24., CGRectGetMaxY(self.infoView.frame)+24., kScreenWidth - 48., 240.)];
    [self addSubview:_textView];
    _textView.text = @"显示结果的地方";
    _textView.backgroundColor = [UIColor colorWithRed:240./255. green:240./255. blue:240./255. alpha:1.];
    _textView.font = [UIFont systemFontOfSize:22.];
    _textView.textColor = [UIColor blackColor];
    
    [_button setImageURL:@"https://flyimage.oss-us-west-1.aliyuncs.com/1.jpg"];
}

//只需实现这个方法，当你点击时(那个红色的view)就会执行，无需额外设置或操作
//'infoView'是需要实现响应事件的控件属性名称也是信号间相互区别的ID，Signal默认会根据控件属性的名称来确定执行的消息方法
//Click_MUSignal(infoView){//如果控件所在的View(优先级最高)实现了信号方法，则会拦截cell和控制器的信号
//    UIView *view = object;//object为Click_MUSignal方法里携带的响应控件的控件
//    self.textView.text = [NSString stringWithFormat:@"我是%@\n在%@内被调用\n属于的view是%@\n属于的控制器是%@\n",NSStringFromClass([object class]),NSStringFromClass([self class ]),NSStringFromClass([self class ]),NSStringFromClass([view.viewController class])];
//}
//Click_MUSignal(button){
//    UIButton *button = object;//object为Click_MUSignal方法里携带的响应控件的控件
//     self.textView.text = [NSString stringWithFormat:@"我是%@\n在%@内被调用\n属于的view是%@\n属于的控制器是%@\n",NSStringFromClass([object class]),NSStringFromClass([self class ]),NSStringFromClass([self class ]),NSStringFromClass([button.viewController class])];
//}
@end
