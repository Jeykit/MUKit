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
# 在podfile文件中加入inhibit_all_warnings!可以消除pod库警告
Pod::Spec.new do |s|
  s.name             = 'MUKit'
  s.version          = '2.1.4'
  s.summary          = 'UITableView、UICollectionView、Signal、UINavigation、AliPay、weChatPay、Shared、Popup、Networking，runtime、Carousel、QRCode,Block,ScrollView、嵌套滚动 、MVVM、delegate、Refresh、route、路由、CheckBox、popupView 一款提高iOS开发效率的工具包MUKit'
  s.description      = <<-DESC
一款提高iOS开发效率的组件框架，涉及UITableView、UICollectionView、Signal、UINavigation、AliPay、weChatPay、Shared、Popup、Networking，runtime、Carousel、QRCode,Block,ScrollView、嵌套滚动 、MVVM、delegate、Refresh内容
                       DESC


  s.homepage         = 'https://github.com/Jeykit/MUKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Jeykit' => '392071745@qq.com' }
  s.source           = { :git => 'https://github.com/Jeykit/MUKit.git', :tag => s.version }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  #s.ios.deployment_target = '8.0'

#s.source_files = 'MUKit/Classes/**/*'
  s.source_files = 'MUKit/Classes/MUKit.h'
  s.public_header_files = 'MUKit/Classes/MUKit.h'
  s.ios.deployment_target = '8.0'
  s.library = 'c++'
  s.platform     = :ios, '8.0'    #支持的系统
  
s.subspec 'Normal' do |ss|
    ss.source_files = 'MUKit/Classes/MUNormal/*.{h,m}'
    ss.public_header_files = 'MUKit/Classes/MUNormal/UIView+MUNormal.h'
end
s.subspec 'TipsView' do |ss|
    ss.source_files = 'MUKit/Classes/MUTipsView/*.{h,m}'
end
s.subspec 'Public' do |ss|
    ss.source_files = 'MUKit/Classes/Public/*.{h,m}'
end
s.subspec 'Image' do |ss|
    ss.source_files = 'MUKit/Classes/UIImage/*.{h,m}'
end
s.subspec 'Color' do |ss|
    ss.source_files = 'MUKit/Classes/UIColor/*.{h,m}'
end
s.subspec 'Refresh' do |ss|
    ss.source_files = 'MUKit/Classes/Refresh/*.{h,m}'
    ss.dependency 'MUKit/Normal'
end
s.subspec 'Signal' do |ss|
    ss.source_files = 'MUKit/Classes/MUSignal/*.{h,m}'
    ss.public_header_files = 'MUKit/Classes/MUSignal/{MUSignal,UIView+MUSignal}.h'
end
s.subspec 'Carousel' do |ss|
    ss.source_files = 'MUKit/Classes/Carousel/MUCarouselView.{h,m}'
    ss.public_header_files = 'MUKit/Classes/Carousel/MUCarouselView.h'
end
s.subspec 'AdaptiveView' do |ss|
    ss.source_files = 'MUKit/Classes/MUAdaptiveView/*.{h,m}'
    ss.public_header_files = 'MUKit/Classes/MUAdaptiveView/MUAdaptiveView.h'
end
s.subspec 'Navigation' do |ss|
    ss.source_files = 'MUKit/Classes/MUNavigationController/*.{h,m}'
    ss.public_header_files = 'MUKit/Classes/MUNavigationController/{MUNavigation,MUNavigationController}.h'
end
s.subspec 'TableViewManager' do |ss|
    ss.source_files = 'MUKit/Classes/MUTableViewManager/*.{h,m}'
    ss.dependency 'MUKit/TipsView'
    ss.dependency 'MUKit/Refresh'
    ss.dependency 'MUKit/Public'
end
s.subspec 'PaperView' do |ss|
    ss.source_files = 'MUKit/Classes/MUPaperView/*.{h,m}'
    ss.public_header_files = 'MUKit/Classes/MUPaperView/MUPaperView.h'
end
s.subspec 'Shared' do |ss|
    ss.source_files = 'MUKit/Classes/MUShared/*.{h,m}'
    ss.public_header_files = 'MUKit/Classes/MUShared/MUShared{Manager,Object}.h'
    #ss.dependency 'AliPay'
    ss.dependency 'WechatOpenSDK'
    ss.dependency 'WeiboSDK'
    ss.dependency 'TencentOpenApiSDK'
    ss.dependency 'MUKit/Public'
