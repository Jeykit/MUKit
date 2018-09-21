//
//  MUSegmentPaperView.h
//  ZPApp
//
//  Created by Jekity on 2018/9/18.
//  Copyright © 2018年 Jekity. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MUSegmentPaperView : UIControl

- (instancetype)initWithFrame:(CGRect)frame withSegments:(NSArray *)segments withView:(NSArray *)objects;
@end

NS_ASSUME_NONNULL_END
