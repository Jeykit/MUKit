//
//  MUAssetCell.h
//  MUKit_Example
//
//  Created by Jekity on 2017/11/7.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MUVideoIndicatorView.h"
#import "MUOverlayView.h"

@interface MUAssetCell : UICollectionViewCell
@property(nonatomic, strong)UIImageView *imageView;
@property(nonatomic, strong)MUOverlayView *overlayView;
@property(nonatomic, strong)MUVideoIndicatorView *videoIndicatorView;
@property(nonatomic, assign ,getter=isPicked)BOOL picked;
@property(nonatomic, strong)UIColor *tintColor;
@end
