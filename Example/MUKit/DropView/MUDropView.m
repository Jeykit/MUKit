////
////  MUDropView.m
////  ZPWApp_Example
////
////  Created by Jekity on 2018/3/29.
////  Copyright © 2018年 Jekity. All rights reserved.
////
//
//#import "MUDropView.h"
//
//@interface MUDropView ()<UITableViewDelegate,UITableViewDataSource>
//
//@property (nonatomic) NSArray *innerTitleArray ;
//@property (nonatomic)UITableView *tableView;
//@property (nonatomic)NSMutableArray *tableDataArray;
//
//@property (nonatomic) CGFloat originalHeight ;
//
//@property (nonatomic) CGFloat tableViewMaxHeight ;
//
//@property (nonatomic) NSMutableArray *buttonArray;
//
//@property (nonatomic) UIView  *maskBackgroundView;
//
//@property (nonatomic,weak) UIButton *tempButton;
//
//@property (nonatomic,strong) NSMutableArray *selectedArray;
//
//@end
//@implementation MUDropView
//
//-(instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray{
//
//    if (self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 44.)]) {
//        self.tableViewMaxHeight = 44.*5;
//        self.originalHeight     = frame.size.height;
//        _innerTitleArray        = titleArray;
//        [self addSubview:self.maskBackgroundView];
//        [self addSubview:self.tableView];
//        [self cofiguredUI];
//    }
//    return self;
//}
//
//-(void)cofiguredUI{
//    UIView *menuView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 44.)];
//    menuView.backgroundColor=lineGrayColorMu;
//    [self addSubview:menuView];
//
//    _buttonArray = [NSMutableArray array];
//    _selectedArray = [NSMutableArray array];
//    CGFloat buttonWidth = kScreenWidth/self.innerTitleArray.count;
//    for (int index = 0; index < self.innerTitleArray.count;index++) {
//        UIButton *titleButton=[UIButton buttonWithType:UIButtonTypeCustom];
//        titleButton.frame= CGRectMake((buttonWidth+0.5) * index, 0, buttonWidth-0.5, 43.);
//        titleButton.backgroundColor =[UIColor whiteColor];
//        [titleButton setTitle:self.innerTitleArray[index] forState:UIControlStateNormal];
//        [titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        titleButton.titleLabel.textAlignment = NSTextAlignmentCenter;
//        titleButton.tag =1000 + index ;
//        titleButton.setSignalName(@"titleButton").enforceTarget(self);
//        titleButton.titleLabel.font = [UIFont systemFontOfSize:15];
////        [titleButton setTitleColor:[[UIColor blackColor]colorWithAlphaComponent:0.3] forState:UIControlStateSelected];
//        [titleButton setImage:[UIImage imageNamed:@"more_unfold"] forState:UIControlStateNormal];
//        [titleButton setImage:[UIImage imageNamed:@"less"] forState:UIControlStateSelected];
//        titleButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
//        [self addSubview:titleButton];
//        titleButton.swapPositionMu = YES;
//        [self.buttonArray addObject:titleButton];
//        [self.selectedArray addObject:@"0"];
//    }
//}
//-(UITableView *)tableView{
//    if (!_tableView) {
//        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44., kScreenWidth, 0) style:UITableViewStylePlain];
//        _tableView.delegate = self;
//        _tableView.dataSource = self;
//        _tableView.bounces    = NO;
//        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
//        _tableView.rowHeight = 44.;
//        [_tableView registerClass:[MUDropViewCell class] forCellReuseIdentifier:@"cell"];
//    }
//    return _tableView;
//}
//-(UIView *)maskBackgroundView{
//    if (!_maskBackgroundView) {
//        _maskBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,self.frame.size.width, kScreenHeight-self.frame.origin.y)];
//        _maskBackgroundView.hidden = YES;
//        _maskBackgroundView.backgroundColor = [UIColor colorWithRed:40/255 green:40/255 blue:40/255 alpha:.2];
//        _maskBackgroundView.setSignalName(@"maskBackgroundView").enforceTarget(self);
//    }
//    return _maskBackgroundView;
//}
//
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return self.tableDataArray.count;
//}
//
//
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    MUDropViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
//    cell.textLabel.text = self.tableDataArray[indexPath.row];
//    cell.tintColor = self.checkmarkColor?:cell.tintColor;
//    NSUInteger index = self.tempButton.tag % 1000;
//    NSString *string = self.selectedArray[index];
//    if ([string integerValue] == indexPath.row) {
//        cell.isSelected = YES;
//    }else{
//        cell.isSelected = NO;
//    }
//    return cell;
//}
//
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//
//    MUDropViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    NSInteger index = self.tempButton.tag%1000;
//    NSInteger previous = [self.selectedArray[index] integerValue];
//    if ( previous != indexPath.row) {
//
//        MUDropViewCell *previouCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:previous inSection:index]];
//        previouCell.isSelected = NO;
//        [previouCell layoutIfNeeded];//立即刷新
//
//        self.selectedArray[index] = NSStringFormat(@"%ld",indexPath.row);
//        cell.isSelected = YES;
//    }
//
//    if (self.selectDataBlock) {
//       self.selectDataBlock(index, self.innerTitleArray[index], indexPath.row);
//    }
//    self.tempButton.selected = NO;
//    self.tempButton.titleColorMu = blackColorMu;
//    [self takeBackTableView];
//    self.tempButton = nil;
//
//}
//
////展开。
//-(void)expandWithTableViewHeight:(CGFloat )tableViewHeight
//{
//    self.maskBackgroundView.hidden = NO;
//    CGRect rect = self.frame;
//    rect.size.height = kScreenWidth - self.frame.origin.y;
//    self.frame = rect;
//    [self showSpringAnimationWithDuration:0.3 animations:^{
//
//        self.tableView.frame = CGRectMake(0, 44, kScreenWidth, 220);
//
//        self.maskBackgroundView.alpha =1;
//
//    } completion:^{
//        self.height_Mu = kScreenHeight;
//    }];
//}
//
////收起。
//-(void)takeBackTableView
//{
//
//
//    CGRect rect = self.frame;
//    rect.size.height = self.originalHeight;
//    self.frame = rect;
//
//    [self showSpringAnimationWithDuration:.3 animations:^{
//        self.tableView.frame = CGRectMake(0, 44, kScreenWidth,0);
//        self.maskBackgroundView.alpha =0;
//
//    } completion:^{
//        self.maskBackgroundView.hidden = YES;
//        self.height_Mu = 44.;
//    }];
//
//}
//
//
//
//-(void)showSpringAnimationWithDuration:(CGFloat)duration
//                            animations:(void (^)())animations
//                            completion:(void (^)())completion
//{
//
//
//
//    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:.8 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseOut animations:^{
//
//        if (animations) {
//            animations();
//        }
//    } completion:^(BOOL finished) {
//        if (completion) {
//            completion();
//        }
//    }];
//}
//
//#pragma mark-signal
//Click_MUSignal(titleButton){
//
//    UIButton *button = object;
//    if (button != self.tempButton) {//展开
//        self.tempButton.titleColorMu = blackColorMu;
//        self.tempButton.selected = NO;
//        button.selected = YES;
//        self.tempButton = button;
//        button.titleColorMu = mainColorMu;
//        if (self.dataArray.count == 0) {
//            self.tableDataArray = [NSMutableArray array];
//        }else{
//            NSUInteger index = button.tag%1000;
//            if (index>self.dataArray.count-1) {
//                 self.tableDataArray = [NSMutableArray array];
//            }else{
//                self.tableDataArray = self.dataArray[index];
//                [self.tableView reloadData];
//            }
//        }
//        [self expandWithTableViewHeight:220];
//    }else{//收起
//        self.tempButton.selected = NO;
//        [self takeBackTableView];
//        self.tempButton.titleColorMu = blackColorMu;
//        self.tempButton = nil;
//    }
//}
//Click_MUSignal(maskBackgroundView){
//    [self takeBackTableView];
//    self.tempButton.titleColorMu = blackColorMu;
//    self.tempButton.selected     = NO;
//    self.tempButton = nil;
//}
//@end
//
//
//
//
//@implementation MUDropViewCell
//
//
//-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//
//        self.textLabel.font = [UIFont systemFontOfSize:15];
//        self.tintColor      = mainColorMu;
//    }
//
//    return self;
//}
//
//- (void)setIsSelected:(BOOL)isSelected
//{
//    _isSelected = isSelected;
//    if (isSelected) {
//
//         self.accessoryType = UITableViewCellAccessoryCheckmark;
//    }else
//    {
//         self.accessoryType = UITableViewCellAccessoryNone;
//    }
//}
//
//@end
//
