//
//  MUWaterfallFlowLayout.h
//  MUKit
//
//  Created by Jekity on 2017/8/23.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MUWaterfallFlowLayout : UICollectionViewFlowLayout
@property(nonatomic, assign)IBOutlet id <UICollectionViewDelegateFlowLayout> delegate;
@property(nonatomic, assign)NSUInteger itemCount;
@end
