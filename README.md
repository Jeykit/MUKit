
# MUKit

[![CI Status](http://img.shields.io/travis/Jeykit/MUKit.svg?style=flat)](https://travis-ci.org/Jeykit/MUKit)
[![Version](https://img.shields.io/cocoapods/v/MUKit.svg?style=flat)](http://cocoapods.org/pods/MUKit)
[![License](https://img.shields.io/cocoapods/l/MUKit.svg?style=flat)](http://cocoapods.org/pods/MUKit)
[![Platform](https://img.shields.io/cocoapods/p/MUKit.svg?style=flat)](http://cocoapods.org/pods/MUKit)

## Installation
To run the example project, clone the repo, and run `pod install` from the Example directory first.

MUKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "MUKit"
```

#   MUNavigation去掉titleLabel和titleView属性，并增加实时改变导航栏效果
# MUSignal去掉重写的touchesBegan: withEvent:||touchesEnded: withEvent:||hitTest: withEvent:方法以避免和其它框架冲突

# MUImageCache2.0 
```
1.优化接口
2.修复时不时闪退问题
3.去掉Icon接口，实用价值太低
4.简化架构
5.提供渐进显示图片接口
```
#   核心【MUSignal、MUTableViewManager、MUNavigation】

#   【[简书](https://www.jianshu.com/u/7709ed94216c)】


##  MUKit原理介绍和讲解
###     MUKit.h
MUKit.h除了包含框架的大部分头文件，还包含大量提高效率的宏。如判断系统版本、加载本地图片、转字符串、实例化一个类、iPhone型号、版本号等
```
MUSignal -  添加事件还在用(addGestureRecognizer:/addTarget:action:forControlEvents:))？一个Click_MUSignal(#需要x响应事件的控件名称){//相应的业务代码}就能搞定!!!!!!   ~>    pod 'MUKit/Signal'

MUTableViewManager - UITabelView的delegate和dataSource方法不嫌烦吗?不就一个block的事儿 ~>    pod 'MUKit/TableViewManager'

MUNavigation    - 那些总需要(设置样式/复原样式)的导航(UINaviationController/UINavigationBar)框架就不能智能一点?  ~>    pod 'MUKit/Navigation'

MUScrollManager - UISCrollView(UITableView/UICollectionView)的嵌套滚动真有这么复杂？两行代码不可以解决？  ~>    pod 'MUKit/ScrollManager'

MUEPaymentManager - 配置第三方(微信/支付宝)支付还敢再简单一点吗？  ~>    pod 'MUKit/EPaymentManager'

MUShared - 不想使用第三方分享框架，不想数据被收集？为什么不试试这个呢？  ~>    pod 'MUKit/Shared'

MUNetworking - 数据都请求回来了，就不会主动生成数据模型?  ~>    pod 'MUKit/Networking'

MUImageCache - 图片下载回来，还要再画个圆角，画个圆角还被说离屏渲染影响性能? 这锅我不背。  ~>    pod 'MUKit/ImageCache'

MUPhotoPreview - 有了模型，还要从模型中提取URL(图片地址)才能显示图片?简单点，实现的方式简单点  ~>    pod 'MUKit/PhotoPreview'

MUTextKit - 富文本，你有Facebook写得好吗？  ~>    pod 'MUKit/MUTextKit'

MULevitate - 悬浮球/悬浮按钮，还可以拖动哦  ~>    pod 'MUKit/Levitate'

MUSegmentView 分段视图  ~>    pod 'MUKit/MUSegmentView'

MUTag 标签控件  ~>    pod 'MUKit/Tag'


```
###     MUTextKit -富文本框架，源码核心来自Facebook 【[ASDK](https://github.com/facebookarchive/AsyncDisplayKit)】TextKit部分. 
区别
```.  文本末尾添加点击事件的方式不同
 .  取消长按高亮文本(没实现)
 .  支持Autolayout(类似UIButton 、UILabel)

```

###     PhotoPreview  -简单易用的图片浏览器
原理:通过轮播图的循环机制实现，以免浪费内存。
```

MUPhotoPreviewController *controller = [MUPhotoPreviewController new];//初始化
controller.currentIndex = 1;//指定开始图片浏览的索引
controller.configuredImageBlock = ^(UIImageView *imageView, NSUInteger index, id model ,NSString **caption) {
[imageView setImageURL:model placeHolderImageName:@"1024_s"];//下载网络图片
};

controller.modelArray = @[

];//图片模型数组

[self.navigationController pushViewController:controller animated:YES];//显示

----如果需要对图片进行额外操作如保存、分享，可自定义菜单功能---------
UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 22, 22)];
button.titleStringMu = @"保存";
[button addTarget:self action:@selector(Carousel) forControlEvents:UIControlEventTouchUpInside];
UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:button];

UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 22, 22)];

button1.titleStringMu = @"分享";
UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:button1];
controller.toolbar.items = @[leftItem,rightItem];

```
![image](https://github.com/jeykit/MUKit/blob/master/Example/MUKit/Gif/PhotoPreview.gif )

###     MUImageCache 2.0 -图片缓存的另一种解决方案，参考[FlyImage]
```
2.0 优化
1.优化接口
2.修复时不时闪退问题
3.去掉Icon接口，实用价值太低
4.简化架构
5.提供渐进显示图片接口
6.支持mmap内存映射，高效的I/O操作，减少一次文件拷贝操作
7.减少内存占用；
支持Byte Alignment字节对其，渲染过程中，避免执行CA::Render::copy_image内存操作
8.优化图片下载管理
9.支持GIF解码
10.支持图片绘制圆角，并避免调用(  layer.cornerRadius;
layer.masksToBounds)
11.降低图片下载时占用内存过大(具体可对比SDWebImage下载图片时的内存使用情况)
```
使用方式
```
/**
*
*
*  @param imageURLString originalURL
*/
- (void)setImageURLString:(NSString*)imageURLString;

/**
*  Download images and render them with the below order:
*  1. imageURLString
*  2. placeHolderImageName
*
*  These images will be saved into [FlyImageCache shareInstance]
*/
- (void)setImageURLString:(NSString*)imageURLString
placeHolderImageName:(NSString*)imageName;


/**
*  Download images and render them with the below order:
*  1. imageURLString
*  2. placeHolderImageName
*  3. cornerRadius
*
*  These images will be saved into [MUImageCache shareInstance]
*/
- (void)setImageURLString:(NSString*)imageURLString
placeHolderImageName:(NSString*)imageName
cornerRadius:(CGFloat)cornerRadius;

/**
*  Download images and render them with the below order:
*  1. imageURLString
*  2. placeHolderImageName
*  3. cornerRadius
*  4. 渐进显示图片，适合大图显示
*  These images will be saved into [MUImageCache shareInstance]
*/
- (void)setProgressImageURLString:(NSString*)imageURLString
placeHolderImageName:(NSString*)imageName
cornerRadius:(CGFloat)cornerRadius;

```
![image](https://github.com/jeykit/MUKit/blob/master/Example/MUKit/Gif/imageCache.gif )

###     MUSignal    -   重新定义事件实现及回调方式

优势:
```
1.取代传统事件的定义-实现方式
2.取代子视图回调至父视图、cell(UITableViewCell/UICollectionViewCell)、controller的回调事件
3.只需在view/cell/controller里实现Click_MUSignal(switchSite){}就可以接受事件，switchSite是需要触发事件的控件属性名称
```
传统的事件实现方式
```
/**UIView 类*/
UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapedLabel:)];
[label addGestureRecognizer:tapGesture];


