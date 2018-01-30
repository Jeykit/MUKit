//
//  MUKit.h
//  Pods
//
//  Created by Jekity on 2017/10/17.
//
//

#ifndef MUKit_h
#define MUKit_h

#import "MUSignal.h"
#import "MUNavigation.h"
#import "MUEPaymentManager.h"
#import "MUCollectionViewManager.h"
#import "MUTableViewManager.h"
#import "UIColor+MUColor.h"
#import "UIImage+MUColor.h"
#import "MUPopup.h"
#import "UIView+MUNormal.h"
#import "MUCarouselView.h"
#import "MUQRCodeScanTool.h"
#import "MUSharedManager.h"
#import "MUPaperView.h"

#define weakify( x )  __weak __typeof__(x) __weak_##x##__ = x;
#define normalize( x ) __typeof__(x) x = __weak_##x##__;

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenBounds [UIScreen mainScreen].bounds

//判断是否 Retina屏、设备是否iPhone 5、是否是iPad
#define isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

/** 判断是否为iPhone */
#define isiPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

/** 判断是否是iPad */
#define isiPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

/** 判断是否为iPod */
#define isiPod ([[[UIDevice currentDevice] model] isEqualToString:@"iPod touch"])

/** 设备是否为iPhone 4/4S 分辨率320x480，像素640x960，@2x */
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

/** 设备是否为iPhone 5C/5/5S 分辨率320x568，像素640x1136，@2x */
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

/** 设备是否为iPhone 6 分辨率375x667，像素750x1334，@2x */
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

/** 设备是否为iPhone 6 Plus 分辨率414x736，像素1242x2208，@3x */
#define iPhone6P ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

/** 设备是否为iPhone X 分辨率373x812，像素1125x2436，@3x */
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

/** 应用商店版本号 */
#define APP_SHORT_VERSION               [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
/** 应用构建版本号 */
#define APP_BUNDLE_VERSION              [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
/** 应用商店和构建版本号 */
#define APP_VERSION                     [NSString stringWithFormat:@"%@ (%@)", APP_SHORT_VERSION, APP_BUNDLE_VERSION]
/** 应用标识 */
#define APP_BUNDLE_IDENTIFIER           [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]

//----------------------ABOUT IMAGE 图片 ----------------------------

//LOAD LOCAL IMAGE FILE     读取本地图片
#define LOADIMAGE(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:ext]]
//DEFINE IMAGE      定义UIImage对象//    imgView.image = IMAGE(@"Default.png");
#define IMAGE(A) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:A ofType:nil]]
//DEFINE IMAGE      定义UIImage对象
#define ImageNamed(_pointer) [UIImage imageNamed:[UIUtil imageName:_pointer]]
#endif /* MUKit_h */
