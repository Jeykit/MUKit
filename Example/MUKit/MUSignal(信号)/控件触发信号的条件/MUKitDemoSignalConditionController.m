//
//  MUKitDemoSignalConditionController.m
//  MUKit_Example
//
//  Created by Jekity on 2018/5/18.
//  Copyright © 2018年 Jeykit. All rights reserved.
//

#import "MUKitDemoSignalConditionController.h"
#import "MUKitDemoSignalConditionView.h"

@interface MUKitDemoSignalConditionController ()
@property(nonatomic, strong)MUKitDemoSignalConditionView *headerView;
@end

@implementation MUKitDemoSignalConditionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"控件触发信号的条件";
    self.tableView.backgroundColor = [UIColor colorWithRed:240./255. green:240./255. blue:240./255. alpha:1.];
    self.tableView.tableHeaderView = [MUKitDemoSignalConditionView viewForXibMuWithRetainObject:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//把MUKitDemoSignalConditionView里的方法注释掉，我就会被调用
//UILabel 点击时触发
Click_MUSignal(label){
    UILabel *view = object;//object为Click_MUSignal方法里携带的响应控件的控件
    NSLog(@"我是%@\n在%@内被调用\nSignal触发事件是用户点击\n属于的view是%@\n属于的控制器是%@\n",NSStringFromClass([object class]),NSStringFromClass([self class]),NSStringFromClass([self class ]),NSStringFromClass([view.viewController class]));
}



//UIButton 默认触发条件是UIControlEventTouchUpInside，可通过allControlEvents(UIControl子类)属性更改触发条件
Click_MUSignal(button){
    UIButton *view = object;//object为Click_MUSignal方法里携带的响应控件的控件
    NSLog(@"我是%@\n在%@内被调用\nSignal触发事件是用户点击\n属于的view是%@\n属于的控制器是%@\n",NSStringFromClass([object class]),NSStringFromClass([self class]),NSStringFromClass([self class ]),NSStringFromClass([view.viewController class]));
}



//UISegmentedControl 默认触发条件是UIControlEventValueChanged，可通过allControlEvents(UIControl子类)属性更改触发条件
Click_MUSignal(segment){
    UISegmentedControl *view = object;//object为Click_MUSignal方法里携带的响应控件的控件
    NSLog(@"我是%@\n在%@内被调用\nSignal触发事件是用户点击\n属于的view是%@\n属于的控制器是%@\n",NSStringFromClass([object class]),NSStringFromClass([self class]),NSStringFromClass([self class ]),NSStringFromClass([view.viewController class]));
}



//UITextField 默认触发条件是UIControlEventEditingChanged，可通过allControlEvents(UIControl子类)属性更改触发条件
Click_MUSignal(textField){
    UITextField *view = object;//object为Click_MUSignal方法里携带的响应控件的控件
    NSLog(@"我是%@\n在%@内被调用\nSignal触发事件是用户点击\n属于的view是%@\n属于的控制器是%@\n",NSStringFromClass([object class]),NSStringFromClass([self class]),NSStringFromClass([self class ]),NSStringFromClass([view.viewController class]));
}


//UISlide 默认触发条件是UIControlEventValueChanged，可通过allControlEvents(UIControl子类)属性更改触发条件
Click_MUSignal(slide){
    UISlider *view = object;//object为Click_MUSignal方法里携带的响应控件的控件
   NSLog(@"我是%@\n在%@内被调用\nSignal触发事件是用户点击\n属于的view是%@\n属于的控制器是%@\n",NSStringFromClass([object class]),NSStringFromClass([self class]),NSStringFromClass([self class ]),NSStringFromClass([view.viewController class]));
}
    
    //UISwitch 默认触发条件是UIControlEventValueChanged，可通过allControlEvents(UIControl子类)属性更改触发条件
    Click_MUSignal(switchs){
        UISwitch *view = object;//object为Click_MUSignal方法里携带的响应控件的控件
        NSLog(@"我是%@\n在%@内被调用\nSignal触发事件是用户点击\n属于的view是%@\n属于的控制器是%@\n",NSStringFromClass([object class]),NSStringFromClass([self class]),NSStringFromClass([self class ]),NSStringFromClass([view.viewController class]));
    }
    
    
    
    //UIStepper 默认触发条件是UIControlEventValueChanged，可通过allControlEvents(UIControl子类)属性更改触发条件
    Click_MUSignal(stepper){
        UIStepper *view = object;//object为Click_MUSignal方法里携带的响应控件的控件
        NSLog(@"我是%@\n在%@内被调用\nSignal触发事件是用户点击\n属于的view是%@\n属于的控制器是%@\n",NSStringFromClass([object class]),NSStringFromClass([self class]),NSStringFromClass([self class ]),NSStringFromClass([view.viewController class]));
    }
    
    
    //UIImageView 点击时触发
    Click_MUSignal(imageView){
        UIImageView *view = object;//object为Click_MUSignal方法里携带的响应控件的控件
        NSLog(@"我是%@\n在%@内被调用\nSignal触发事件是用户点击\n属于的view是%@\n属于的控制器是%@\n",NSStringFromClass([object class]),NSStringFromClass([self class]),NSStringFromClass([self class ]),NSStringFromClass([view.viewController class]));
    }
    
    
    
    //UIView 点击时触发
    Click_MUSignal(view){
        UIView *view = object;//object为Click_MUSignal方法里携带的响应控件的控件
        NSLog(@"我是%@\n在%@内被调用\nSignal触发事件是用户点击\n属于的view是%@\n属于的控制器是%@\n",NSStringFromClass([object class]),NSStringFromClass([self class]),NSStringFromClass([self class ]),NSStringFromClass([view.viewController class]));
    }

@end
