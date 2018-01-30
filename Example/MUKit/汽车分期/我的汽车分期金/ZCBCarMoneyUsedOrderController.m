//
//  ZCBCarMoneyUsedOrderController.m
//  ZhaoCaiHuiBaoRt
//
//  Created by wzs on 2018/1/6.
//  Copyright © 2018年 ttayaa. All rights reserved.
//

#import "ZCBCarMoneyUsedOrderController.h"
//#import "TTPopPayBoardController.h"

@interface ZCBCarMoneyUsedOrderController ()
@property (weak, nonatomic) IBOutlet UIImageView *closeImageView;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;
//@property (nonatomic, strong) TTPopPayBoardController *PayBoard;

@end

@implementation ZCBCarMoneyUsedOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.button setCornerRadius:10.];
    self.closeImageView.userInteractionEnabled = YES;
//    self.moneyLabel.text = [NSString stringWithFormat:@"￥%@",self.model.pay_money];
    self.edgesForExtendedLayout = UIRectEdgeBottom;
}
/*
Click_signal(closeImageView){
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
Click_signal(button){
    weakify(self)
    self.PayBoard = [TTPopPayBoardController PayBoardWithName:@"" FinishInput:^(NSMutableArray *pwdArr) {
        normalize(self)
        //将密码数组转成字符串密码
        NSMutableString *str = [NSMutableString string];
        [pwdArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [str appendString:obj];
        }];
        
        
        [self.view endEditing:YES];
        weakify(self)
        [BSSCModel POST_DICT:@"m=Api&c=Consumer&a=projectPayment" Params:^(BSSCParms *ParmsModel) {
            normalize(self)
            ParmsModel.id = self.model.id;
            ParmsModel.step = self.model.step;
            ParmsModel.paypwd = str;
          
            
        } success:^(id responseObject) {
            normalize(self)
            
            IF_BSSCHttpToolsIsRequestSuccess
            {
                
                [self.PayBoard dismissViewControllerAnimated:YES completion:nil];
                [self dismissViewControllerAnimated:YES completion:^{
                    
                    if (self.callbackblock) {
                        self.callbackblock(self.model);
                    }
                }];
                
            }else{
                
                [self.PayBoard startFailureAnima:responseObject[@"msg"]];
            }
            
        } failure:^(NSError *error) {
            
            normalize(self)
            [self.PayBoard startFailureAnima:[NSString stringWithFormat:@"转入失败!"]];
            
        }];
        
        
        
        
    }];
    
    //为了防止用户点击蒙版退下 循环引用
    [self.PayBoard WhenViewWillDisappear_offen:^(id args) {
        self.PayBoard = nil;
    }];
    [self presentViewController:self.PayBoard animated:YES frame:CGRectMake(0, hScreenHeight - hScreenWidth*467/380  , hScreenWidth, hScreenHeight) style:TTPresentStyleCustomModal_blackhud completion:nil];
      self.PayBoard.money_lb.hidden = YES;
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
