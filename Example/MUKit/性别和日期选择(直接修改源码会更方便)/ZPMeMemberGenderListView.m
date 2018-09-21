//
//  ZPWActivityListView.m
//  ZhaoCaiHuiBaoRt
//
//  Created by wzs on 2018/1/11.
//  Copyright © 2018年 ttayaa. All rights reserved.
//

#import "ZPMeMemberGenderListView.h"

@interface ZPMeMemberGenderListView()<UIPickerViewDelegate,UIPickerViewDataSource>


@property (nonatomic,strong)UIPickerView *pickerView;
@property (nonatomic,strong)UIToolbar *toolBar;
@property (nonatomic,strong)NSString *selectString;
@property (nonatomic,assign)NSUInteger provinceRow;
@property (nonatomic,copy) NSString *ID;
@end
@implementation ZPMeMemberGenderListView

+(instancetype)sharedInstance{
    
    static ZPMeMemberGenderListView * view = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        view = [[ZPMeMemberGenderListView alloc]init];
    });
    return view;
}

#pragma -mark initalization
-(instancetype)init{
    if (self = [super init]) {
        self.frame             = kScreenBounds;
        self.toolBar           = [[UIToolbar alloc]init];
        _pickerView            = [[UIPickerView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)+44., kScreenWidth, 216.)];
        _pickerView.backgroundColor = [UIColor whiteColor];
        
        self.hidden            = YES;
        self.toolBar.frame     = CGRectMake(0,  CGRectGetHeight(self.frame), kScreenWidth, 44.);
        [self addSubview:_toolBar];
        [self addSubview:_pickerView];
        UIBarButtonItem *leftButton   = [[UIBarButtonItem alloc]initWithTitle:@"  取消  " style:UIBarButtonItemStylePlain target:self action:@selector(cancle)];
        leftButton.tintColor          = [UIColor grayColor];
        UIBarButtonItem *rightButton  = [[UIBarButtonItem alloc]initWithTitle:@"  确定  " style:UIBarButtonItemStylePlain target:self action:@selector(sure)];
        rightButton.tintColor         = [UIColor redColor];
        UIBarButtonItem *spaceButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem *titleItem = [[UIBarButtonItem alloc]initWithTitle:@"请选择性别" style:UIBarButtonItemStylePlain target:nil action:nil];
        titleItem.tintColor          = [UIColor blackColor];
        
        
        self.toolBar.items            = @[leftButton,spaceButton,titleItem,spaceButton,rightButton];
        self.provinceRow              = 0;
     
        self.modelArray = @[@"男" ,@"女"];
        
    }
    return self;
}

#pragma -mark UIPickerViewDelegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.modelArray.count;
}
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *pickerLabel = (UILabel *)view;
    if (pickerLabel == nil) {
        CGRect frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.pickerView.bounds), 60);
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
    }

    pickerLabel.text = self.modelArray[row];

    [self pickerView:pickerView didSelectRow:row inComponent:component];//确保滚动的高亮颜色与选中的颜色一致
    return pickerLabel;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    self.provinceRow = row;
    UILabel *label = (UILabel *)[pickerView viewForRow:row forComponent:component];//设置高亮颜色
    label.textColor = [UIColor redColor];
}

//-----------
-(void)setModelArray:(NSArray *)modelArray{
    _modelArray = modelArray;
    self.pickerView.delegate   = self;
    self.pickerView.dataSource = self;
    [self.pickerView reloadAllComponents];
}
#pragma -mark show or hide
-(void)showPickerView{
    self.hidden = NO;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.45 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.pickerView.y_Mu        =  CGRectGetHeight(self.frame)  - 216.;
        self.toolBar.y_Mu           =  CGRectGetHeight(self.frame)  - 216. - 44.;
        self.backgroundColor        =  [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
        [self.pickerView selectRow:self.provinceRow inComponent:0 animated:YES];

    } completion:nil];

}
-(void)hidePickerView{
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.pickerView.y_Mu        =  CGRectGetHeight(self.frame)+44.;
        self.toolBar.y_Mu           =  CGRectGetHeight(self.frame);
        self.backgroundColor        = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];

    } completion:^(BOOL finished) {
        self.hidden = YES;
        [self removeFromSuperview];
    }];
}
#pragma -mark action
-(void)sure{
    [self hidePickerView];
    if (self.resultBlock) {
        self.resultBlock(self.modelArray[self.provinceRow]);
    }
}
-(void)cancle{
    
    [self hidePickerView];
}
@end
