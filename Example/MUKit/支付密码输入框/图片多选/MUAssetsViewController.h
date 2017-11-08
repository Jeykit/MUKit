//
//  MUAssetsViewController.h
//  MUKit_Example
//
//  Created by Jekity on 2017/11/7.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PHAssetCollection;
@class MUImagePickerManager;
@interface MUAssetsViewController : UICollectionViewController
@property (nonatomic, copy) NSArray *assetCollections;//资源集合
@property (nonatomic, strong) MUImagePickerManager *imagePickerController;
@end