/**UIControl 类 */
UIButton *button = [UIButton new];
[button addTarget:self action:@selector(clickedButton:) forControlEvents:UIControlEventTouchUpInside];
```
事件回调方式
```
事件回调的方式普遍采用的是delegate、通知、block、kvo等几种方式，但这些方式都相对来说繁琐一些，需要手动移除监听避免循环引用
```
原理:通过runtime和Responder Chain(响应链)动态获取控件的属性名称并执行对应的响应方法。该框架并没有截取原生事件的响应链，而是另外增加了一条响应链.支持纯代码和xib.
Signal响应方法的优先级为:view(控件所在的view)>cell(控件所在的UITableViewCell或者UICollectionViewCell)>UIViewController(控件属于的控制器),即Signal响应方法有且只有一个执行.UIViewController是Signal默认实现响应方法的对象。
Signal的事件实现方式：
![image](https://github.com/jeykit/MUKit/blob/master/Example/MUKit/Gif/signal.png )
控件触发信号的条件
![image](https://github.com/jeykit/MUKit/blob/master/Example/MUKit/Gif/signal_c.gif )

Signal在UIView实现
![image](https://github.com/jeykit/MUKit/blob/master/Example/MUKit/Gif/signal_v.gif )

Signal在UITableViewCell实现
![image](https://github.com/jeykit/MUKit/blob/master/Example/MUKit/Gif/signal_e.gif )

Signal在UIControllerl实现
![image](https://github.com/jeykit/MUKit/blob/master/Example/MUKit/Gif/signal_n.gif )

具体用法请参考源码中的MUSignal(信号)
***
###     MUTableViewManager  一行代码无需写烦人的delegate和dataSource
MUTableViewManager的优势：
1. 隐藏UITableView的delegate和dataSource，无需手动处理
2. 自动计算和缓存行高，无需任何额外设置
3. 自动拆解模型，根据传进来的数据，自动拆解为每一个cell对应的model，无需手动处理

区别:
UITableView+FDTemplateLayoutCell框架的缓存机制是通过NSDictionary数组，把NSIndexPath作为key，对应NSIndexPath的cell的高度作为value来缓存高度。而MUTableViewManager的缓存机制是通过runtime把高度缓存在cell对应的model里，当model销毁时对应的高度也会被销毁，无需额外写一套机制来处理。
``` 
//初始化
MUTableViewManager *tableViewManger = [[MUTableViewManager alloc]initWithTableView:self.tableView registerCellNib:NSStringFromClass([MUKitDemoTableViewCell class]) subKeyPath:@“result”];
//传递模型
tableViewManger = [@[@"分组模型数据例子",@"动态计算行高例子"] mutableCopy];
//赋值
tableViewManger.renderBlock = ^UITableViewCell *(UITableViewCell *cell, NSIndexPath *indexPath, id model, CGFloat *height) {
cell.textLabel.text = [NSString stringWithFormat:@"%@",model];
return cell;
};
```
具体用法请参考源码中的MUTableviewManager(MVVM TableView)

![image](https://github.com/jeykit/MUKit/blob/master/Example/MUKit/Gif/tableViewManager_1.png ) ![image](https://github.com/jeykit/MUKit/blob/master/Example/MUKit/Gif/tableviewManager.gif )
***

###     MUNavigation 轻量 简单 易用 的导航框架
___
#### MUNavigation 导航框架原理(与其它导航框架的区别)
MUNavigation的原理是不直接对Navigation bar操作，而是把navigation bar的样式存储在UIViewController里，当UIViewController调用-(void)viewWillAppear:(BOOL)animated时，一次性设置当前UIViewController的navigation bar样式，这样每个UIViewController的navigation bar样式就是相互独立的，互不影响。当UIViewController没有设置任何Navigation bar样式时，他就会取UIViewController的UINavigationController(全局设置)的Navigation bar样式,作为当前UIViewController的Navigation bar样式。UIViewController只需设置一次Navigation bar的样式代码，无需考虑UIViewController间的Navigation bar样式影响。大量节省代码和时间，集中精力处理业务.
MUNavigation里只有一个UIViewController (MUNavigation)分类文件，里面可以配置一些属性
```
@property(nonatomic, assign)BOOL             navigationBarTranslucentMu;//透明导航栏
@property(nonatomic, assign)CGFloat          navigationBarAlphaMu;//透明度
@property(nonatomic, assign)BOOL             navigationBarHiddenMu;//隐藏导航栏
@property(nonatomic, strong)UIColor          *navigationBarBackgroundColorMu;//背景颜色
@property(nonatomic, strong)UIImage          *navigationBarBackgroundImageMu;//背景图片
@property(nonatomic, assign)BOOL             navigationBarShadowImageHiddenMu;//隐藏阴影线
@property(nonatomic, strong)UIColor          *titleColorMu;//标题颜色
@property(nonatomic, strong)UIColor          *navigationBarTintColor;//控件颜色
@property(nonatomic, assign)UIStatusBarStyle statusBarStyleMu;//电池电量条,没有导航控制器的情况下使用
@property(nonatomic, assign)UIBarStyle       barStyleMu;//电池电量条，有导航控制器的情况下使用
@property(nonatomic, strong)UIImage          *backIndicatorImageMu;//返回按钮图片
@property(nonatomic, assign)BOOL             showBackBarButtonItemText;//是否显示返回按钮文字
@property(nonatomic, assign ,readonly)CGFloat navigationBarAndStatusBarHeight;//导航条和电池电量条高度
@property(nonatomic, readonly)UILabel         *titleLabel;//自定义标题
@property(nonatomic, strong)UIView            *titleViewMu;//自定义titleView
@property(nonatomic, strong)UIFont            *titleFontMu;//标题字体
@property(nonatomic, assign)CGFloat            navigationBarTranslationY;//导航在y轴方向上偏移距离
```
属性虽然看起来有点多，但其实都是UINavigationBar和UIController的一些常用属性。实际用起来也很简单，如下代码所示就对一个UINavigationController内的所有UIViewController的UINavigationBar样式做了统一处理。

```  UINavigationController *navigationController       = [[UINavigationController alloc]initWithRootViewController:        [UIViewController new]];
navigationController.barStyleMu                     = UIBarStyleBlack;//设置电池电量条的样式
navigationController.navigationBarBackgroundImageMu = [UIImage imageFromColorMu:[UIColor colorWithRed:250./255. green:25./255. blue:64./255. alpha:1.]];//导航条的图片
navigationController.navigationBarTintColor        = [UIColor whiteColor];//返回按钮箭头颜色
navigationController.titleColorMu                  = [UIColor whiteColor];//标题颜色
self.window.rootViewController                     = navigationController;
```

如果想控制单个UIViewController的样式，在 viewDidLoad 中通过分类配置想要的效果即可
```
@implementation DemoController
- (void)viewDidLoad {
[super viewDidLoad];
self.navigationBarHiddenMu = YES;//隐藏
self.statusBarStyleMu = UIStatusBarStyleDefault;//更改电池电量条样式
}
```
如果想使用类似京东、淘宝等APP全屏侧滑的导航方法只需初始化即可
```
   MUNavigationController *navigationController = [[MUNavigationController alloc]initWithRootViewController:[UIViewController new]];
