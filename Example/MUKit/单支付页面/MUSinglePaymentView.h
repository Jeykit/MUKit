//
//  MUSinglePaymentView.h
//  MUKit
//
//  Created by Jekity on 2017/9/14.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MUSinglePaymentView : UIView
-(instancetype)initWithFrame:(CGRect)frame data:(NSArray *)array;
@property(nonatomic, copy)void (^renderBlock)(UITableViewCell *cell ,NSIndexPath *indexPath ,id model);
@property(nonatomic, copy)void (^selectedBlock)(UITableViewCell *cell ,NSIndexPath *indexPath ,id model);
@end
