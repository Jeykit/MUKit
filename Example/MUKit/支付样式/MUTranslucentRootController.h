//
//  MUTranslucentRootController.h
//  MUKit
//
//  Created by Jekity on 2017/9/13.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MUTranslucentController.h"

@interface MUTranslucentRootController : UIViewController
@property(nonatomic, strong)UIView *customView;
@property(nonatomic, copy)NSString *centerTitle;
@property(nonatomic, assign)BOOL showLeftBarItem;
@property(nonatomic, assign)BOOL showRightBarItem;

@property(nonatomic, strong)UIImage *leftImage;
@property(nonatomic, strong)UIImage *rightImage;

@property(nonatomic, assign)BOOL hidesToolBar;

@property(nonatomic, strong)MUTranslucentController *controller;

@property(nonatomic, strong)UIViewController *nextController;
@property(nonatomic, assign)BOOL willDismiss;
@end
