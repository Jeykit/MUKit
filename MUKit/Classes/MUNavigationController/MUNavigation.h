//
//  MUNavigationTest.h
//  Pods
//
//  Created by Jekity on 2017/10/13.
//
//


/**
当前很多导航控制器的框架都是UINavigationController的类别，虽然用法简单但操作繁杂。几乎都是对Navigation Bar样式的统一设置，如果在一个控制器中设置了样式，然后push的下一个控制器也设置了样式。当pop时，如果没有还原Navigation Bar的样式，就会影响到上一个控制器的样式。这个框架很好解决了这个问题，而且如果你有自定义的UINavigationController，则它的设置不会影响到你的自定义导航控制器的样式。当然这个框架的缺点是不适合用于设置皮肤，因为Navigation Bar的样式是由UINavigationController里的控制器单独控制的。
 */
#import <Foundation/Foundation.h>

@interface UIViewController (MUNavigation)


/**
 当前导航栏是否为透明
 Whether or not the navigation bar is currently translucent.
 */
@property(nonatomic, assign) BOOL             navigationBarTranslucentMu;


/**
 当前导航栏的透明度
 Setting the navigation bar Alpha with a value(0 ~ 1).
 */
@property(nonatomic, assign) CGFloat          navigationBarAlphaMu;


/**
 当前导航栏是否隐藏
 Whether or not the navigation bar is currently hidden.
 */
@property(nonatomic, assign) BOOL             navigationBarHiddenMu;


/**
 当前导航栏颜色(不建议使用)
 Setting the navigation bar backgroundColor with UIColor.
 */
@property(nonatomic, strong) UIColor          *navigationBarBackgroundColorMu;


/**
 当前导航栏背景图片(建议使用)
 Setting the navigation bar backgroundImage with UIImage.
 */
@property(nonatomic, strong) UIImage          *navigationBarBackgroundImageMu;


/**
 当前导航栏的阴影线是否隐藏
 Whether or not the navigation bar shadow is currently hidden.
 */
@property(nonatomic, assign) BOOL             navigationBarShadowImageHiddenMu;//隐藏阴影线


/**
 当前导航栏的标题颜色
 Setting the navigation bar titleColor by UIColor.
 */
@property(nonatomic, strong) UIColor          *titleColorMu;


/**
 更改当前导航栏的默认控件或字体的颜色，如返回按钮的颜色
 Setting the navigation bar controls color by UIColor.
 */
@property(nonatomic, strong) UIColor          *navigationBarTintColor;//控件颜色


/**
 当前控制器不是导航控制器时，设置电池电量条的颜色
 Setting the statusBar Style in the UIControler which is not kind of UINavigationController.
 */
@property(nonatomic, assign) UIStatusBarStyle statusBarStyleMu;


/**
 当前控制器是导航控制器时，设置电池电量条的颜色
 Setting the statusBar Style in the UIControler which is kind of UINavigationController.
 */
@property(nonatomic, assign) UIBarStyle       barStyleMu;


/**
 控制器返回按钮图片，也可通过‘navigationBarTintColor’属性直接设置返回按钮的颜色
 Setting the  navigation bar backIndicatorImage with UIImage.
 */
@property(nonatomic, strong) UIImage          *backIndicatorImageMu;


/**
 返回按钮文字是否显示
 Whether or not the  navigation bar backItem title is currently hidden.
 */
@property(nonatomic, assign) BOOL             showBackBarButtonItemText;



/**
 导航条和电池电量条高度
 Return a value of navigation bar and status Bar height.
 */
@property(nonatomic, assign ,readonly) CGFloat navigationBarAndStatusBarHeight;


/**
 自定义titleLabel
 Custom title title UILabel .
 */
@property(nonatomic, readonly) UILabel         *titleLabel;


/**
 自定义titleView
 Custom title title UIView .
 */
@property(nonatomic, strong) UIView            *titleViewMu;

/**
 标题字体大小
 Setting the navigation bar titleFont with UIFont.
 */
@property(nonatomic, strong) UIFont            *titleFontMu;


/**
 当前导航栏在y轴方向上偏移距离
 Setting the navigation bar translation in the y axis with a value.
 */
@property(nonatomic, assign) CGFloat            navigationBarTranslationY;//导航在y轴方向上偏移距离


/**
 UIBarButtonLeftItem
 */
@property(nonatomic, readonly ,weak) UIBarButtonItem *leftButtonItem;


/**
 UIBarButtonRightItem
 */
@property(nonatomic, readonly ,weak) UIBarButtonItem *rightButtonItem;


/**
 UIBarButtonBackItem
 */
@property(nonatomic, readonly ,weak) UIBarButtonItem *backButtonItem;



/**
 @param title UIBarButtonLeftItem's title
 @param itemByTapped A block object to be executed when the UIBarButtonLeftItem by tapped
 */
- (void)addLeftItemWithTitle:(NSString *)title itemByTapped:(void(^)(UIBarButtonItem *item))itemByTapped;


/**
 @param image UIBarButtonLeftItem's image
 @param itemByTapped A block object to be executed when the UIBarButtonLeftItem by tapped
 */
- (void)addLeftItemWithImage:(UIImage *)image itemByTapped:(void(^)(UIBarButtonItem *item))itemByTapped;



/**
 @param title UIBarButtonRightItem's title
 @param itemByTapped A block object to be executed when the UIBarButtonRightItem by tapped
 */
- (void)addRightItemWithTitle:(NSString *)title itemByTapped:(void(^)(UIBarButtonItem *item))itemByTapped;



/**
 @param image UIBarButtonRightItem's image
 @param itemByTapped A block object to be executed when the UIBarButtonRightItem by tapped
 */
- (void)addRightItemWithImage:(UIImage *)image itemByTapped:(void(^)(UIBarButtonItem *item))itemByTapped;
@end


@interface UINavigationController (MUNavigationExtension)



/**
 @param controllerString UIController's name 控制器字符串，用于解耦，不需要导入控制器的头文件，配合NameToString这个宏使用会更好
 @param parameter A block object which used to passing parameters to 'controllerString' 把需要传递给‘controllerString’控制器的参数写在字典里
 */
- (void)pushViewControllerStringMu:(NSString *)controllerString animated:(BOOL)animated parameters:(void (^)(NSMutableDictionary * dict))parameter;



/**
 @param viewController UIController 控制器字符串，用于解耦，不需要导入控制器的头文件，配合NameToString这个宏使用会更好
 @param parameter A block object which used to passing parameters to 'controllerString'把需要传递给‘controllerString’控制器的参数写在字典里
 */
- (void)pushViewControllerMu:(UIViewController *)viewController animated:(BOOL)animated parameters:(void (^)(NSMutableDictionary * dict))parameter;
@end

