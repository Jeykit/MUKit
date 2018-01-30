//
//  ZCBCarHeaderView.h
//  MUKit_Example
//
//  Created by Jekity on 2017/12/26.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZCBCarHeaderView : UIView

//@property (nonatomic ,strong ,readonly) BSSCModel *model
;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@end
