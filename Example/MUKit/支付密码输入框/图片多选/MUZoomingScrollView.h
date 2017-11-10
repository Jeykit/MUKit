//
//  MUZoomingScrollView.h
//  MUKit_Example
//
//  Created by Jekity on 2017/11/10.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MUTapDetectingView.h"
#import "MUTapDetectingImageView.h"

@interface MUZoomingScrollView : UIScrollView<UIScrollViewDelegate, MUTapDetectingImageViewDelegate, MUTapDetectingViewDelegate>
@property(nonatomic, strong)UIImage *image;
@end
