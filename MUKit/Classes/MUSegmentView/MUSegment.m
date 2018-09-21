//
//  MUSegment.m
//  ZPApp
//
//  Created by Jekity on 2018/9/18.
//  Copyright © 2018年 Jekity. All rights reserved.
//

#import "MUSegment.h"
#import "MUSegmentAppearance.h"


@implementation MUSegment{
    
    UILabel * _titleLabel;
    UIImageView *_imageView;
    MUSegmentAppearance *_appearance;
}

- (instancetype)initWithAppearance:(MUSegmentAppearance *)appearance{
    
    if (self = [super init]) {
        _appearance = appearance;
        _selected   = NO;
        
        [self addUIElements];
        
        [self setupUIElements];
      
    }
    return self;
}

- (void)addUIElements{
    _imageView = [UIImageView new];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    _titleLabel = [UILabel new];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:_imageView];
    [self addSubview:_titleLabel];
}

- (void)setupUIElements{
    
    self.backgroundColor = _appearance.segmentColor;
    
    _titleLabel.font = _appearance.titleFont;
    _titleLabel.textColor = _appearance.titleColor;
    _titleLabel.text = _appearance.titleString;
    _titleLabel.backgroundColor = [UIColor clearColor];
    
    _imageView.image = _appearance.iconImage;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat distanceBetween = 0.;
    CGFloat verticalMargin = _appearance.contentVerticalMargin;
    CGRect imageViewFrame = CGRectMake(0., verticalMargin, 0., self.frame.size.height - verticalMargin *2);
    if (_appearance.iconImage != nil || _appearance.iconHightlightImage != nil) {
        imageViewFrame.size.width = imageViewFrame.size.height;
        distanceBetween = 5.;
    }
    
    CGRect titleFrame = CGRectZero;
    [_titleLabel sizeToFit];
    
    if (CGRectGetWidth(_titleLabel.frame) == 0.) {
        
        imageViewFrame.origin.y = MAX((self.frame.size.width - imageViewFrame.size.width)/2., 0.);
    }else{
        
        titleFrame.size.width = _titleLabel.frame.size.width;
        switch (_appearance.titleGravityStyle) {
            case MUTitleGravityStyleBottom:
                // Setup title width and height properties according to image size
                titleFrame.size.height = _titleLabel.frame.size.height ;// Need to be as small as possible to fit
                
                // Place image horizontally in centre and vertically to the top + vertical margin (changed to fit two vertical items)
                imageViewFrame.size.height = self.frame.size.height - verticalMargin * 2.5;
                
                if (imageViewFrame.size.height + _titleLabel.font.lineHeight > self.frame.size.height) {
                    imageViewFrame.size.height -= _titleLabel.font.lineHeight / 2;
                }
                
                imageViewFrame.size.width = imageViewFrame.size.height;
                imageViewFrame.origin.x = (self.frame.size.width - imageViewFrame.size.width)/2;
                imageViewFrame.origin.y = verticalMargin / 2;
                
                // Place the title horizontally in centre and vertivally below image + vertical margin (changed to fit two vertical items)
                titleFrame.origin.x = (self.frame.size.width - titleFrame.size.width)/2;
                titleFrame.origin.y = imageViewFrame.size.height + verticalMargin / 1.5;
                break;
            case MUTitleGravityStyleTop:
                // Setup title width and height properties according to image size
                titleFrame.size.height = _titleLabel.frame.size.height ;// Need to be as small as possible to fit
                
                // Place title horizontally in centre and vertically to the top + vertical margin (changed to fit two vertical items)
                titleFrame.origin.x = (self.frame.size.width - titleFrame.size.width)/2;
                titleFrame.origin.y = verticalMargin / 2;
                
                // Place the image horizontally in centre and vertivally below title + vertical margin (changed to fit two vertical items)
                imageViewFrame.size.height = self.frame.size.height - verticalMargin * 2.5;
                
                if (imageViewFrame.size.height + _titleLabel.font.lineHeight > self.frame.size.height) {
                    imageViewFrame.size.height -= _titleLabel.font.lineHeight / 2;
                }
                
                imageViewFrame.size.width = imageViewFrame.size.height;
                imageViewFrame.origin.x = (self.frame.size.width - imageViewFrame.size.width)/2;
                imageViewFrame.origin.y = titleFrame.size.height + verticalMargin / 1.5;
                break;
                
            case MUTitleGravityStyleLeft:
                // Setup title width and height properties according to image size
                titleFrame.size.height = self.frame.size.height - verticalMargin * 2;
                
                // If left space > 0, set half of it as initial X point of title
                titleFrame.origin
                .x = MAX((self.frame.size.width - imageViewFrame.size.width - _titleLabel.frame.size.width) / 2.0 - distanceBetween,
                         0.0
                         );
                
                titleFrame.origin.y = verticalMargin;
                
                // Place image to the right of title
                imageViewFrame.origin.x = titleFrame.origin.x + titleFrame.size.width + distanceBetween;
                break;
            default:
                
                // Setup title width and height properties according to image size
                titleFrame.size.width =_titleLabel.frame.size.width;
                titleFrame.size.height = self.frame.size.height - verticalMargin * 2;
                // If left space > 0, set half of it as initial X point og image
                imageViewFrame.origin.x = MAX(
                                              (self.frame.size.width - imageViewFrame.size.width - _titleLabel.frame.size.width) / 2.0 - distanceBetween,
                                              0.0
                                              );
                // Place title to the right of image
                titleFrame.origin.x = imageViewFrame.origin.x + imageViewFrame.size.width + distanceBetween;
                titleFrame.origin.y = verticalMargin;
                break;
        }
    }
    
    _titleLabel.frame = titleFrame;
    _imageView.frame = imageViewFrame;
}

- (void)setSelected:(BOOL)selected{
    if (_selected == selected) {
        return ;
    }
    _selected  =selected;
    if (_selected) {
        self.backgroundColor = _appearance.segmentHightlightColor;
        _titleLabel.textColor = _appearance.titleHightlightColor;
        _imageView.image =_appearance.iconHightlightImage;
    }else{
        self.backgroundColor = _appearance.segmentColor;
        _titleLabel.textColor = _appearance.titleColor;
        _imageView.image =_appearance.iconImage;
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (self.isSelected == NO) {
        self.backgroundColor = [_appearance segmentTouchDownColor];
    }
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (self.isSelected == NO) {
        
        if (self.didSelectSegment) {
            self.didSelectSegment(self);
        }
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.isSelected == NO) {
        self.backgroundColor = _appearance.segmentColor;
    }
    else {
       self.backgroundColor = _appearance.segmentHightlightColor;
    }
}
@end
