# MUKit

[![CI Status](http://img.shields.io/travis/Jeykit/MUKit.svg?style=flat)](https://travis-ci.org/Jeykit/MUKit)
[![Version](https://img.shields.io/cocoapods/v/MUKit.svg?style=flat)](http://cocoapods.org/pods/MUKit)
[![License](https://img.shields.io/cocoapods/l/MUKit.svg?style=flat)](http://cocoapods.org/pods/MUKit)
[![Platform](https://img.shields.io/cocoapods/p/MUKit.svg?style=flat)](http://cocoapods.org/pods/MUKit)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.
### 提示
```   MUKit1 1.1.3版本更新；修复signal可能存在的内存泄漏、划分子版本供大家按需下载
    Signal(事件信号):pod 'MUKit/Signal' 
    Payment(支付宝和微信):pod 'MUKit/EPaymentManager'
    Shared(QQ、微信、微博、朋友圈、QQ空间):pod 'MUKit/Shared'
    Navigation(简单易用的导航):pod 'MUKit/Navigation'
    Carousel(轻量化的轮播图):pod 'MUKit/Carousel'
    Encryption(数据加密，支持RSA\DES\AES256):pod 'MUKit/Encryption'
    MUTableViewManager(tableview的MVVM化):pod 'MUKit/TableViewManager'
    MUCollectionViewManage(collectionView的MVVM化)r:pod 'MUKit/CollectionViewManager'
    MUPopupController(简单易用，功能强大的弹框):pod 'MUKit/PopupController'
    MUPaperView(页面切换控件):pod 'MUKit/PaperView'
    ..........
```
### MUKit.h
MUKit.h除了包含框架的大部分头文件，还包含大量提高效率的宏。如判断系统版本、加载本地图片、转字符串、实例化一个类、iPhone型号、版本号等
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
 ### MUNavigation
    对UINavigation的轻度封装，可以设置全局UINavigationBar样式，也可以在需要更改UINavigationBar样式的controller实现自己想要的样式
    全局设置
![image](https://github.com/jeykit/MUKit/blob/master/Example/MUKit/Gif/all.png)

    局部设置
    如果当前控制器有自己的样式，则使用当前控制器的样式，否则使用全局设置
![image](https://github.com/jeykit/MUKit/blob/master/Example/MUKit/Gif/single.png)
    
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

## Installation

MUKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "MUKit"
```

## Author

Jeykit, 392071745@qq.com

## License

MUKit is available under the MIT license. See the LICENSE file for more info.