```
具体用法请参考源码中的MUNavigation(导航框架案例)

![image](https://github.com/jeykit/MUKit/blob/master/Example/MUKit/Gif/navigation_t.gif) ![image](https://github.com/jeykit/MUKit/blob/master/Example/MUKit/Gif/navigation_h.gif) ![image](https://github.com/jeykit/MUKit/blob/master/Example/MUKit/Gif/navigation_a.gif) 

![image](https://github.com/jeykit/MUKit/blob/master/Example/MUKit/Gif/navigation_x.gif) ![image](https://github.com/jeykit/MUKit/blob/master/Example/MUKit/Gif/navigation_s.gif)

![image](https://github.com/jeykit/MUKit/blob/master/Example/MUKit/Gif/navigation_x.gif) ![image](https://github.com/jeykit/MUKit/blob/master/Example/MUKit/Gif/navigation.gif)
___

###     MUImagePickerManager-简单易用
```
MUImagePickerManager  *controller = [MUImagePickerManager new];
controller.allowsMultipleSelection = YES;//单选或多选
controller.mediaType = MUImagePickerMediaTypeVideo;//选择图片或视频
//            controller.navigationBarBackgroundImageMu = [UIImage imageFromColorMu:[UIColor whiteColor]];
controller.maximumNumberOfSelection = 12;
//            [controller takePhotoPresentIn:self allowedEditedImage:YES selectedImage:^(UIImage *origanlImage, UIImage *editedImage) {
//                NSLog(@"image====%@=======editt======%@",origanlImage,editedImage);
//            }];
[controller presentInViewController:self];
weakify(self)
controller.didFinishedPickerImages = ^(NSArray<__kindof UIImage *> *images) {//选择完成
normalize(self)
for (UIImage *image in images) {
NSLog(@"image====%@",image);
}
};
controller.didFinishedPickerVideos = ^(NSArray *videoURLs) {//选择视频回调的URL

normalize(self)
for (NSString *url in videoURLs) {
NSLog(@"url====%@",url);
}
};
```

![image](https://github.com/jeykit/MUKit/blob/master/Example/MUKit/Gif/photos.gif )

###  MUPopupView(仿QQ下拉菜单)-简单易用
```
MUPopupView *popupView = [[MUPopupView alloc]initWithItemButton:item modelArray:@[@{@"text":@"修改分组名称",@"image":@"modify"},@{@"text":@"添加分组",@"image":@"New-addition"}]];//初始化

