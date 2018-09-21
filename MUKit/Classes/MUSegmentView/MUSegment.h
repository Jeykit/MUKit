//
//  MUSegment.h
//  ZPApp
//
//  Created by Jekity on 2018/9/18.
//  Copyright © 2018年 Jekity. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@class MUSegmentAppearance;
@interface MUSegment : UIView

-(instancetype)initWithAppearance:(MUSegmentAppearance *)appearance;

@property (nonatomic,copy) void (^(didSelectSegment))(MUSegment *segment);

@property (nonatomic,assign, getter=isSelected) BOOL selected;
@end

NS_ASSUME_NONNULL_END
