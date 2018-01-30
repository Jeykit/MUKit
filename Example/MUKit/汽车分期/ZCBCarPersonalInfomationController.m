//
//  ZCBCarPersonalInfomationController.m
//  MUKit_Example
//
//  Created by Jekity on 2017/12/26.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "ZCBCarPersonalInfomationController.h"
#import "ZCBCarPersonalInfomationHeaderView.h"

@interface ZCBCarPersonalInfomationController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property(nonatomic, strong)ZCBCarPersonalInfomationHeaderView *headerView;

@property (strong, nonatomic) NSMutableArray *indentifierImageArray;
@property (strong, nonatomic) NSMutableArray *paymentImageArray;
@end

@implementation ZCBCarPersonalInfomationController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self TTTitle:@"申请装修金贷款" textColor:[UIColor whiteColor] isShimmering:NO];
//    self.headerView = [ZCBCarPersonalInfomationHeaderView ViewFromXib];
//    self.headerView.AutoWidth = hScreenWidth;
    self.tableView.tableHeaderView = self.headerView;
//    self.tableView.backgroundColor = TTGrayColor(245);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.indentifierImageArray = [NSMutableArray array];
    self.paymentImageArray      = [NSMutableArray array];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
Click_signal(nextButton){
    
    CommonProgressShowWait(@"正在上传...")
    [self uploadImage:self.headerView.indentifierImageArray type:@"5"];
    [self uploadImage:self.headerView.paymentImageArray type:@"2"];
    
}
-(void)uploadImage:(NSArray *)images type:(NSString *)type{
    
    NSMutableDictionary *imgDic = [NSMutableDictionary dictionary ];
    for (int i = 0; i < images.count;  i++) {
        //缩放图片
        UIImage *img = images[i];
        CGFloat quality = 0.1;
        NSData *imgScale = UIImageJPEGRepresentation(img, quality);
        
        [imgDic setObject:imgScale forKey:[NSString stringWithFormat:@"img_file[%d]",i] ];
    }
    BSSCParms *p = [BSSCParms new];
    p.token        = wxxUser.token;
    p.type         = type;
    //    p.image         = imgDic.allKeys;;
//    CommonProgressShowWait(@"正在上传...")
    weakify(self)
    [BSSCHttpTools imgUpdataWithParameters:p.modeltoParms dataDic:imgDic path:@"m=Api&c=Upload&a=upLoadImg" progress:^(NSProgress * _Nonnull uploadProgress) {
//        NSString *result = [NSString stringWithFormat:@"图片上传进度：%0.0f%%",100.0*uploadProgress.completedUnitCount/uploadProgress.totalUnitCount];
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (imgDic.allKeys.count) {
//
//                CommonProgressSucess(result)
//            }
//
//        });
        
        
    } Success:^(id responseObject) {
        normalize(self)
        
        if ([responseObject[@"status"] integerValue] ==1)
        {
            if ([type integerValue] == 2) {
                [self.indentifierImageArray addObjectsFromArray:responseObject[@"result"]];
            }else{
                [self.paymentImageArray addObjectsFromArray:responseObject[@"result"]];
            }
            
            if (self.indentifierImageArray.count >0&& self.paymentImageArray.count >0) {
                CommonProgressSucess(@"上传成功");
                [self.navigationController WillPushViewController:@"ZCBCarCreditInfomationController" animated:YES SetupParms:^(UIViewController *vc, NSMutableDictionary *dict) {
                    [dict addEntriesFromDictionary:@{@"addressID":self.addressID ,@"decorationImageArray":self.decorationImageArray ,@"houseImageArray":self.houseImageArray ,@"detailString":self.detailString,@"contactString":self.contactString,@"indentifierImageArray":self.indentifierImageArray,@"paymentImageArray":self.paymentImageArray,@"contract_url":self.contract_url,@"phone":self.phone,@"money":self.money}];
                } callback:nil jumpError:nil];
            }
        }else{
            CommonProgressError(responseObject[@"msg"]);
        }
        
    } Failure:^(NSError *error) {
        CommonProgressNetWorkFail
    }];
}
*/

@end
