//
//  UIViewController+MUPopup.h
//  Pods
//
//  Created by Jekity on 2017/10/10.
//
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MUPopupController;
@interface UIViewController (MUPopup)
/**
 Content size of popup in portrait orientation.
 */
@property (nonatomic, assign) IBInspectable CGSize contentSizeInPopup;

/**
 Content size of popup in landscape orientation.
 */
@property (nonatomic, assign) IBInspectable CGSize landscapeContentSizeInPopup;

/**
 Popup controller which is containing the view controller.
 Will be nil if the view controller is not contained in any popup controller.
 */
@property (nullable, nonatomic, weak, readonly) MUPopupController *popupController;
@end
NS_ASSUME_NONNULL_END
