//
//  MUKitDemoSignalView.m
//  MUKit_Example
//
//  Created by Jekity on 2018/5/18.
//  Copyright © 2018年 Jeykit. All rights reserved.
//

#import "MUKitDemoSignalView.h"

@interface MUKitDemoSignalView()
@property (nonatomic ,strong)UIView *infoView;//纯代码属性
@end

@implementation MUKitDemoSignalView
-(void)awakeFromNib{
    [super awakeFromNib ];
    _infoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width*0.62,  self.frame.size.height*0.62)];
    _infoView.backgroundColor = [UIColor redColor];
    [self addSubview:_infoView];
}
//-(instancetype)initWithFrame:(CGRect)frame{
//    if(self = [super initWithFrame:frame]){
//        _infoView = [[UIView alloc]initWithFrame:CGRectMake(5, 5, frame.size.width*0.85,  frame.size.height*0.85)];
//        _infoView.backgroundColor = [UIColor redColor];
//        [self addSubview:_infoView];
//    }
//    return self;
//}

//把我注释掉cell和controller才会被调用
Click_MUSignal(infoView){//如果控件所在的View(优先级最高)实现了信号方法，则会拦截cell和控制器的信号
    UIView *view = object;//object为Click_MUSignal方法里携带的响应控件的控件
    NSIndexPath *indexPath = view.indexPath;
    NSLog(@"我是cell上的子控件%@\n在%@内被调用\n属于的的自定义view是MUKitDemoSignalView属于的cell的indexpath:%@\n属于的控制器是%@\n",NSStringFromClass([object class]),NSStringFromClass([self class]),indexPath,NSStringFromClass([view.viewController class]));
}
@end
