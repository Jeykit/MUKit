//
//  MUCircleView.m
//  MUKit_Example
//
//  Created by Jekity on 2017/11/8.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "MUCircleView.h"

@implementation MUCircleView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        // Set default values
        self.borderWidth = 1.5;
        self.borderColor = [UIColor whiteColor];
        
        self.layer.cornerRadius = frame.size.height/2.;
        self.layer.borderWidth  = self.borderWidth;
        
        self.layer.borderColor  = self.borderColor.CGColor;
        
        
        // Set shadow
        self.layer.shadowColor = [[UIColor grayColor] CGColor];
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowOpacity = 0.6;
        self.layer.shadowRadius = 2.0;
    }
    return self;
}
-(void)setBorderColor:(UIColor *)borderColor{
    _borderColor = borderColor;
    self.layer.borderColor = borderColor.CGColor;
}
@end
