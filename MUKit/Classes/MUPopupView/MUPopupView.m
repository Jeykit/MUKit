//
//  MUPopupView.m
//  ZPWIM_Example
//
//  Created by Jekity on 2018/7/3.
//  Copyright © 2018年 392071745@qq.com. All rights reserved.
//

#import "MUPopupView.h"

@interface MUPopupContentView : UIView

@property (nonatomic,strong) UIView *contenView;
@property (nonatomic,assign) CGFloat itemWidth;

@end

@implementation MUPopupContentView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _contenView = [[UIView alloc]initWithFrame:CGRectMake(0, 12., frame.size.width, frame.size.height - 12.)];
        _contenView.backgroundColor = [UIColor whiteColor];
        _contenView.layer.cornerRadius = 6.;
        _contenView.layer.masksToBounds = YES;
        [self addSubview:_contenView];
    }
    return self;
}
#pragma mark - 绘制三角形
- (void)drawRect:(CGRect)rect
{
    UIBezierPath* _bezierPath = [UIBezierPath bezierPath];
    // 背景色
    [self.contenView.backgroundColor setFill];
    CGFloat startX = CGRectGetWidth(self.frame) - _itemWidth/2.;
     CGFloat startY = 0;
    [_bezierPath moveToPoint:CGPointMake(startX , startY)];
    [_bezierPath addLineToPoint:CGPointMake(startX + 9., startY+13.)];
    [_bezierPath addLineToPoint:CGPointMake(startX - 9. , startY+13.)];
    [_bezierPath closePath];
    [_bezierPath fill];
    
}
@end

@interface MUPopupView ()<UITableViewDataSource ,UITableViewDelegate>

@property (nonatomic,weak) UIBarButtonItem *weakItem;
@property (nonatomic,weak) UIView *weakView;
@property (nonatomic,strong) MUPopupContentView *contentView;
@property (nonatomic,strong) UIView *backgorundView;
@property (nonatomic,strong) NSArray *innerModelArray;
@property (nonatomic,strong) UITableView *tableView;

@end



static NSString * const cellReuseIndentifier = @"MUPopupViewCell";
@implementation MUPopupView

- (instancetype)initWithItemButton:(UIBarButtonItem *)item modelArray:(NSArray *)modelArray{
    if (self = [super init]) {
        _innerModelArray = modelArray;
        self.backgroundColor = [UIColor clearColor];
        self.weakItem = item;
        self.frame = [UIScreen mainScreen].bounds;
        [self addSubview:self.backgorundView];
        [self addSubview:self.contentView];
        
        self.contentView.layer.affineTransform = CGAffineTransformMakeScale(0.01, 0.01);
        self.layer.shadowOpacity = 0.5 ;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowRadius =  2.0;
    }
    return self;
}

- (void)setContentBackgroundColor:(UIColor *)contentBackgroundColor{
    _contentBackgroundColor = contentBackgroundColor;
    self.contentView.contenView.backgroundColor = contentBackgroundColor;
}
#pragma mark -懒加载
- (UIView *)contentView{
    
    if (!_contentView) {
        _contentView = [[MUPopupContentView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width * 0.38, 44*_innerModelArray.count+12.)];
        _contentView.backgroundColor = [UIColor clearColor];
        _tableView = [[UITableView alloc]initWithFrame:_contentView.contenView.frame style:UITableViewStylePlain];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellReuseIndentifier];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_contentView addSubview:_tableView];
    }
    return _contentView;
}

- (UIView *)backgorundView{
    
    if (!_backgorundView) {
        _backgorundView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _backgorundView.backgroundColor = [UIColor colorWithWhite:1. alpha:0.1];
                UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBackgroundView:)];
                [_backgorundView addGestureRecognizer:tapgesture];
    }
    return _backgorundView;
}
#pragma mark -delegate&dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.innerModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIndentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    id model = self.innerModelArray[indexPath.row];
    if (self.renderCellBlock) {
        self.renderCellBlock(cell, model, indexPath);
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    __weak typeof(self)weakSelf = self;
    [self hideViewFinishBlock:^{
        if (weakSelf.selectedCellBlock) {
            weakSelf.selectedCellBlock(self.innerModelArray[indexPath.row], indexPath);
        }
    }];
}
- (CGRect)convertRectToWindow:(UIBarButtonItem *)item{
    UIBarButtonItem *items = self.weakItem;
    UIView *view = [items valueForKey:@"view"];
    CGRect frame = [view convertRect:view.bounds toView:[UIApplication sharedApplication].keyWindow];
    return frame;
}


-(void)showView{
   
    CGRect frame = [self convertRectToWindow:self.weakItem];
    CGFloat contentWidth = [UIScreen mainScreen].bounds.size.width * .38;
    if (CGRectGetMinX(frame) < contentWidth) {//左边
        CGRect fitSzie = self.contentView.frame;
        fitSzie.origin.x = CGRectGetMinX(frame);
        fitSzie.origin.y  = CGRectGetMaxY(frame) - 12.;
        self.contentView.frame = fitSzie;
        self.contentView.itemWidth = (contentWidth - CGRectGetWidth(frame)/2.)*2.;
        self.contentView.layer.anchorPoint = CGPointMake(0, 0);
    }else{
    
        CGRect fitSzie = self.contentView.frame;
        fitSzie.origin.x = CGRectGetMaxX(frame) - CGRectGetWidth(self.contentView.frame);
        fitSzie.origin.y  = CGRectGetMaxY(frame) - 12.;
        self.contentView.frame = fitSzie;
         self.contentView.itemWidth = CGRectGetWidth(frame);
         self.contentView.layer.anchorPoint = CGPointMake(1., 0.);
    }
   
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration: 0.3 animations:^{
        self.contentView.layer.affineTransform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:nil];
  
}

-(void)hideView{
    [self hideViewFinishBlock:nil];
}
-(void)hideViewFinishBlock:(void(^)())doneBlock{
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.layer.affineTransform = CGAffineTransformMakeScale(0.01, 0.01);
        
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
        if (doneBlock) {
            doneBlock();
        }
    }];
}
- (void)tapBackgroundView:(UITapGestureRecognizer *)ges{
    [self hideView];
}
@end
