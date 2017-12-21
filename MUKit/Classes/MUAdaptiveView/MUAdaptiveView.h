//
//  MUAdaptiveView.h
//  MUKit
//
//  Created by Jekity on 2017/12/20.
//

#import <UIKit/UIKit.h>

@interface MUAdaptiveView : UIView
//方形压缩图image 数组
@property(nonatomic,strong) NSMutableArray * imageArray;
@property(nonatomic, copy)void(^addItemByTaped)(void);
@property(nonatomic, copy)void(^changedFrameBlock)(CGFloat needHeight);
@property(nonatomic, copy)void(^itemByTaped)(UICollectionViewCell *cell ,NSUInteger flag);
@property(nonatomic, assign)UICollectionViewScrollDirection scrollDirection;//滚动方向，水平时不改变frame
@property(nonatomic, strong)UIColor *tintColorMu;//删除按钮颜色
@property(nonatomic, assign)CGFloat cornerRadiusMu;//图片圆角
@property(nonatomic, copy)NSString *tipsString;//提示文字
@property(nonatomic, strong)UIColor *tipsTextColor;//提示文字颜色
@property(nonatomic, assign)NSUInteger rowItemCount;//设置每一行的最大item数目,默认为4
@property(nonatomic, strong)UIImage *tipsImage;//提示图片
@end
