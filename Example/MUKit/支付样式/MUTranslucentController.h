//
//  MUTranslucentController.h
//  MUKit
//
//  Created by Jekity on 2017/9/13.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MUTranslucentController : UINavigationController
-(instancetype)initWithCustomView:(UIView *)view;
+(instancetype)sharedInstance:(UIView *)customView;
@property(nonatomic, copy)NSString *centerTitle;

@property(nonatomic, assign)BOOL showLeftBarItem;
@property(nonatomic, assign)BOOL showRightBarItem;

@property(nonatomic, strong)UIImage *leftImage;
@property(nonatomic, strong)UIImage *rightImage;

@property(nonatomic, assign)BOOL hidesToolBar;

@property(nonatomic, weak ,readonly)UIView *customView;

@property(nonatomic, weak)UIViewController *nextController;
@property(nonatomic, assign)BOOL willDismiss;
@end
