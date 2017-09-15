//
//  MUSinglePaymentView.m
//  MUKit
//
//  Created by Jekity on 2017/9/14.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "MUSinglePaymentView.h"

@interface MUSinglePaymentView()<UITableViewDelegate ,UITableViewDataSource>
@property(nonatomic, strong)NSArray *modelArray;
@property(nonatomic, strong)UITableView *tableView;
@end

static NSString * const cellReusedIndentifier = @"cell";
@implementation MUSinglePaymentView
-(instancetype)initWithFrame:(CGRect)frame data:(NSArray *)array{
    if (self = [super initWithFrame:frame]) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStylePlain];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellReusedIndentifier];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 44.;
        _tableView.delegate  = self;
        _tableView.dataSource = self;
        [self addSubview:_tableView];
         _modelArray = array;
        
    }
    return self;
}
#pragma -mark delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReusedIndentifier forIndexPath:indexPath];
    cell.selectionStyle   = UITableViewCellSelectionStyleNone;
    if (self.renderBlock) {
        id model = self.modelArray[indexPath.row];
        self.renderBlock(cell, indexPath, model);
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.selectedBlock) {
         id model = self.modelArray[indexPath.row];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        self.selectedBlock(cell, indexPath, model);
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
