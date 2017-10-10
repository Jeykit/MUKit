//
//  ZCHBSellerLoginController.m
//  MUKit
//
//  Created by Jekity on 2017/9/14.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "ZCHBSellerLoginController.h"
#import "ZCHBBusinessmenLoginHeaderView.h"
#import "BusinessHTTPSessionManager.h"
#import "BusinessModel.h"



#undef	tableHeaderViewFromXib
#define tableHeaderViewFromXib(value) \
({\
CGFloat newValue = (CGFloat)(int)(scaleHeight * value);\
if ([UIScreen mainScreen].scale == 3) {\
newValue = value * 1.5;\
}\
(newValue);\
})\


@interface ZCHBSellerLoginController ()
@property(nonatomic, strong)ZCHBBusinessmenLoginHeaderView *headerView;
@end

@implementation ZCHBSellerLoginController{
    ZCHBBusinessmenLoginHeaderView *header;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
//    NSLog(@"header==== %@",NSStringFromClass([self.headerView class]));
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    ZCHBBusinessmenLoginHeaderView *view = [ZCHBBusinessmenLoginHeaderView new];
    self.tableView.tableHeaderView = [self tableHeaderViewFromXib:&view];
    self.headerView = view;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    
}
Click_MUSignal(headerView){
    
    [BusinessModel POST:@"/index.php?m=SellerApi&c=Index&a=selleIndex" parameters:^(BusinessParameterModel *parameter) {
//        parameter.app_type = @"1";
//        parameter.sellername = _headerView.phoneTextField.text;
//        parameter.password = _headerView.passwordTextField.text;
        
        
    } success:^(BusinessModel *model, NSArray<BusinessModel *> *modelArray, id responseObject) {
        NSLog(@"model ===== %@",model.token);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error, NSString *errorMsg) {
        
        
    }];
}
-(UIView *)tableHeaderViewFromXib:(UIView * *)view{
   *view = [[[NSBundle bundleForClass:[*view class]] loadNibNamed:NSStringFromClass([*view class]) owner:nil options:nil] firstObject];
    UIView *tempView = *view;
    UIView *superView = [[UIView alloc]initWithFrame:tempView.bounds];
    superView.backgroundColor = [UIColor clearColor];
    [superView addSubview:tempView];
    return superView;
}
//-(UIView *)viewFromXib{
//    return [[[NSBundle bundleForClass:[self class]] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
Click_MUSignal(loginButton){
    
    if (self.headerView.phoneTextField.text && self.headerView.passwordTextField.text) {
        
        [BusinessModel POST:@"/index.php?m=SellerApi&c=Index&a=login" parameters:^(BusinessParameterModel *parameter) {
            parameter.app_type = @"1";
            parameter.sellername = _headerView.phoneTextField.text;
            parameter.password = _headerView.passwordTextField.text;

            
        } success:^(BusinessModel *model, NSArray<BusinessModel *> *modelArray, id responseObject) {
              NSLog(@"model ===== %@",model.token);
            
        } failure:^(NSURLSessionDataTask *task, NSError *error, NSString *errorMsg) {
            
            
        }];
    
    }
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
