//
//  MUTranslucentController.m
//  MUKit
//
//  Created by Jekity on 2017/9/13.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "MUTranslucentController.h"
#import "MUTranslucentRootController.h"
@interface MUTranslucentController ()
@property(nonatomic, strong)MUTranslucentRootController *rootController;
@property(nonatomic, weak)UIView *tempCustomView;
@end

@implementation MUTranslucentController

+(instancetype)sharedInstance:(UIView *)customView{
    static __weak MUTranslucentController * instance;
    MUTranslucentController * strongInstance = instance;
    @synchronized (self) {
        if (strongInstance == nil) {
            strongInstance                = [[MUTranslucentController alloc]initWithCustomView:customView];
            instance                      = strongInstance;
        }
    }
    return strongInstance;
}

-(instancetype)initWithCustomView:(UIView *)view{
    
    _rootController = [MUTranslucentRootController new];
    _rootController.view.backgroundColor         = [UIColor clearColor];
    _rootController.customView                   = view;
    _tempCustomView                              = _rootController.customView;
    if (self = [super initWithRootViewController:_rootController]) {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        _rootController.controller               = self;
    }
    return self;
}

-(UIView *)customView{
    return _tempCustomView;
}
-(void)setLeftImage:(UIImage *)leftImage{
    _leftImage = leftImage;
    _rootController.leftImage = leftImage;
}
-(void)setRightImage:(UIImage *)rightImage{
    _rightImage = rightImage;
    _rootController.rightImage = rightImage;
}
-(void)setShowLeftBarItem:(BOOL)showLeftBarItem{
    _showLeftBarItem = showLeftBarItem;
    _rootController.showLeftBarItem = showLeftBarItem;
}
-(void)setShowRightBarItem:(BOOL)showRightBarItem{
    _showRightBarItem = showRightBarItem;
    _rootController.showRightBarItem = showRightBarItem;
}
-(void)setCenterTitle:(NSString *)centerTitle{
    _centerTitle = centerTitle;
    _rootController.centerTitle = centerTitle;
}

-(void)setHidesToolBar:(BOOL)hidesToolBar{
    _hidesToolBar = hidesToolBar;
    _rootController.hidesToolBar = hidesToolBar;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setNextController:(UIViewController *)nextController{
    
    if (!nextController) {
        
        _rootController.nextController = nextController;;
    }
}
-(void)setWillDismiss:(BOOL)willDismiss{
    _willDismiss = willDismiss;
    _rootController.willDismiss = willDismiss;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
