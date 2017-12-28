//
//  MUPaperBaseView.h
//  AFNetworking
//
//  Created by Jekity on 2017/12/8.
//

#import <UIKit/UIKit.h>

@interface MUPaperBaseView : UIView

@property(nonatomic, assign)NSUInteger tabType;
@property(nonatomic, strong)  UIScrollView *contentScollView;//内容视图
@property(nonatomic, strong)  UIScrollView *tabbarScollView;
@property(nonatomic, strong)  NSArray *titleArray;
@property(nonatomic, strong)  NSArray *objectArray;
@property (assign, nonatomic) CGFloat tabbarItemHeight; /**< TopTab高度 **/
@property (strong, nonatomic) UIColor *underlineOrBlockColor; /**< 下划线或滑块颜色 **/
@property(nonatomic, strong)  UIColor *normalColor;
@property(nonatomic, strong)  UIColor *highlightedColor;
@property(nonatomic, assign)  CGFloat tabbarHeight;
@property (assign, nonatomic) CGFloat blockHeight; /**< 滑块高度 **/
@property (assign, nonatomic) BOOL autoFitTitleLine; /**< 下划线是否自适应标题宽度 **/
@property (assign, nonatomic) CGFloat bottomLineHeight; /**< 下划线高度 **/
@property (assign, nonatomic) CGFloat titlesFont; /**< 标题字体大小 **/
@property (assign, nonatomic) CGFloat titleScale; /**< 标题缩放比例 **/
@property (assign, nonatomic) NSInteger currentPageNumber; /**<  页码   **/
@property (assign, nonatomic) BOOL slideEnabled; /**< 允许下方左右滑动 **/
@property (assign, nonatomic) CGFloat cornerRadiusRatio; /**< 滑块圆角 **/
@property (assign, nonatomic) BOOL fontSizeAutoFit; /**< 文字自适应 > **/
@property (assign, nonatomic) NSInteger defaultPage; /**< 设置默认加载的界面 **/

@property(nonatomic, copy)void (^changedBlock)(NSUInteger previous ,NSUInteger selcted);

-(instancetype)initWithFrame:(CGRect)frame WithTopTabType:(NSInteger)type;

@end
