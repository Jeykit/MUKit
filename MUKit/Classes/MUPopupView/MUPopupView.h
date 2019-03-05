//
//  MUPopupView.h
//  ZPWIM_Example
//
//  Created by Jekity on 2018/7/3.
//  Copyright © 2018年 392071745@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MUPopupView : UIView

- (instancetype)initWithItemButton:(UIBarButtonItem *)item modelArray:(NSArray *)modelArray;
- (instancetype)initWithButton:(UIButton *)button modelArray:(NSArray *)modelArray;
- (void)showView;
- (void)hideView;

@property (nonatomic,strong) UIColor *contentBackgroundColor;
@property (nonatomic,copy) void (^renderCellBlock)(UITableViewCell *cell ,id model ,NSIndexPath *indexPath);
@property (nonatomic,copy) void (^selectedCellBlock)(id model ,NSIndexPath *indexPath);
@end
