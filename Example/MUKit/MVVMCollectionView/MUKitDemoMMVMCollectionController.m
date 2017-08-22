//
//  MUKitDemoMMVMCollectionController.m
//  MUKit
//
//  Created by Jekity on 2017/8/22.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "MUKitDemoMMVMCollectionController.h"
#import "MUTableViewSectionModel.h"
//#import <MUCollectionViewManager.h>
@interface MUKitDemoMMVMCollectionController ()

@end

@implementation MUKitDemoMMVMCollectionController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//单层模型
-(NSMutableArray *)CustomerSigleModelArray{
    NSMutableArray *array = [NSMutableArray array];
    MUTableViewSectionModel *section1 = [[MUTableViewSectionModel alloc]init];
    section1.title       = @"Store Info";
//    section1.cellModelArray       = [@[@"MacBook Online"] mutableCopy];
//    if (self.type == MemberTypeManager) {
        section1.cellModelArray       = [@[@"MacBook Online",@"View all products"] mutableCopy];
//    }
    [array addObject:section1];
    
//    if (self.type == MemberTypeManager) {
        MUTableViewSectionModel *section2 = [[MUTableViewSectionModel alloc]init];
        section2.title = @"Advanced Settings";
        section2.cellModelArray       = [@[@"Store Decoration",@"Store Location",@"Open Time"] mutableCopy];
        [array addObject:section2];
        
//    }
    
    
    
    MUTableViewSectionModel *section3 = [[MUTableViewSectionModel alloc]init];
    section3.title         = @"Income Info";
//    if (self.type == MemberTypeManager) {
        section3.cellModelArray       = [@[@"Withdraw",@"Orders",@"Income"] mutableCopy];
//    }
    section3.cellModelArray       = [@[@"Orders",@"Income"] mutableCopy];
    [array addObject:section3];
    
    MUTableViewSectionModel *section4 = [[MUTableViewSectionModel alloc]init];
    section4.title         = @"Orther";
    section4.cellModelArray       = [@[@"About"] mutableCopy];
    [array addObject:section4];
    return  array;
}

@end
