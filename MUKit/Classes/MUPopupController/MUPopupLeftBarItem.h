//
//  MUPopupLeftBarItem.h
//  Pods
//
//  Created by Jekity on 2017/10/10.
//
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, MUPopupLeftBarItemType) {
    MUPopupLeftBarItemCross,
    MUPopupLeftBarItemArrow
};

@interface MUPopupLeftBarItem : UIBarButtonItem

@property (nonatomic, assign) MUPopupLeftBarItemType type;
- (instancetype)initWithTarget:(id)target action:(SEL)action;
- (void)setType:(MUPopupLeftBarItemType)type animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
