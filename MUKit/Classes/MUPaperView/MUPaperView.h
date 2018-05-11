//
//  MUPaperView.h
//  AFNetworking
//
//  Created by Jekity on 2017/12/8.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, MUPagerStyle) {
    /**<  上侧为下划线   **/
    MUPagerStyleBottomLine = 0, //Default style
    /**<  上侧为滑块   **/
    MUPagerStyleSlideBlock = 1,
    /**<  上侧只有文字颜色变化(没有下划线或滑块)   **/
    MUPagerStyleStateNormal = 2,
};
@interface MUPaperView : UIView

- (instancetype)initWithFrame:(CGRect)frame WithTopArray:(NSArray *)topArray WithObjects:(NSArray *)objects;
/**<
 *  顶部菜单栏的展示样式。
 *  The style of TopTab.
 **/
@property (assign, nonatomic) MUPagerStyle pagerStyles;
/**<
 *  上方标题未选中时颜色，默认颜色为灰色。
 *  The titles' color when not selected,default color is gray.
 **/
@property (strong, nonatomic) UIColor *normalTitleColor;

/**<
 *  上方标题选中时颜色，默认颜色为黑色。
 *  The titles' color when selected,default color is black.
 **/
@property (strong, nonatomic) UIColor *hightlightColor;
/**<
 *  在下划线模式下的下划线的颜色，默认十六进制颜色码为#ff6262。
 *  Underline's color in NinaPagerStyleBottomLine mode,default color code is #ff6262.
 **/
@property (strong, nonatomic) UIColor *tipsColor;
/**<
 *  设置默认加载的界面，默认加载的界面是第一页，您可以选择要加载第几页的页面，不仅仅局限于第一页这样的展示方法，更加灵活。
 *  Set default loading page,you can set this for index of your page.Not only loads first page,but also choose other pages as default page.More flexible.
 **/
@property (assign, nonatomic) NSInteger defaultPage;
/**
 *  上方TopTab的高度值，如果不设置默认值为40，请设置值大于25。
 *  TopTab height,default height is 40,please set it above 25.
 */
@property (assign, nonatomic) CGFloat topTabHeight;
/**
 *  您可以设置titleSize这个属性来设置标题的缩放比例(相对于原比例标题)。同时，在加入了顶部自定义视图之后，您可以通过设置此属性来对选中的view整体进行缩放，推荐您设置的范围在1~1.5之间，如果不设置此属性，默认的缩放比例为1.15。(需要注意的是，此属性不适用于NinaPagerStyleSlideBlock样式)
 *  You can set titleSize for title animation(compare to origin title).Meanwhile,after adding custom topTab,you also can set the property to the topTab view which selected.Command range between 1 and 1.5.If don't set this,default scale is 1.15.(TitleScale is not working on NinaPagerStyleSlideBlock)
 */
@property (assign, nonatomic) CGFloat titleScale;
/**<
 *  您可以对此参数进行设置来改变下划线的长度，此参数代表的是选中的整体部分的占比，默认为1，您可以对此进行设置，但推荐您尽量不要设置在0.5以下(此参数设置在两种样式中均可使用)。
 *  You can set this parameter to change the length of bottomline,the percent of selected button,default is 1.Recommand to set it above 0.5.
 **/
@property (assign, nonatomic) CGFloat selectBottomLinePer;
/**<
 *  您可以对此参数进行设置来改变下划线的高度，默认为2，若超过3，则默认为3。
 *  You can set this to change bottomline's height,default is 2,max height is 3.
 **/
@property (assign, nonatomic) CGFloat underlineHeight;
/**<
 *  NinaPagerStyleSlideBlock模式下的滑块高度。
 *  SliderBlock's height in NinaPagerStyleSlideBlock.
 **/
@property (assign, nonatomic) CGFloat sliderHeight;
/**<
 *  滑块的layer.cornerRadius属性，默认的计算公式是(滑块高度 / SlideBlockCornerRadius)，若您想要自定义调整，请修改此参数，如果不想要圆角，请设置此参数为0。
 *  Sliderblock's layer.cornerRadius,it equals to sliderHeight / SlideBlockCornerRadius,if you don't want cornerRadius,please set this to 0.
 **/
@property (assign, nonatomic) CGFloat sliderCornerRadiusRatio;
/**<
 *  上方TopTab下面的总览线是否隐藏，默认为不隐藏。
 *  Hide the topTab's underline(not the select underline) or not,default is NO.
 **/
@property (assign, nonatomic) BOOL underLineHidden;

/**
 *  上方标题的字体大小设置，默认为14。
 *  Title font in TopTab,default font is 14.
 */
@property (assign, nonatomic) CGFloat titleFont;

@property(nonatomic, assign)BOOL slideEnabled;

@property (assign, nonatomic) BOOL autoFitTitleLine; /**< 下划线是否自适应标题宽度 **/

@property (strong, nonatomic) UIColor *topTabbarBackgroundColor; /**< 菜单背景颜色 **/

@property(nonatomic, copy)void (^slidedPageBlock)(NSUInteger previous ,NSUInteger selcted);
@property (assign, nonatomic) BOOL fontSizeAutoFit; /**< 文字自适应 > **/
@end
