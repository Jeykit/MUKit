TencentOpenApiSDK
=================

[Tencent Open Api SDK](http://wiki.open.qq.com/wiki/mobile/SDK%E4%B8%8B%E8%BD%BD)

### Install

使用 [Cocoapods-depend](https://github.com/candyan/cocoapods-depend) 插件

``` pod depend add TencentOpenApiSDK ```

或者在 `Podfile` 文件下添加

``` pod 'TencentOpenApiSDK' ```

由于不太经常关注更新，如果发现有新版更新欢迎PR。Thx

### Basic 和 64Bit(full version) 的差别

- 完整版包含 QQ Api、腾讯业务 Api、Tencent OAuth 接口 和 腾讯微博接口；而 Basic 版只包含 QQ Api 和 Tencent OAuth 接口。
- 完整版包含一个 bundle 资源包，而 Basic 版 不包含任何资源文件。


###Changelog

#### 2.9.5 (2015-12-16)

- 关闭以下功能: 第三方APP直接上传图片和视频到空间，分享的图片支持在动态直接展示，视频支持动态里直接播放

####2.9.3 (2015-11-03)

- 支持第三方 APP 直接上传图片和视频到空间，分享的图片支持在动态直接展示，视频支持动态里直接播放
- 修改分享流程，启用 Webview 权限的 app 只有在无安装 手Q 或者 手Q 版本过旧才会启用 H5 页面分享
- 修改一些bug（qq 空间分享时打开外部浏览器问题、模拟器里 H5 登陆页面空白问题、分享 H5 页面空白问题等）
- (only 64bit subspec)`TencentOpenApi_IOS_Bundle.bundle` 去除 `info.plist`、SDK 增加版本号标记