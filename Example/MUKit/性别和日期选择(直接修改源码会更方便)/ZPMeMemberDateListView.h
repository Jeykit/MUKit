//
//  ZPMeMemberDateListView.h
//  ZPApp
//
//  Created by Jekity on 2018/9/21.
//  Copyright © 2018年 Jekity. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZPMeMemberDateListView : UIView
@property (nonatomic,copy)void(^resultBlock)(id object) ;
+(instancetype)sharedInstance;
-(void)showPickerView;
-(void)hidePickerView;
@end

NS_ASSUME_NONNULL_END
