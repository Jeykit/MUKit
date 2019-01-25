//
//  MUTipsView.h
//  Pods
//
//  Created by Jekity on 2017/10/17.
//
//

#import <UIKit/UIKit.h>

@interface MUTipsView : UIView
@property(nonatomic, strong)UIImage  *tipsImage;//空白页提示图片
@property(nonatomic, copy)  NSString *tipsString;//提示文字
@property(nonatomic,weak ,readonly) UILabel *textLbael;
@property(nonatomic, strong ,readonly)UIButton *button;
@property(nonatomic, copy)void(^buttonByTaped)(UIButton *button);
@end
