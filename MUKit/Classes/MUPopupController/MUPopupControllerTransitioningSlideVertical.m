//
//  MUPopupControllerTransitioningSlideVertical.m
//  Pods
//
//  Created by Jekity on 2017/10/10.
//
//

#import "MUPopupControllerTransitioningSlideVertical.h"

@implementation MUPopupControllerTransitioningSlideVertical
- (NSTimeInterval)popupControllerTransitionDuration:(MUPopupControllerTransitioningContext *)context
{
    return context.action == MUPopupControllerTransitioningActionPresent ? 0.5 : 0.35;
}

- (void)popupControllerAnimateTransition:(MUPopupControllerTransitioningContext *)context completion:(void (^)())completion
{
    UIView *containerView = context.containerView;
    if (context.action == MUPopupControllerTransitioningActionPresent) {
        containerView.transform = CGAffineTransformMakeTranslation(0, containerView.superview.bounds.size.height - containerView.frame.origin.y);
        
        [UIView animateWithDuration:[self popupControllerTransitionDuration:context] delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            context.containerView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            completion();
        }];
    }
    else {
        CGAffineTransform lastTransform = containerView.transform;
        containerView.transform = CGAffineTransformIdentity;
        CGFloat originY = containerView.frame.origin.y;
        containerView.transform = lastTransform;
        
        [UIView animateWithDuration:[self popupControllerTransitionDuration:context] delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            containerView.transform = CGAffineTransformMakeTranslation(0, containerView.superview.bounds.size.height - originY + containerView.frame.size.height);
        } completion:^(BOOL finished) {
            containerView.transform = CGAffineTransformIdentity;
            completion();
        }];
    }
}
@end
