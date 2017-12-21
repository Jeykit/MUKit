//
//  MUAdaptiveViewCell.h
//  MUKit
//
//  Created by Jekity on 2017/12/20.
//

#import <UIKit/UIKit.h>

@interface MUAdaptiveViewCell : UICollectionViewCell
@property(nonatomic, strong)UIImage *image;
@property(nonatomic, copy)void (^(deleteButtonByClicled))(NSUInteger flag);
@property(nonatomic, strong)UIColor *tintColorMu;
@property(nonatomic, assign)CGFloat cornerRadiusMu;
@property(nonatomic, assign)BOOL hideButton;
@end
