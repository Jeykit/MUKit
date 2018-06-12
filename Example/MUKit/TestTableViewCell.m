//
//  TestTableViewCell.m
//  CHTableView
//
//  Created by charlie on 2018/6/5.
//  Copyright © 2018年 charlie. All rights reserved.
//

#import "TestTableViewCell.h"

@implementation TestTableViewCell
{
    UILabel *_label;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubViews];
    }
    return self;
}
- (void)addSubViews{
    _label = [[UILabel alloc]initWithFrame:CGRectMake(10,5, self.contentView.frame.size.width - 20, self.contentView.frame.size.height-10)];
    _label.textColor = [UIColor redColor];
    _label.font = [UIFont systemFontOfSize:15];
    _label.numberOfLines = 0;
    [self.contentView addSubview:_label];
    
//    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView.mas_left).offset(12);
//        make.right.equalTo(self.contentView.mas_right).offset(-12);
//        make.top.equalTo(self.contentView.mas_top).offset(12);
//        make.bottom.equalTo(self.contentView.mas_bottom).offset(-12);
//    }];
}
- (void)setModel:(NSString *)model{
    _model = model;
    _label.text =model;
}
@end
