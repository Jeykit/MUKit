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
#import "MUPopup.h"
#import "MUPaperView.h"

#define weakify( x )  __weak __typeof__(x) __weak_##x##__ = x;
#define normalize( x ) __typeof__(x) x = __weak_##x##__;

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenBounds [UIScreen mainScreen].bounds

#endif /* MUKit_h */
