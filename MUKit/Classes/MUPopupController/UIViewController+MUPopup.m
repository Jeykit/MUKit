//
//  UIViewController+MUPopup.m
//  Pods
//
//  Created by Jekity on 2017/10/10.
//
//

#import "UIViewController+MUPopup.h"
#import "MUPopupController.h"
#import "MUHookMethodHelper.h"
#import <objc/runtime.h>

typedef void (^DeallocBlock)(void);
@interface MUPopOrignalObject : NSObject
@property (nonatomic, copy) DeallocBlock block;
-(instancetype)initWithBlock:(DeallocBlock)block;
@end
@implementation MUPopOrignalObject
- (instancetype)initWithBlock:(DeallocBlock)block
{
    if (self = [super init]){
        self.block = block;
    }
    return self;
}
- (void)dealloc {
    self.block ? self.block() : nil;
}
@end

@implementation UIViewController (MUPopup)

@dynamic contentSizeInPopup;
@dynamic landscapeContentSizeInPopup;
@dynamic popupController;

+(void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [MUHookMethodHelper muHookMethod:NSStringFromClass([self class]) orignalSEL:@selector(viewDidLoad) newClassName:NSStringFromClass([self class]) newSEL:@selector(mupopup_viewDidLoad)];
        [MUHookMethodHelper muHookMethod:NSStringFromClass([self class]) orignalSEL:@selector(presentViewController:animated:completion:) newClassName:NSStringFromClass([self class]) newSEL:@selector(mupopup_presentViewController:animated:completion:)];
        [MUHookMethodHelper muHookMethod:NSStringFromClass([self class]) orignalSEL:@selector(dismissViewControllerAnimated:completion:) newClassName:NSStringFromClass([self class]) newSEL:@selector(mupopup_dismissViewControllerAnimated:completion:)];
        [MUHookMethodHelper muHookMethod:NSStringFromClass([self class]) orignalSEL:@selector(presentedViewController) newClassName:NSStringFromClass([self class]) newSEL:@selector(mupopup_presentedViewController)];
        [MUHookMethodHelper muHookMethod:NSStringFromClass([self class]) orignalSEL:@selector(presentingViewController) newClassName:NSStringFromClass([self class]) newSEL:@selector(mupopup_presentingViewController)];
    });
    
}

//根据屏幕方向设置contentSize
-(void)mupopup_viewDidLoad{
    CGSize contentSize = CGSizeZero;
    switch ([UIApplication sharedApplication].statusBarOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:{
            
            contentSize = self.landscapeContentSizeInPopup;
            if (CGSizeEqualToSize(contentSize,CGSizeZero)) {
                
                contentSize = self.contentSizeInPopup;
            }
        }
            break;
            
        default:
            contentSize = self.contentSizeInPopup;
            break;
    }
    if (!CGSizeEqualToSize(contentSize, CGSizeZero)) {
        self.view.frame = CGRectMake(0, 0, contentSize.width, contentSize.height);
    }
    
    [self mupopup_viewDidLoad];
}

-(void)mupopup_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)animated completion:(void(^)(void))completion{
    if (!self.popupController) {
        [self mupopup_presentViewController:viewControllerToPresent animated:animated completion:completion];
        return;
    }
    [[self.popupController valueForKey:@"containerViewController"] presentViewController:viewControllerToPresent animated:animated completion:completion];
}
- (void)mupopup_dismissViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    if (!self.popupController) {
        [self mupopup_dismissViewControllerAnimated:animated completion:completion];
        return;
    }
    
    [self.popupController dismissWithCompletion:completion];
}
- (UIViewController *)mupopup_presentedViewController
{
    if (!self.popupController) {
        return [self mupopup_presentedViewController];
    }
    return [[self.popupController valueForKey:@"containerViewController"] presentedViewController];
}

- (UIViewController *)mupopup_presentingViewController
{
    if (!self.popupController) {
        return [self mupopup_presentingViewController];
    }
    return [[self.popupController valueForKey:@"containerViewController"] presentingViewController];
}

//竖直方向屏幕contentSize
-(void)setContentSizeInPopup:(CGSize)contentSizeInPopup{
    
    if (!CGSizeEqualToSize(contentSizeInPopup, CGSizeZero) && contentSizeInPopup.width == 0) {
        
        switch ([UIApplication sharedApplication].statusBarOrientation) {
            case UIInterfaceOrientationLandscapeLeft:
            case UIInterfaceOrientationLandscapeRight: {
                contentSizeInPopup.width = [UIScreen mainScreen].bounds.size.height;
            }
                break;
            default: {
                contentSizeInPopup.width = [UIScreen mainScreen].bounds.size.width;
            }
                break;
        }
    }
    
    objc_setAssociatedObject(self, @selector(contentSizeInPopup), [NSValue valueWithCGSize:contentSizeInPopup], OBJC_ASSOCIATION_RETAIN);
}
-(CGSize)contentSizeInPopup{
    return [objc_getAssociatedObject(self, @selector(contentSizeInPopup)) CGSizeValue];
}

- (void)setLandscapeContentSizeInPopup:(CGSize)landscapeContentSizeInPopup
{
    if (!CGSizeEqualToSize(CGSizeZero, landscapeContentSizeInPopup) && landscapeContentSizeInPopup.width == 0) {
        switch ([UIApplication sharedApplication].statusBarOrientation) {
            case UIInterfaceOrientationLandscapeLeft:
            case UIInterfaceOrientationLandscapeRight: {
                landscapeContentSizeInPopup.width = [UIScreen mainScreen].bounds.size.width;
            }
                break;
            default: {
                landscapeContentSizeInPopup.width = [UIScreen mainScreen].bounds.size.height;
            }
                break;
        }
    }
    objc_setAssociatedObject(self, @selector(landscapeContentSizeInPopup), [NSValue valueWithCGSize:landscapeContentSizeInPopup], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGSize)landscapeContentSizeInPopup
{
    return [objc_getAssociatedObject(self, @selector(landscapeContentSizeInPopup)) CGSizeValue];
}

-(void)setPopupController:(MUPopupController * )popupController{
    MUPopOrignalObject *ob = [[MUPopOrignalObject alloc] initWithBlock:^{
        objc_setAssociatedObject(self, @selector(popupController), nil, OBJC_ASSOCIATION_ASSIGN);
    }];
    // 这里关联的key必须唯一，如果使用_cmd，对一个对象多次关联的时候，前面的对象关联会失效。
    if (popupController) {
        objc_setAssociatedObject(popupController, (__bridge const void *)(ob.block), ob, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    objc_setAssociatedObject(self, @selector(popupController), popupController, OBJC_ASSOCIATION_ASSIGN);
//     objc_setAssociatedObject(self, @selector(popupController), popupController, OBJC_ASSOCIATION_ASSIGN);
}
-(MUPopupController *)popupController{
    MUPopupController *popupController = objc_getAssociatedObject(self, @selector(popupController));
    if (!popupController) {
        return self.parentViewController.popupController;
    }
    return popupController;
}
@end


