//
//  MUSegmentAppearance.m
//  ZPApp
//
//  Created by Jekity on 2018/9/18.
//  Copyright © 2018年 Jekity. All rights reserved.
//

#import "MUSegmentAppearance.h"


@implementation MUSegmentAppearance


- (instancetype)init{
    
    if (self = [super init]) {
        
        _titleFont = [UIFont systemFontOfSize:12.];
        _titleHightlightFont = [UIFont systemFontOfSize:12.];
        _titleColor = [UIColor blackColor];
        _titleHightlightColor = [UIColor whiteColor];
        
        
        _segmentColor = [UIColor clearColor];
        _segmentHightlightColor = [UIColor blackColor];
        
        _titleGravityStyle = MUTitleGravityStyleRight;
        
        _contentVerticalMargin = 10.;

        
    }
    return self;
}

- (UIColor *)segmentTouchDownColor{
    
    CGFloat onSelectionHue = 0.0;
    CGFloat onSelectionSaturation = 0.0;
    CGFloat onSelectionBrightness = 0.0;
    CGFloat onSelectionAlpha = 0.0;
    
    [self.segmentColor getHue:&onSelectionHue saturation: &onSelectionSaturation brightness:&onSelectionBrightness alpha:&onSelectionAlpha];
    
    CGFloat offSelectionHue = 0.0;
    CGFloat offSelectionSaturation = 0.0;
    CGFloat offSelectionBrightness = 0.0;
    CGFloat offSelectionAlpha = 0.0;
     [self.segmentHightlightColor getHue:&offSelectionHue saturation: &offSelectionSaturation brightness:&offSelectionBrightness alpha:&offSelectionAlpha];
    
    return [UIColor colorWithHue:(onSelectionHue + offSelectionHue)/2. saturation:(onSelectionSaturation + offSelectionSaturation)/2. brightness:(onSelectionBrightness + offSelectionBrightness)/2. alpha:(onSelectionAlpha + offSelectionAlpha)/2.];
}
@end
