//
//  MUMessageTableView.m
//  ASHMUMessageTableViewDemo
//
//  Created by xmfish on 15/1/19.
//  Copyright (c) 2015年 ash. All rights reserved.
//

#import "MUMessageTableView.h"

@implementation MUMessageTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)setContentSize:(CGSize)contentSize
{
    if (!CGSizeEqualToSize(self.contentSize, CGSizeZero))
    {
        if (contentSize.height > self.contentSize.height)
        {
            CGPoint offset = self.contentOffset;
            offset.y += (contentSize.height - self.contentSize.height);
            self.contentOffset = offset;
        }
    }
    [super setContentSize:contentSize];
}
@end
