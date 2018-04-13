#
# Be sure to run `pod lib lint MUKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
# 先修改podspec文件，然后pod spec lint/pod lib lint验证通过后再git打标签，否则容易出错
# pod lib lint --allow-warnings --use-libraries
# 包含第三方库时使用pod repo push MUKit MUKit.podspec --allow-warnings --use-libraries验证
# 注册pod trunk register 392071745@qq.com 'Jekity' --verbose
# 发布到cocoapods pod trunk push MUKit.podspec --use-libraries --allow-warnings
Pod::Spec.new do |s|
  s.name             = 'MUKit'
  s.version          = '0.5.4'
  s.summary          = '提高iOS开发效率的工具'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
fix signal ,MVVMTableView,Waterfall,Shared,Carousel,MUPayment,QRCodeScan,MUPaperView,MUNavigation
                       DESC


  s.homepage         = 'https://github.com/Jeykit/MUKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Jeykit' => '392071745@qq.com' }
  s.source           = { :git => 'https://github.com/Jeykit/MUKit.git', :tag => 'v0.5.4' }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  #s.ios.deployment_target = '8.0'

# s.source_files = 'MUKit/Classes/**/*'
  s.source_files = 'MUKit/MUKit.h'
  s.ios.deployment_target = '8.0'
  #s.platform     = :ios, '8.0'    #支持的系统

s.subspec 'MUSignal' do |ss|
    ss.source_files = 'MUKit/MUSignal/{UIView+MUSignal,UIViewController+MUDecription}.{h,m}'
    ss.public_header_files = 'MUKit/MUSignal/MUSignal.h'
end
s.subspec 'MUCarousel' do |ss|
    ss.source_files = 'MUKit/Carousel/MUCarouselView.{h,m}'
    ss.dependency 'SDWebImage'
end
s.subspec 'MUAdaptiveView' do |ss|
    ss.source_files = 'MUKit/MUAdaptiveView/{MUAdaptiveView,MUAdaptiveViewCell}.{h,m}'
end
s.subspec 'MUNavigation' do |ss|
    ss.source_files = 'MUKit/MUNavigationController/MUNavigation.{h,m}'
    ss.dependency 'YYModel'
end
s.subspec 'MUNormal' do |ss|
    ss.source_files = 'MUKit/MUNormal/UIView+MUNormal.{h,m}'
end
s.subspec 'MUPaperView' do |ss|
    ss.source_files = 'MUKit/MUPaperView/MUPaper{View,BaseView}.{h,m}'
end
s.subspec 'MUEPaymentManager' do |ss|
    ss.source_files = 'MUKit/MUPayment/MUE{AliPayModel,PaymentManager,WeChatPayModel}.{h,m}'
    ss.dependency 'AliPay'
    ss.dependency 'WeChat_SDK'
end
s.subspec 'MUPopupController' do |ss|
    ss.source_files = 'MUKit/MUPopupController/MUPopup{Controller,ControllerTransitioningFade,ControllerTransitioningSlideVertical,LeftBarItem,NavigationBar,UIViewController+}.{h,m}'
    ss.public_header_files = 'MUKit/MUPopupController/MUPopup.h'
end
s.subspec 'MUShared' do |ss|
    ss.source_files = 'MUKit/MUShared/MUShared{Manager,Object}.{h,m}'
    ss.dependency 'AliPay'
    ss.dependency 'WeChat_SDK'
    ss.dependency 'WeiboSDK'
    ss.dependency 'TencentOpenApiSDK'
end
s.subspec 'MUTableViewManager' do |ss|
    ss.source_files = 'MUKit/MUTableViewManager/MUTableViewManager.{h,m}'
    ss.public_header_files = 'MUKit/MUTipsView/MUTipsView.{h,m}'
end
s.subspec 'MUTableViewManager' do |ss|
    ss.source_files = 'MUKit/MUTableViewManager/MUTableViewManager.{h,m}'
    #ss.public_header_files = 'MUKit/MUTipsView/MUTipsView.{h,m}'
end
s.subspec 'MUCollectionViewManager' do |ss|
    ss.source_files = 'MUKit/MUCollectionViewManager/.{h,m}'
    #ss.public_header_files = 'MUKit/MUTipsView/MUTipsView.{h,m}'
end

s.subspec 'MUTipsView' do |ss|
    ss.source_files = 'MUKit/MUTipsView/.{h,m}'
    ss.public_header_files = 'MUKit/MUTipsView/MUTipsView.{h,m}'
end
s.subspec 'MUPublic' do |ss|
    ss.source_files = 'MUKit/Public/.{h,m}'
    #ss.public_header_files = 'MUKit/MUTipsView/MUTipsView.{h,m}'
end
s.subspec 'MURefresh' do |ss|
    ss.source_files = 'MUKit/Refresh/.{h,m}'
    #ss.public_header_files = 'MUKit/MUTipsView/MUTipsView.{h,m}'
end
s.subspec 'MUQRCodeScanTool' do |ss|
    ss.source_files = 'MUKit/QRCodeScan/.{h,m}'
    #ss.public_header_files = 'MUKit/MUTipsView/MUTipsView.{h,m}'
end
s.subspec 'MUUIImage' do |ss|
    ss.source_files = 'MUKit/UIImage/.{h,m}'
    #ss.public_header_files = 'MUKit/MUTipsView/MUTipsView.{h,m}'
end
s.subspec 'MUUIColor' do |ss|
    ss.source_files = 'MUKit/UIColor/.{h,m}'
    #ss.public_header_files = 'MUKit/MUTipsView/MUTipsView.{h,m}'
end
#s.dependency 'AliPay'
#s.dependency 'WeChat_SDK'
#s.dependency 'YYModel'
  # s.dependency 'SDWebImage'
  #s.dependency 'WeiboSDK'
  #s.dependency 'TencentOpenApiSDK'

end
