//
//  MUSwitchView.h
//  MUKit
//
//  Created by Jekity on 2017/9/14.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MUSwitchView : UIView
-(instancetype)initWithFrame:(CGRect)frame count:(NSUInteger)count;
@property(nonatomic, strong)NSArray *firstModelArray;
@property(nonatomic, strong)NSArray *secondModelArray;

@property(nonatomic, copy)void (^firstRenderBlock)(UITableViewCell *cell ,NSIndexPath *indexPath ,id model);
@property(nonatomic, copy)void (^firstSelectedBlock)(UITableViewCell *cell ,NSIndexPath *indexPath ,id model);

@property(nonatomic, copy)void (^secondRenderBlock)(UITableViewCell *cell ,NSIndexPath *indexPath ,id model);
@property(nonatomic, copy)void (^secondSelectedBlock)(UITableViewCell *cell ,NSIndexPath *indexPath ,id model);

-(void)goForward;
-(void)back;
@end
