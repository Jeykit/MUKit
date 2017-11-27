//
//  MUKitDemoPaymentTableViewController.m
//  MUKit
//
//  Created by Jekity on 2017/8/25.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "MUKitDemoPaymentTableViewController.h"
#import "Order.h"
#import "RSADataSigner.h"
#import <MUTableViewManager.h>
#import <MUEPaymentManager.h>
@interface MUKitDemoPaymentTableViewController ()
@property(nonatomic, strong)MUTableViewManager *tableViewManger;
@end
static NSString *const cellReusedIndentifier = @"cell";
@implementation MUKitDemoPaymentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付demo";
    [self configuredDataSource];
 }
#pragma -mark init
-(void)configuredDataSource{
   
    self.tableViewManger = [[MUTableViewManager alloc]initWithTableView:self.tableView registerCellClass:NSStringFromClass([UITableViewCell class]) subKeyPath:nil];;
    self.tableViewManger.modelArray = @[@"Alipay",@"WeChatPay"];
    
    
    self.tableViewManger.renderBlock = ^UITableViewCell *(UITableViewCell *cell, NSIndexPath *indexPath, id model, CGFloat *height) {
        *height = 44.;
        cell.textLabel.text = [NSString stringWithFormat:@"%@",model];
        return cell;
    };
    
    __weak typeof(self) weakSelf = self;
    
    self.tableViewManger.selectedCellBlock = ^(UITableView *  tableView, NSIndexPath *  indexPath, id  model, CGFloat *  height) {
        
        if (indexPath.row == 0) {
            NSString *privateKey = [weakSelf createPrivateKey];
            [MUEPaymentManager muEPaymentManagerWithAliPay:privateKey result:^(NSDictionary *resultDict) {
                
                NSLog(@"alipayment-------%@-------",[NSString stringWithFormat:@"%@",resultDict[@"memo"]]);
                NSLog(@"alipayment-------%@-------",[NSString stringWithFormat:@"%@",resultDict]);
            }];
        }else{
            [MUEPaymentManager muEPaymentManagerWithWeChatPay:^(PayReq *req) {
                req.prepayId = @"2343tfdgf";
            } result:^(PayResp *rseq) {
                
            }];
        }
       
        
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)weChatPay{
    
    [MUEPaymentManager muEPaymentManagerWithWeChatPay:^(PayReq *req) {
        
    } result:^(PayResp *rseq) {
        
        
    }];
}
-(NSString *)createPrivateKey{
    NSString * partner = @"2088801766359801";
    //订单支付金额将打入该账户,一个partner可以对应多个seller_id。
//    NSString * seller = @"yongchun@hjtechcn.cn";
//    NSString *rsa2PrivateKey = @"";
    NSString *rsaPrivateKey = @"";
    NSString * rsa2PrivateKey = @"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBANYTzUXmSzf11XIypwoySx7kZJeX6B3rQ8SljoTlNIhqfL4v+PpcKLmU0Wp9ihup7c7wGjQ0wIHD8xbC8lO7gqWLDRLR1geHvNd2WwyObHRy7OU6ABNbIQt3LPn6lZcd5MAR437JL2ldBL9wHUETYRJhnSzMyI6hXmCzLrdeChHNAgMBAAECgYEAo8USTF8ZO/49A9fsIcjH3yIqMi5rzDem6FEe7lvKDHIqa/SXLDBEl3RZoHXZqcAdxSm5YibY/mzBErCgYZ4ZGtVMPU3v3H8FEh7Tu8R17XIucBEem6Wtw1nWtSApG4HQOOCOJc55sNjo1V+fvcbEEiecjctHZhZh24P5juMoPQECQQDrx4CSNzhUldlqK+t5IFEmVgI/nWNtOtH5x4wnQwnLDSGWTfQ+i5PhdiLKKIsT9GPsaICKFPl3ubwhdi8Sh90VAkEA6G/WK0rFUfHCrJvQnCGF035TMTYjOUyWLZEkgetuQ3bLIGoWGT77QSzo/hTpwsucDpmVOP5pLgOlzkYZnHm/2QJAEcL4q4sfYjfbpgTi+z/0/QdTqgkoOU1KDh/7LeX98d7uXc1HjgKjxENLAaGmQH2TnXaN4FkOJffG9Vpa13GGtQJBAM9mq2Xpy/P4k0rNpfELAIzc1YK92eRQ8FgsgLTkzHiqUUnVH27bgfqABk5hfsxwPgnRBRPb/yIt4w8SAdxbztECQQCnTNyGZvjwyADqnqaPWssjJRniV8VraQGxzsNBRq8VOAEr+y+BLV07De96bc1Sg5E3O0LVC/EExM1bIwcU52aP";
    Order* order = [Order new];
    
    // NOTE: app_id设置
    order.app_id = partner;
    
    // NOTE: 支付接口名称
    order.method = @"alipay.trade.app.pay";
    
    // NOTE: 参数编码格式
    order.charset = @"utf-8";
    
    // NOTE: 当前时间点
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];
    
    // NOTE: 支付版本
    order.version = @"1.0";
    
    // NOTE: sign_type 根据商户设置的私钥来决定
    order.sign_type =@"RSA";
    
    // NOTE: 商品数据
    order.biz_content = [BizContent new];
    order.biz_content.body = @"我是测试数据";
    order.biz_content.subject = @"1";
    order.biz_content.out_trade_no = [self generateTradeNO]; //订单ID（由商家自行制定）
    order.biz_content.timeout_express = @"30m"; //超时时间设置
    order.biz_content.total_amount = [NSString stringWithFormat:@"%.2f", 0.01]; //商品价格
    
    //将商品信息拼接成字符串
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
    NSLog(@"orderSpec = %@",orderInfo);


    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
    NSString *signedString = nil;
    RSADataSigner* signer = [[RSADataSigner alloc] initWithPrivateKey:((rsa2PrivateKey.length > 1)?rsa2PrivateKey:rsaPrivateKey)];
    if ((rsa2PrivateKey.length > 1)) {
        signedString = [signer signString:orderInfo withRSA2:YES];
    } else {
        signedString = [signer signString:orderInfo withRSA2:NO];
    }
    NSString *orderString = nil;
    // NOTE: 如果加签成功，则继续执行支付
    if (signedString != nil) {
        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
         orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                 orderInfoEncoded, signedString];
        
       
    }
    
    return orderString;
}
- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}
@end
