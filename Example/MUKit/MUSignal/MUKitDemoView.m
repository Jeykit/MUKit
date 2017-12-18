//
//  MUKitDemoView.m
//  MUKit
//
//  Created by Jekity on 2017/9/13.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "MUKitDemoView.h"

@interface MUKitDemoView()
@property (nonatomic,strong)UIToolbar *toolBar;
@property(nonatomic, strong)UIView *contentView;
@end
@implementation MUKitDemoView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
         _toolBar           = [[UIToolbar alloc]init];
         _toolBar.frame     = CGRectMake(0,  CGRectGetHeight(self.frame), [UIScreen mainScreen].bounds.size.width, 44.);
        _contentView        = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 44., [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 44.)];
        [self addSubview:_contentView];
        UIBarButtonItem *leftButton   = [[UIBarButtonItem alloc]initWithTitle:@"  取消  " style:UIBarButtonItemStylePlain target:self action:@selector(cancle)];
        UIBarButtonItem *rightButton  = [[UIBarButtonItem alloc]initWithTitle:@"  确定  " style:UIBarButtonItemStylePlain target:self action:@selector(sure)];
        UIBarButtonItem *spaceButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        self.toolBar.items            = @[leftButton,spaceButton,rightButton];
        [self addSubview:_toolBar];
    }
    return self;
}

-(void)sure{
   
}
-(void)cancle{
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