popupView.renderCellBlock = ^(UITableViewCell *cell, id model, NSIndexPath *indexPath) {//菜单样式

    NSDictionary *dict = model;
    cell.textLabel.text = dict[@"text"];
    cell.textLabel.font = [UIFont systemFontOfSize:12.];
    cell.imageView.image = [UIImage imageNamed:dict[@"image"]];
};
popupView.selectedCellBlock = ^(id model, NSIndexPath *indexPath) {//选择菜单后
    if (indexPath.row == 0) {

    }else{

    }
};
[popupView showView];
```

![image](https://github.com/jeykit/MUKit/blob/master/Example/MUKit/Gif/popupView.gif )

###     MUKeyboard(仿微信键盘)
![image](https://github.com/jeykit/MUKit/blob/master/Example/MUKit/Gif/keyboard.gif )

###     MUCheckbox-迷你的小控件 有了它再也不需要求UI切图了
```
typedef NS_ENUM(NSUInteger ,MUCheckmarkStyle){
/// ■
MUCheckmarkStyleSquare            = 1,
/// ●
MUCheckmarkStyleCircle,
/// ╳
MUCheckmarkStyleCross,
/// ✓
MUCheckmarkStyleTick
};
typedef NS_ENUM(NSUInteger ,MUBorderStyle){
/// ▢
MUBorderStyleSquare            = 1,
/// ◯
MUBorderStyleCircle,

};

