//
//  MUPopupControllerTransitioningFade.m
//  Pods
//
//  Created by Jekity on 2017/10/10.
//
//

#import "MUPopupControllerTransitioningFade.h"

@implementation MUPopupControllerTransitioningFade
-(NSTimeInterval)popupControllerTransitionDuration:(MUPopupControllerTransitioningContext *)context{
    return context.action == MUPopupControllerTransitioningActionPresent ? .25 : .2;
}
-(void)popupControllerAnimateTransition:(MUPopupControllerTransitioningContext *)context completion:(void (^)())completion{
    
    UIView *containerView = context.containerView;
    if (context.action == MUPopupControllerTransitioningActionPresent) {
        
        containerView.alpha = 0;
        containerView.transform = CGAffineTransformMakeScale(1.05, 1.05);
        [UIView animateWithDuration:[self popupControllerTransitionDuration:context] delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            containerView.alpha = 1.;
            containerView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            completion();
        }];
    }else{
        [UIView animateWithDuration:[self popupControllerTransitionDuration:context] delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            containerView.alpha = 0;
        } completion:^(BOOL finished) {
            containerView.alpha = 1;
            completion();
        }];
    }
}
@end
