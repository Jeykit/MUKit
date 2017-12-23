//
//  SCAdDemoCollectionViewCell.h
//  SCAdViewDemo
//
//  Created by 陈世翰 on 17/2/7.
//  Copyright © 2017年 Coder Chan. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface SCAdDemoCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *showImage;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property(nonatomic, copy)NSString *name;
@end