end
s.subspec 'EPaymentManager' do |ss|
    ss.source_files = 'MUKit/Classes/MUEPaymentManager/*.{h,m}'
    ss.public_header_files = 'MUKit/Classes/MUEPaymentManager/MUEPaymentManager.h'
    ss.dependency 'MUKit/Public'
    ss.dependency 'Alipay_SDK_iOS'
    #ss.dependency 'AliPay'
    ss.dependency 'WechatOpenSDK'
end
s.subspec 'PopupController' do |ss|
    ss.source_files = 'MUKit/Classes/MUPopupController/*.{h,m}'
    ss.public_header_files = 'MUKit/Classes/MUPopupController/{MUPopup,MUPopupController,UIViewController+MUPopup}.h'
    ss.dependency 'MUKit/Public'
end
s.subspec 'Encryption' do |ss|
    ss.source_files = 'MUKit/Classes/{MUEncryption,MUKeychainUtil}/*.{h,m}'
    ss.public_header_files = 'MUKit/Classes/MUEncryption/{MUEncryptionUtil,MUKeychainUtil}.h'
    ss.frameworks = 'Security'
end
s.subspec 'CollectionViewManager' do |ss|
    ss.source_files = 'MUKit/Classes/MUCollectionViewManager/*.{h,m}'
    ss.dependency 'YYModel'
    ss.dependency 'MUKit/TipsView'
    ss.dependency 'MUKit/Refresh'
    ss.dependency 'MUKit/Public'
end
s.subspec 'QRCodeManager' do |ss|
    ss.source_files = 'MUKit/Classes/QRCodeScan/{MUQRCodeManager,MU_Scan_Success}.{h,m,wav}'
end
s.subspec 'Networking' do |ss|
    ss.source_files = 'MUKit/Classes/Networking/*.{h,m}'
    ss.dependency 'YYModel'
    ss.dependency 'AFNetworking'
end
s.subspec 'ScrollManager' do |ss|
    ss.source_files = 'MUKit/Classes/MUScrollManager/*.{h,m}'
    ss.dependency 'MUKit/Public'
end
s.subspec 'Checkbox' do |ss|
    ss.source_files = 'MUKit/Classes/Checkbox/*.{h,m}'
    ss.public_header_files = 'MUKit/Classes/Checkbox/MUCheckbox.h'
end

s.subspec 'popupView' do |ss|
    ss.source_files = 'MUKit/Classes/MUPopupView/*.{h,m}'
    ss.public_header_files = 'MUKit/Classes/MUPopupView/MUPopupView.h'
end
s.subspec 'ImagePickerManager' do |ss|
    ss.source_files = 'MUKit/Classes/MUImagePickerManager/*.{h,m}'
    ss.public_header_files = 'MUKit/Classes/MUImagePickerManager/MUImagePickerManager.h'
    ss.dependency 'MUKit/PhotoPreview'
end
s.subspec 'PhotoPreview' do |ss|
    ss.source_files = 'MUKit/Classes/MUPhotoPreview/*.{h,m}'
    ss.public_header_files = 'MUKit/Classes/MUPhotoPreview/MUPhotoPreviewController.h'
end
s.subspec 'ImageCache' do |ss|
    ss.source_files = 'MUKit/Classes/ImageCache/*.{h,m}'
    ss.public_header_files = 'MUKit/Classes/ImageCache/*.h'
end
s.subspec 'Tag' do |ss|
    ss.source_files = 'MUKit/Classes/Tag/*.{h,m}'
    ss.public_header_files = 'MUKit/Classes/Tag/MUTagView.h'
end

s.subspec 'Levitate' do |ss|
    ss.source_files = 'MUKit/Classes/Levitate/*.{h,m}'
    ss.public_header_files = 'MUKit/Classes/Levitate/MULevitateView.h'
end

s.subspec 'MUTextKit' do |ss|
    ss.source_files = 'MUKit/Classes/MUTextKit/*.{h,m,mm}'
    ss.public_header_files = 'MUKit/Classes/MUTextKit/{MUTextKitNode}.h'
end
s.subspec 'MUSegmentView' do |ss|
    ss.source_files = 'MUKit/Classes/MUSegmentView/*.{h,m,mm}'
    ss.public_header_files = 'MUKit/Classes/MUSegmentView/*.h'
end

s.subspec 'MULaunchImageAD' do |ss|
    ss.source_files = 'MUKit/Classes/MULaunchImageAD/*.{h,m}'
    ss.public_header_files = 'MUKit/Classes/MULaunchImageAD/*.h'
    ss.dependency 'MUKit/Carousel'
end
end