@property (nonatomic,strong)IBInspectable UIColor *uncheckedBorderColor;//未选时边框的颜色
@property (nonatomic,strong)IBInspectable UIColor *checkedBorderColor;//选中时边框的颜色

/// **Default:** The current tintColor.
@property (nonatomic,strong)IBInspectable UIColor *checkmarkColor;//选中时内部样式的颜色
```
![image](https://github.com/jeykit/MUKit/blob/master/Example/MUKit/Gif/ceckbox.gif )
###     MURefresh-迷你的刷新控件 主要配合MUTableViewManager使用，当然也可以单独使用
这款刷新控件与其它不同之处的地方在于，第一次下拉刷新是自动触发，而且不会显示刷新的状态和效果，但会执行刷新方法。当手动下拉刷新时，你才会看到刷新状态.这样设计的目的是不需要重复写请求链接。
```
//MURefresh
//下拉控件样式
self.tableViewManager.refreshHeaderComponent.textColor = [UIColor redColor];//刷新成功后的提示文字颜色
self.tableViewManager.refreshHeaderComponent.styleColor = [UIColor greenColor];//刷新控件颜色
self.tableViewManager.refreshHeaderComponent.animationStyle = MUReplicatorLayerAnimationStyleCircle;//刷新样式，可以不设置

