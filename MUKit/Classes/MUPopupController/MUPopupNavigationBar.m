//
//  MUPopupNavigationBar.m
//  Pods
//
//  Created by Jekity on 2017/10/10.
//
//

#import "MUPopupNavigationBar.h"

@protocol MUPopupNavigationTouchEventDelegate <NSObject>

- (void)popupNavigationBar:(MUPopupNavigationBar *)navigationBar touchDidMoveWithOffset:(CGFloat)offset;
- (void)popupNavigationBar:(MUPopupNavigationBar *)navigationBar touchDidEndWithOffset:(CGFloat)offset;

@end


@interface MUPopupNavigationBar()
@property(nonatomic, weak) id<MUPopupNavigationTouchEventDelegate> touchEventDelegate;
@property(nonatomic, assign)BOOL moving;
@property(nonatomic, assign)CGFloat movingStartY;

@property(nonatomic, weak)UIView *containerView;

@end
@implementation MUPopupNavigationBar

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.draggable = YES;
    }
    return self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (!self.draggable) {
        [super touchesBegan:touches withEvent:event];
        return;
    }
    UITouch *touch = [touches anyObject];
    if ((touch.view == self || touch.view.superview == self) && !_moving) {
        _moving = YES;
        _movingStartY = [touch locationInView:self.window].y;
    }
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (!self.draggable) {
        [super touchesMoved:touches withEvent:event];
        return;
    }
    if (_moving) {
        
        UITouch *touch = [touches anyObject];
        float offset   = [touch locationInView:self.window].y - _movingStartY;
        if ([self.touchEventDelegate respondsToSelector:@selector(popupNavigationBar:touchDidMoveWithOffset:)]) {
            [self.touchEventDelegate popupNavigationBar:self touchDidMoveWithOffset:offset];
        }
    }
}
-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (!self.draggable) {
        [super touchesCancelled:touches withEvent:event];
        return;
    }
    
    if (_moving) {
        UITouch *touch = [touches anyObject];
        float offset = [touch locationInView:self.window].y - _movingStartY;
        [self movingDidEndWithOffset:offset];
    }
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (!self.draggable) {
        [super touchesEnded:touches withEvent:event];
        return;
    }
    
    if (_moving) {
        UITouch *touch = [touches anyObject];
        float offset = [touch locationInView:self.window].y - _movingStartY;
        [self movingDidEndWithOffset:offset];
    }
}

- (void)movingDidEndWithOffset:(float)offset
{
    _moving = NO;
    if ([self.touchEventDelegate respondsToSelector:@selector(popupNavigationBar:touchDidEndWithOffset:)]) {
        [self.touchEventDelegate popupNavigationBar:self touchDidEndWithOffset:offset];
    }
}


@end
