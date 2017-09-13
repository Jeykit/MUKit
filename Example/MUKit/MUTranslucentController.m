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
@end

@implementation MUTranslucentController
-(instancetype)initWithCustomView:(UIView *)view{
    
    _rootController = [MUTranslucentRootController new];
    _rootController.view.backgroundColor         = [UIColor clearColor];
    _rootController.customView                   = view;
    if (self = [super initWithRootViewController:_rootController]) {
        
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    return self;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