weakify(self)
[self.tableViewManager addHeaderRefreshing:^(MURefreshComponent *refresh) {
normalize(self)
[refresh endRefreshingWithText:@"数据加载成功" completion:^{
self.tableViewManager.modelArray = [self CustomerModelArray];
}];

}];


//上拉刷新
//上拉控件使用默认样式
[self.tableViewManager addFooterRefreshing:^(MURefreshComponent *refresh) {
//延时3s再结束刷新
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
[refresh endRefreshingWithText:@"没有更多数据了" completion:^{
}];
});

}];
````
![image](https://github.com/jeykit/MUKit/blob/master/Example/MUKit/Gif/MURefresh.gif )
###     ScrollManager -解决UIScrollView嵌套滚动的另一种方案，简单、易用、无侵入性
想要做到无侵入性首先需要解决UIScrollView的delegate问题。例如在UITableView嵌套UICollectionView的一般解决方案中，会在同一个文件中处理它们的delegate和dataSource问题，并且监听scrollViewDidScroll：方法。代码如下:
```
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.nestScrollViewMU) {
        if (!self.arrivedTop) {//没有到达顶部
        scrollView.contentOffset = CGPointZero;
    }
    if (scrollView.contentOffset.y < 0) {
        scrollView.contentOffset = CGPointZero;
        self.arrivedTop = NO;
        }
    }

    if (scrollView == self.originalScrollView) {
        if (scrollView.contentOffset.y >= self.offsetMU) {//到达顶部，可以滚动
        scrollView.contentOffset = CGPointMake(0, self.offsetMU);
        self.arrivedTop = YES;//到达顶部
    }else{

        if(self.arrivedTop&&self.nestScrollViewMU.contentSize.height>CGRectGetHeight(self.nestScrollViewMU.bounds)+self.marginHeight) {
scrollView.contentOffset = CGPointMake(0, self.offsetMU);
            }
        }
    }
}
```
如果是使用MUScrollManager，那么你需要做的就两步，而且不会影响已经设置的delegate和dataSource
```
1.定义一个MUScrollManager属性，如下
    @property (nonatomic,strong) MUScrollManager *manager;
2.初始化一个MUScrollManager实例，如下
    self.manager = [[MUScrollManager alloc]initWithScrollView:tableView nestedScrollView:nestTableView offset:284.];//这个实例化说明的意思是nestTableView嵌套在tableView上，并且当tableView偏移了284的时候，nestTableView才会滚动
```
![image](https://github.com/jeykit/MUKit/blob/master/Example/MUKit/Gif/scrollView.gif )
具体用法参考MUPaperView这一项


###     MUNetworking 网络框架原理(与其它框架的区别)
___
MUNetworking的优势在于会自动把响应数据转换成相应的模型，而无需手动处理。节省大量代码，可以把精力放在处理业务上。
目前有许多基于AFNetworking二次封装的网络框架，但大多数的核心都放在请求缓存上，几乎没有处理参数和响应数据基本需求的框架。
如果你正在寻找提高效率的工具，那这个应该是你的首选。(如果有比这个更简单和高效率的请告诉我^_^)。

MUNetworking 主要包含两个模型MUNetworkingModel(数据模型)、MUParameterModel(参数模型),这两个模型都遵循YYModel协议。
使用时需要生成两个分别继承MUNetworkingModel、MUParameterModel的类。如MUModel:MUNetworkingModel MUParaModel:MUParameterModel.
在MUModel中进行如下配置:
```   #import <Foundation/Foundation.h>
#import "MUNetworkingModel.h"
#import "MUParaModel.h"

@interface MUModel : MUNetworkingModel
MUNetworkingModelInitialization(MUModel,MUParaModel)//含义是，把当前模型类，参数类传递给网络框架


@property (nonatomic,copy) NSString *Extend;//这是你需要转换的模型字段
@property (nonatomic,copy) NSString *PayMoney;//这是你需要转换的模型字段
@end

然后在你调起请求前的其它地方配置网络框架参数如在AppDelegate里配置
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

//配置模型类名、参数模型类名、域名、证书、数据格式
[MUModel GlobalConfigurationWithModelName:@"MUModel" parameterModel:@"MUParaModel" domain:@“www.blueberry.com” Certificates:nil dataFormat:@{@"Success":@"Success",@"Status":@"ret",@"Data":@"Content",@"Message":@"Result"}];

//全局监听网络请求状态
[MUModel GlobalStatus:nil networkingStatus:^(NSUInteger status) {
if (status == 401) {//token失效
//CommonTips(@"登录已失效，请重新登录")
[self login];需要重新登录
}
}];

}
```
具体用法请参考源码中的MUNetworking(网络框架例子)

![image](https://github.com/jeykit/MUKit/blob/master/Example/MUKit/Gif/networking_1.png) ![image](https://github.com/jeykit/MUKit/blob/master/Example/MUKit/Gif/networking.gif)


 ###    MUPayment
    封装了Alipay和WeChatPay，只需添加对应的黑白名单以及模式名称和继承MULoadingModel类进行如下初始化
``` -(instancetype)init{

 if (self = [super init]) {
 self.AppDelegateName = @"MUKitDemoAppDelegate";
 self.alipayID        = @"支付宝支付得ID";
 self.alipayScheme    = @"mualipayment";
 self.weChatPayID     = @"申请的微信ID";
 self.weChatPayScheme = @"wx7163dbd76eac21a9";
 self.QQID = @"申请的QQID";
 self.weiboID = @"申请的微博ID";
 }
 return self;
 }
 ```
 最后在你需要支付的地方调用MUEPaymentManager的类方法直接请求数据，而无需在APPdelegate写任何代码
  ```
    [MUEPaymentManager muEPaymentManagerWithAliPay:privateKey result:^(NSDictionary *resultDict) {
    
    }];
    
    [MUEPaymentManager muEPaymentManagerWithWeChatPay:^(PayReq *req) {
    } result:^(PayResp *rseq) {
    
    }];
    
```

   ![image](https://github.com/jeykit/MUKit/blob/master/Example/MUKit/Gif/payment.gif )
  
  ***
 ### MUShared
 继承MULoadingModel类进行如下初始化后，直接MUSharedManager的类方法就可以直接分享到微信好友，朋友圈，QQ好友、QQ空间，微博无需在APPdelegate写任何代码

 ###
具体参考例子中的signal文件
### MUPopupController
具体效果参考[STPopup](https://github.com/Jeykit/STPopup)，唯一的区别是添加了一个可以与其它controller交互的resultBlock以及在文本编辑模式下调整MUPopupController的偏移高度
### MUCarouselView
具体效果参考[SPCarouselView](https://github.com/SPStore/SPCarouselView)，区别是增加了竖直方向滚动和文字轮播效果
### MUAdaptiveView
上传图片的一个常用效果
# 具体的效果和使用方式建议大家下载demo参考
## Author
Jeykit, 392071745@qq.com
## Requirements

## License

MUKit is available under the MIT license. See the LICENSE file for more info.
