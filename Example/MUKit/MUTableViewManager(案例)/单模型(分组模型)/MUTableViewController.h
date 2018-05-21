//
//  MUTableViewController.h
//  SigmaTableViewModel
//
//  Created by zeng ping on 2017/8/3.
//  Copyright © 2017年 yangke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MUBaseClass.h"

typedef NS_ENUM(NSInteger, MemberType) {
    MemberTypeEmployee,
    MemberTypeManager,
};

@interface MUTableViewController : MUBaseViewTableViewController
@property (nonatomic, assign) MemberType type;
@end
