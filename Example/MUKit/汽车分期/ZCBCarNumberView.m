//
//  ZCBCarNumberView.m
//  ZhaoCaiHuiBaoRt
//
//  Created by wzs on 2018/1/11.
//  Copyright © 2018年 ttayaa. All rights reserved.
//

#import "ZCBCarNumberView.h"

@interface ZCBCarNumberView()<UIPickerViewDelegate,UIPickerViewDataSource>


@property (nonatomic,strong)UIPickerView *pickerView;
@property (nonatomic,strong)UIToolbar *toolBar;
@property (nonatomic,strong)NSString *selectString;
@property (nonatomic,assign)NSUInteger provinceRow;
@end
@implementation ZCBCarNumberView

+(instancetype)sharedInstance{
    
    static ZCBCarNumberView * view = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        view = [[ZCBCarNumberView alloc]init];
    });
    return view;
}

#pragma -mark initalization
-(instancetype)init{
    if (self = [super init]) {
//        self.frame             = hScreenBounds;
        self.toolBar           = [[UIToolbar alloc]init];
//        _pickerView            = [[UIPickerView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)+44., hScreenWidth, 216.)];
        _pickerView.backgroundColor = [UIColor whiteColor];
        
        self.hidden            = YES;
//        self.toolBar.frame     = CGRectMake(0,  CGRectGetHeight(self.frame), hScreenWidth, 44.);
        [self addSubview:_toolBar];
        [self addSubview:_pickerView];
        UIBarButtonItem *leftButton   = [[UIBarButtonItem alloc]initWithTitle:@"  取消  " style:UIBarButtonItemStylePlain target:self action:@selector(cancle)];
        UIBarButtonItem *rightButton  = [[UIBarButtonItem alloc]initWithTitle:@"  确定  " style:UIBarButtonItemStylePlain target:self action:@selector(sure)];
        UIBarButtonItem *spaceButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        self.toolBar.items            = @[leftButton,spaceButton,rightButton];
        self.provinceRow              = 0;
        //        self.modelArray               = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24"];
        //
        //        [self.pickerView reloadAllComponents];
        //        [self.pickerView selectRow:12 inComponent:0 animated:NO];
        
    }
    return self;
}
//-(void)getOnlineData{
//
//    __block NSMutableArray *mArray = [NSMutableArray array];
//    [BSSCModel POSTResultWithPath:@"m=Api&c=User&a=getRegion" Params:^(BSSCParms *ParmsModel) {
//
//
//    } success:^(BSSCModel *model, NSMutableArray<BSSCModel *> *modelArr, id responseObject) {
//        if ([responseObject[@"status"] integerValue] == 1) {
//            self.modelArray = (NSArray *)responseObject[@"result"];
//            self.modelArray = [mArray mutableCopy];
//            [self.pickerView reloadAllComponents];
//            [self.pickerView selectRow:self.provinceRow inComponent:0 animated:YES];
//        }
//
//    } failure:^(NSError *error) {
//
//
//    }];
//
//
//
//}
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
//    BSSCModel *model = self.modelArray[row];
    pickerLabel.text = [NSString stringWithFormat:@"%@",self.modelArray[row]];
    return pickerLabel;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    self.provinceRow = row;
}
-(void)setModelArray:(NSArray *)modelArray{
    _modelArray = modelArray;
    self.pickerView.delegate   = self;
    self.pickerView.dataSource = self;
    [self.pickerView reloadAllComponents];
}
#pragma -mark show or hide
//-(void)showPickerView{
//    self.hidden = NO;
//    [[UIApplication sharedApplication].keyWindow addSubview:self];
//    [UIView animateWithDuration:0.45 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        self.pickerView.mj_y        =  CGRectGetHeight(self.frame)  - 216.;
//        self.toolBar.mj_y           =  CGRectGetHeight(self.frame)  - 216. - 44.;
//        self.backgroundColor        =  [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
//        [self.pickerView selectRow:0 inComponent:0 animated:YES];
//
//    } completion:nil];
//
//}
//-(void)hidePickerView{
//    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        self.pickerView.mj_y        =  CGRectGetHeight(self.frame)+44.;
//        self.toolBar.mj_y           =  CGRectGetHeight(self.frame);
//        self.backgroundColor        = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
//
//    } completion:^(BOOL finished) {
//        self.hidden = YES;
//        [self removeFromSuperview];
//    }];
//}
#pragma -mark action
-(void)sure{
    [self hidePickerView];
    if (self.resultBlock) {
        self.resultBlock([NSString stringWithFormat:@"%@",self.modelArray[self.provinceRow]]);
    }
}
-(void)cancle{
    
    [self hidePickerView];
}
@end
