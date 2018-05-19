//
//  MUView.m
//  elmsc
//
//  Created by zeng ping on 2017/7/6.
//  Copyright © 2017年 Jekity. All rights reserved.
//

#import "MUView.h"

@interface MUView()
@property (nonatomic ,strong)UIView *infoView;//纯代码属性
@property (weak, nonatomic) IBOutlet UIButton *button;//xib上的控件与view关联，所以属于此view上的控件

@end
@implementation MUView
-(void)awakeFromNib{
    [super awakeFromNib];
    _infoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 100)];
    _infoView.backgroundColor = [UIColor redColor];
    [self addSubview:_infoView];
    _infoView.center = CGPointMake(self.button.centerX_Mu, self.centerY_Mu);
}

//只需实现这个方法，当你点击时(那个红色的view)就会执行，无需额外设置或操作
//'infoView'是需要实现响应事件的控件属性名称也是信号间相互区别的ID，Signal默认会根据控件属性的名称来确定执行的消息方法
Click_MUSignal(infoView){//如果控件所在的View(优先级最高)实现了信号方法，则会拦截cell和控制器的信号
    UIView *view = object;//object为Click_MUSignal方法里携带的响应控件的控件
     NSLog(@"我是%@\n在%@内被调用\n属于的view是%@\n属于的控制器是%@\n",NSStringFromClass([object class]),NSStringFromClass([self class ]),NSStringFromClass([self class ]),NSStringFromClass([view.viewController class]));
}
Click_MUSignal(button){
    UIButton *button = object;//object为Click_MUSignal方法里携带的响应控件的控件
    NSLog(@"我是%@\n在%@内被调用\n属于的view是%@\n属于的控制器是%@\n",NSStringFromClass([object class]),NSStringFromClass([self class ]),NSStringFromClass([self class ]),NSStringFromClass([button.viewController class]));
}
@end
