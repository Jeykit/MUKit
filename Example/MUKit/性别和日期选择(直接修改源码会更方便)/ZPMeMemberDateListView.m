//
//  ZPMeMemberDateListView.m
//  ZPApp
//
//  Created by Jekity on 2018/9/21.
//  Copyright © 2018年 Jekity. All rights reserved.
//

#import "ZPMeMemberDateListView.h"

@interface ZPMeMemberDateListView()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,strong)UIPickerView *pickerView;
@property (nonatomic,strong)UIToolbar *toolBar;

@property (strong, nonatomic) NSMutableArray *yearArr; // 年数组
@property (strong, nonatomic) NSMutableArray *monthArr; // 月数组
@property (strong, nonatomic) NSMutableArray *dayArr; // 日数组

@property (copy, nonatomic) NSString *year; // 选中年
@property (copy, nonatomic) NSString *month; //选中月
@property (copy, nonatomic) NSString *day; //选中日
@end
@implementation ZPMeMemberDateListView

+(instancetype)sharedInstance{
    
    static ZPMeMemberDateListView * view = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        view = [[ZPMeMemberDateListView alloc]init];
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
        
        self.pickerView.delegate   = self;
        self.pickerView.dataSource = self;
        [self.pickerView reloadAllComponents];
       
        
    }
    return self;
}

#pragma -mark UIPickerViewDelegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return self.yearArr.count;
    }else if (component == 1){
        return self.monthArr.count;
    }
    return self.dayArr.count;
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
    
    switch (component) {
        case 0: { // 年
            
            NSString *year_integerValue =  self.yearArr[row];
            pickerLabel.text = [NSString stringWithFormat:@"%@年",year_integerValue];
          
        self.year = year_integerValue;
            
            
        }
            break;
        case 1: { // 月
            
            NSString *month_value = self.monthArr[row];
            self.month = [NSString stringWithFormat:@"%ld",row];
            pickerLabel.text = [NSString stringWithFormat:@"%@月",month_value];
            [self refreshDay];
        }
            break;
        case 2: { // 日
            /// 根据当前选择的年份和月份获取当月的天数
            NSString *dayStr = self.dayArr[row];
            self.day = dayStr;
            pickerLabel.text = [NSString stringWithFormat:@"%@日",dayStr];;
        }
            break;
    }
    
    [self pickerView:pickerView didSelectRow:row inComponent:component];//确保滚动的高亮颜色与选中的颜色一致
    return pickerLabel;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    UILabel *label = (UILabel *)[pickerView viewForRow:row forComponent:component];//设置高亮颜色
    label.textColor = [UIColor redColor];
}


#pragma -mark show or hide
-(void)showPickerView{
    self.hidden = NO;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.45 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.pickerView.y_Mu        =  CGRectGetHeight(self.frame)  - 216.;
        self.toolBar.y_Mu           =  CGRectGetHeight(self.frame)  - 216. - 44.;
        self.backgroundColor        =  [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
       
        
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
        self.resultBlock([NSString stringWithFormat:@"%@%@%@",_year,_month,_dayArr]);
    }
}
-(void)cancle{
    
    [self hidePickerView];
}
/// 获取年份
- (NSMutableArray *)yearArr {
    if (!_yearArr) {
        _yearArr = [NSMutableArray array];
        NSDate *date =[NSDate date];//简书 FlyElephant
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        
        [formatter setDateFormat:@"yyyy"];
        NSInteger currentYear=[[formatter stringFromDate:date] integerValue];
        
        for (int i = 1970; i < currentYear; i ++) {
            [_yearArr addObject:[NSString stringWithFormat:@"%d", i]];
        }
    }
    return _yearArr;
}
/// 获取月份
- (NSMutableArray *)monthArr {
    if (!_monthArr) {
        _monthArr = [NSMutableArray array];
        for (int i = 1; i <= 12; i ++) {
            [_monthArr addObject:[NSString stringWithFormat:@"%d", i]];
        }
    }
    return _monthArr;
}

/// 获取当前月的天数
- (NSMutableArray *)dayArr {
    if (!_dayArr) {
        _dayArr = [NSMutableArray array];
        for (int i = 1; i <= 31; i ++) {
            [_dayArr addObject:[NSString stringWithFormat:@"%d", i]];
        }
    }
    return _dayArr;
}
- (void)refreshDay {
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 1; i < [self getDayNumber:self.year.integerValue month:self.month.integerValue].integerValue + 1; i ++) {
        [arr addObject:[NSString stringWithFormat:@"%d", i]];
    }

    self.dayArr  = arr;
    [self.pickerView reloadComponent:2];
    [self.pickerView selectRow:0 inComponent:2 animated:YES];
}
- (NSString *)getDayNumber:(NSInteger)year month:(NSInteger)month{
    NSArray *days = @[@"31", @"28", @"31", @"30", @"31", @"30", @"31", @"31", @"30", @"31", @"30", @"31"];
    if (2 == month && 0 == (year % 4) && (0 != (year % 100) || 0 == (year % 400))) {
        return @"29";
    }
    return days[month];
}

@end
