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

## Author
Jeykit, 392071745@qq.com



## MUKit原理介绍和讲解

### 提示
```   MUKit1 1.1.9版本更新；
    MUNetworking                             pod 'MUKit/Networking' 
    MUNavigation                             pod 'MUKit/Navigation'
    MUSignal                                 pod 'MUKit/Signal' 
    MUEPaymentManager                        pod 'MUKit/EPaymentManager'
    MUShared                                 pod 'MUKit/Shared'
    MUCarousel                               pod 'MUKit/Carousel'
    MUEncryption                             pod 'MUKit/Encryption'
    MUTableViewManager                       pod 'MUKit/TableViewManager'
    MUCollectionViewManager                  pod 'MUKit/CollectionViewManager'
    MUPopupController                        pod 'MUKit/PopupController'
    MUPaperView                              pod 'MUKit/PaperView'
    详细注释和案例稍后逐步更新.......
```
### MUKit.h
MUKit.h除了包含框架的大部分头文件，还包含大量提高效率的宏。如判断系统版本、加载本地图片、转字符串、实例化一个类、iPhone型号、版本号等
### MUNetworking 网络框架原理(与其它框架的区别)
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
![image](https://github.com/jeykit/MUKit/blob/master/Example/MUKit/Gif/MUNetworking.gif)
### MUNavigation 轻量 简单 易用 的导航框架
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
具体用法请参考源码中的MUNavigation(导航框架案例)
![image](https://github.com/jeykit/MUKit/blob/master/Example/MUKit/Gif/MUNavigation.gif)
___
### Signal
    传统的事件实现方式:
    UIButton *button = [UIButton new];
    [button addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    Signal的事件实现方式：
     在需要实现响应事件的view或者controller实现Click_MUSignal(signalName)方法即可,例如
     Click_MUSignal(signalName){//signalName是控件的属性名
    
     }
    Signal priority:view(控件所在的view)>cell(控件所在的UITableViewCell或者UICollectionViewCell)>controller(控件属于的控制器)
    
   ![image](https://github.com/jeykit/MUKit/blob/master/Example/MUKit/Gif/signal.gif )
   ***

 ### MUTableViewManager
 tableview的MVVM封装,在正确设置autolayout可以自动计算行高和自动缓存行高而无需任何设置。可以节省大量的代理方法代码。
    @“result”为模型的关键字，tableViewManger会自动拆解模型,可在renderBlock返回自定义的cell、高度；如果你没有指定高度，会自动计算高度并缓存
   ``` self.tableViewManger = [[MUTableViewManager alloc]initWithTableView:self.tableView registerCellNib:NSStringFromClass([MUKitDemoTableViewCell class]) subKeyPath:@“result”];
    self.tableViewManger.renderBlock = ^UITableViewCell *(UITableViewCell *cell, NSIndexPath *indexPath, id model, CGFloat *height) {
    cell.textLabel.text = [NSString stringWithFormat:@"%@",model];
    return cell;
    };
    self.tableViewManger.selectedCellBlock = ^(UITableView *  tableView, NSIndexPath *  indexPath, id  model, CGFloat *  height) {
    }
 ```
 可以返回nil或者自定义的view。可动态设置每一个header的高度和标题。默认为44point，这个高度并不会被缓存
 ```self.tableViewManger.headerViewBlock = ^UIView * (UITableView *  tableView, NSUInteger sections, NSString *__autoreleasing   *  title, id   model, CGFloat *  height) {
 *title  = @"Demo";
 
 return nil;
 };
 self.tableViewManger.footerViewBlock = ^UIView *(UITableView *tableView, NSUInteger sections, NSString *__autoreleasing *title, id model, CGFloat *height) {
 
 *title = @"我想写就写";
 return nil;
 };
 ```
    
 ***
 ### MUPayment
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
## Requirements

## License

MUKit is available under the MIT license. See the LICENSE file for more info.
