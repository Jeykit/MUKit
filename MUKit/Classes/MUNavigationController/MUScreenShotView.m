//
//  MUScreenShotView.m
//  MUKit_Example
//
//  Created by Jekity on 2018/10/24.
//  Copyright © 2018 Jeykit. All rights reserved.
//

#import "MUScreenShotView.h"

@implementation MUScreenShotView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        self.maskView = [[UIView alloc]initWithFrame:self.bounds];
        self.maskView.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0.4];
        _arrayScreenShots = [NSMutableArray array];
        
        [self addSubview:self.imageView];
        [self addSubview:self.maskView];
    }
    return self;
}
@end
