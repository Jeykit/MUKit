//
//  MUCaptionView.m
//  MUKit
//
//  Created by Jekity on 2018/8/30.
//

#import "MUCaptionView.h"
static const CGFloat labelPadding = 10;


@implementation MUCaptionView{
    UILabel *_label;
}
- (instancetype)init{
    if (self = [super init]) {
        self.clipsToBounds = YES;
        self.userInteractionEnabled = NO;
        self.barStyle = UIBarStyleBlack;
        self.tintColor = nil;
        self.barTintColor = nil;
        self.translucent = YES;
        [self setBackgroundImage:nil forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        [self setupCaption];
    }
    return self;
}
- (CGSize)sizeThatFits:(CGSize)size withTitle:(NSString *)title{
    CGFloat maxHeight = 9999;
    _label.text = title.length>0?title:_label.text?:@"";
    if (_label.numberOfLines > 0) maxHeight = _label.font.leading*_label.numberOfLines;
    CGSize textSize = [_label.text boundingRectWithSize:CGSizeMake(size.width - labelPadding*2, maxHeight)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName:_label.font}
                                                context:nil].size;
    return CGSizeMake(size.width, textSize.height + labelPadding * 2);
}

- (void)setupCaption {
    _label = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(labelPadding, 0,
                                                                      self.bounds.size.width-labelPadding*2,
                                                                      self.bounds.size.height))];
    _label.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _label.opaque = NO;
    _label.backgroundColor = [UIColor clearColor];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.lineBreakMode = NSLineBreakByWordWrapping;
    
    _label.numberOfLines = 0;
    _label.textColor = [UIColor whiteColor];
    _label.font = [UIFont systemFontOfSize:17];
   
    [self addSubview:_label];
}
@end
