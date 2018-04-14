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
  s.version          = '1.0.0'
  s.summary          = '提高iOS开发效率的工具'
  s.description      = <<-DESC
fix signal ,MVVMTableView,Waterfall,Shared,Carousel,MUPayment,QRCodeScan,MUPaperView,MUNavigation
                       DESC


  s.homepage         = 'https://github.com/Jeykit/MUKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Jeykit' => '392071745@qq.com' }
  s.source           = { :git => 'https://github.com/Jeykit/MUKit.git', :tag => 'v1.0.0git' }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  #s.ios.deployment_target = '8.0'

#s.source_files = 'MUKit/Classes/**/*'
  s.source_files = 'MUKit/Classes/MUKit.h'
  s.public_header_files = 'MUKit/Classes/MUKit.h'
  s.ios.deployment_target = '8.0'
  #s.platform     = :ios, '8.0'    #支持的系统

s.subspec 'MUSignal' do |ss|
    ss.source_files = 'MUKit/Classes/MUSignal/{UIView+MUSignal,UIViewController+MUDecription,MUSignal}.{h,m}'
    ss.public_header_files = 'MUKit/Classes/MUSignal/MUSignal.h'
end
s.subspec 'MUCarousel' do |ss|
    ss.source_files = 'MUKit/Classes/Carousel/MUCarouselView.{h,m}'
    ss.dependency 'SDWebImage'
end
s.subspec 'MUAdaptiveView' do |ss|
    ss.source_files = 'MUKit/Classes/MUAdaptiveView/*.{h,m}'
    ss.dependency 'SDWebImage'
end
s.subspec 'MUNavigation' do |ss|
    ss.source_files = 'MUKit/Classes/{MUNavigationController,UIImage,UIColor,Public,MUNormal}/*.{h,m}'
    ss.dependency 'YYModel'
end
s.subspec 'MUNormal' do |ss|
    ss.source_files = 'MUKit/Classes/MUNormal/*.{h,m}'
end
s.subspec 'MUPaperView' do |ss|
    ss.source_files = 'MUKit/Classes/{MUPaperView,MUSignal,MUNormal}/*.{h,m}'
end
s.subspec 'MUEPaymentManager' do |ss|
    ss.source_files = 'MUKit/Classes/{MUPayment,Public,MUShared}/*.{h,m}'
    ss.dependency 'AliPay'
    ss.dependency 'WeChat_SDK'
    ss.dependency 'WeiboSDK'
    ss.dependency 'TencentOpenApiSDK'
end
s.subspec 'MUPopupController' do |ss|
    ss.source_files = 'MUKit/Classes/{MUPopupController,Public}/*.{h,m}'
    ss.public_header_files = 'MUKit/Classes/MUPopupController/{MUPopup,MUPopupController,UIViewController+MUPopup}.h'
end
s.subspec 'MUShared' do |ss|
    ss.source_files = 'MUKit/Classes/MUShared/MUShared{Manager,Object}.{h,m}'
    ss.dependency 'AliPay'
    ss.dependency 'WeChat_SDK'
    ss.dependency 'WeiboSDK'
    ss.dependency 'TencentOpenApiSDK'
end
s.subspec 'MUTableViewManager' do |ss|
    ss.source_files = 'MUKit/Classes/{MUTableViewManager,MUTipsView,Public,Refresh,MUNormal,MUSignal,MUNavigationController,UIColor,UIImage}/*.{h,m}'
   ss.dependency 'YYModel'
end
s.subspec 'MUCollectionViewManager' do |ss|
    ss.source_files = 'MUKit/Classes/{MUCollectionViewManager,MUTipsView,Public,Refresh,MUNormal,MUNavigationController,MUSignal,UIImage,UIColor}/*.{h,m}'
         ss.dependency 'YYModel'
end

s.subspec 'MUTipsView' do |ss|
    ss.source_files = 'MUKit/Classes/MUTipsView/MUTipsView.{h,m}'
end
s.subspec 'MUPublic' do |ss|
    ss.source_files = 'MUKit/Classes/Public/*.{h,m}'
end
s.subspec 'MURefresh' do |ss|
    ss.source_files = 'MUKit/Classes/{Refresh,Public}/*{MUHookMethodHelper,MURefreshComponent,MURefreshFooterComponent,MURefreshHeaderComponent}.{h,m}'
end
s.subspec 'MUQRCodeScanTool' do |ss|
    ss.source_files = 'MUKit/Classes/{QRCodeScan,Public}/{MUQRCodeScanTool,MUHookMethodHelper}.{h,m}'
end
s.subspec 'MUUIImage' do |ss|
    ss.source_files = 'MUKit/Classes/UIImage/*.{h,m}'
end
s.subspec 'MUUIColor' do |ss|
    ss.source_files = 'MUKit/Classes/UIColor/*.{h,m}'
end

end
