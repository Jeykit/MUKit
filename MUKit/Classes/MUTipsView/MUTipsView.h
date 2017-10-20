//
//  MUTipsView.h
//  Pods
//
//  Created by Jekity on 2017/10/17.
//
//

#import <UIKit/UIKit.h>

@interface MUTipsView : UIView
@property(nonatomic, strong)UIImage  *tipsImage;
@property(nonatomic, copy)  NSString *tipsString;
@property(nonatomic, strong ,readonly)UIButton *button;
@property(nonatomic, copy)void(^buttonByTaped)(UIButton *button);
@end
