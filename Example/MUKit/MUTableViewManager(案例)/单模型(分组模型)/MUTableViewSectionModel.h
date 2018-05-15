//
//  MUTableViewSectionModel.h
//  SigmaTableViewModel
//
//  Created by zeng ping on 2017/8/3.
//  Copyright © 2017年 yangke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MUTableViewSectionModel : NSObject
@property (nonatomic ,copy)NSString *title;
@property (nonatomic ,strong)NSMutableArray *cellModelArray;
@end
