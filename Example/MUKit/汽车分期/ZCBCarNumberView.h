//
//  ZCBCarNumberView.h
//  ZhaoCaiHuiBaoRt
//
//  Created by wzs on 2018/1/11.
//  Copyright © 2018年 ttayaa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZCBCarNumberView : UIView
@property(nonatomic, strong)NSArray *modelArray;
@property (nonatomic,copy)void(^resultBlock)(NSString *string) ;
+(instancetype)sharedInstance;
-(void)showPickerView;
-(void)hidePickerView;
@end
