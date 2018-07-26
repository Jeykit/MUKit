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
//是否允许多选
@property (nonatomic, assign) BOOL allowsMultipleSelection;
//最小的选择图片数
@property (nonatomic, assign) NSUInteger minimumNumberOfSelection;
//最大的选择图片数
@property (nonatomic, assign) NSUInteger maximumNumberOfSelection;
//竖直方向时每一行显示的个数，默认4个
@property (nonatomic, assign) NSUInteger numberOfColumnsInPortrait;
//水平方向时每一行显示的个数，默认7个
@property (nonatomic, assign) NSUInteger numberOfColumnsInLandscape;

@end


