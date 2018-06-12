//
//  MUCheckbox.h
//  MUKit_Example
//
//  Created by Jekity on 2018/6/5.
//  Copyright © 2018年 Jeykit. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger ,MUCheckmarkStyle){
    /// ■
    MUCheckmarkStyleSquare            = 1,
    /// ●
    MUCheckmarkStyleCircle,
    /// ╳
    MUCheckmarkStyleCross,
     /// ✓
    MUCheckmarkStyleTick
};
typedef NS_ENUM(NSUInteger ,MUBorderStyle){
    /// ▢
    MUBorderStyleSquare            = 1,
    /// ◯
    MUBorderStyleCircle,

};
API_AVAILABLE(ios(10.0))
@interface MUCheckbox : UIControl


/// Shape of the center checkmark that appears when `Checkbox.isChecked == true`.
///
/// **Default:** `CheckmarkStyle.square`
@property (nonatomic,assign) MUCheckmarkStyle checkmarkStyle ;


/// Shape of the outside border containing the checkmarks contents.
///
/// Used as a visual indication of where the user can tap.
///
/// **Default:** `BorderStyle.square`
@property (nonatomic,assign) MUBorderStyle borderStyle;


/// Width of the borders stroke.
///
/// **NOTE**
///
/// Diagonal/rounded lines tend to appear thicker, so border styles
/// that use these (.circle) have had their border widths halved to compensate
/// in order appear similar next to other border styles.
///
/// **Default:** `1`
@property (nonatomic,assign) CGFloat borderWidth;


/// Size of the center checkmark element.
///
/// Drawn as a percentage of the size of the Checkbox's draw rect.
///
/// **Default:** `0.5`
@property (nonatomic,assign) CGFloat checkmarkSize;


 /// **Default:** The current tintColor.
@property (nonatomic,strong)IBInspectable UIColor *uncheckedBorderColor;
@property (nonatomic,strong)IBInspectable UIColor *checkedBorderColor;

/// **Default:** The current tintColor.
@property (nonatomic,strong)IBInspectable UIColor *checkmarkColor;

   /// **Default:** White.
@property (nonatomic,strong) UIColor *checkboxBackgroundColor;


/// Increases the controls touch area.
///
/// Checkbox's tend to be smaller than regular UIButton elements
/// and in some cases making them difficult to interact with.
/// This property helps with that.
///
/// **Default:** `5`
@property (nonatomic,assign) CGFloat increasedTouchRadius;


/// Indicates whether the checkbox is currently in a state of being
/// checked or not.
@property (nonatomic,assign) IBInspectable BOOL isChecked;

@property (nonatomic,assign) BOOL useHapticFeedback;

@property (nonatomic,strong) UIImpactFeedbackGenerator *feedbackGenerator;

@property (nonatomic,copy) void (^valueChanged)(BOOL isChecked);
@end
