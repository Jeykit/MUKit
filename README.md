# MUKit

[![CI Status](http://img.shields.io/travis/Jeykit/MUKit.svg?style=flat)](https://travis-ci.org/Jeykit/MUKit)
[![Version](https://img.shields.io/cocoapods/v/MUKit.svg?style=flat)](http://cocoapods.org/pods/MUKit)
[![License](https://img.shields.io/cocoapods/l/MUKit.svg?style=flat)](http://cocoapods.org/pods/MUKit)
[![Platform](https://img.shields.io/cocoapods/p/MUKit.svg?style=flat)](http://cocoapods.org/pods/MUKit)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.
### Signal
    传统的事件实现方式:
    UIButton *button = [UIButton new];
    [button addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    Signal的事件实现方式：
     在需要实现响应事件的view或者controller实现Click_MUSignal(signalName)方法即可,例如
     Click_MUSignal(signalName){//signalName是控件的属性名
    
     }
    Signal priority:view(控件所在的view)>cell(控件所在的UITableViewCell或者UICollectionViewCell)>controller(控件属于的控制器)
    ![image](https://github.com/jeykit/MUKit/blob/master/GIFName.gif )
   ***
 ### MUTableViewManager
 tableview的MVVM封装,在正确设置autolayout可以自动计算行高和自动缓存行高而无需任何设置。可以节省大量的代理方法代码。
 ### MUNavigation
 对UINavigation的轻度封装，可以设置全局UINavigationBar样式，也可以在需要更改UINavigationBar样式的controller实现自己想要的样式
 ### MUPayment
 封装了Alipay和WeChatPay，只需添加对应的黑白名单以及模式名称和继承MULoadingModel类进行如下初始化
 -(instancetype)init{

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
 最后在你需要支付的地方调用MUEPaymentManager的类方法直接请求数据，而无需在APPdelegate写任何代码
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
