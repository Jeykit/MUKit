//
//  ZPWBaseTableView.m
//  ZPWApp_Example
//
//  Created by Jekity on 2018/4/2.
//  Copyright © 2018年 Jekity. All rights reserved.
//

#import "ZPWBaseTableView.h"

@implementation ZPWBaseTableView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

//-(void)setDelegate:(id<UITableViewDelegate>)delegate{
//    
//}
@end
