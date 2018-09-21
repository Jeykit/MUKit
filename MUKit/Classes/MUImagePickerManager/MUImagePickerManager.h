//
//  MUImagePickerManager.h
//  MUKit_Example
//
//  Created by Jekity on 2017/11/7.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MUImagePickerMediaType) {
    MUImagePickerMediaTypeAny = 0,
    MUImagePickerMediaTypeImage,
    MUImagePickerMediaTypeVideo
};
@interface MUImagePickerManager : NSObject

@property(nonatomic, copy)void(^didFinishedPickerImages)(NSArray<__kindof UIImage *>*originImages ,NSArray<__kindof UIImage *>*thumbnailImages);
//所选视频URL
@property(nonatomic, copy)void(^didFinishedPickerVideos)(NSArray*videoURLs);
//选择的资源类型
@property (nonatomic, strong, readonly) NSMutableOrderedSet *  selectedAssets;
//子资源类型
@property (nonatomic, copy) NSArray *assetCollectionSubtypes;
//是否允许多选
@property (nonatomic, assign) BOOL allowsMultipleSelection;
//最小的选择图片数
@property (nonatomic, assign) NSUInteger minimumNumberOfSelection;
//最大的选择图片数
@property (nonatomic, assign) NSUInteger maximumNumberOfSelection;
//显示选择的数目
@property (nonatomic, assign) BOOL showsNumberOfSelectedAssets;
//竖直方向时每一行显示的个数，默认4个
@property (nonatomic, assign) NSUInteger numberOfColumnsInPortrait;
//水平方向时每一行显示的个数，默认7个
@property (nonatomic, assign) NSUInteger numberOfColumnsInLandscape;
//资源类型
@property (nonatomic, assign) MUImagePickerMediaType mediaType;

//缩略图大小，默认240*240
@property (nonatomic,assign) CGSize thumbnailImageSize;

//拍照
-(void)takePhotoPresentIn:(UIViewController *)controller allowedEditedImage:(BOOL)allowed selectedImage:(void(^)(UIImage *origanlImage ,UIImage *editedImage))selectedImage;

-(void)presentInViewController:(UIViewController *)viewController;
/**
 Present the popup with transition style on a given view controller.
 Completion block will be called after the presenting transition is finished.
 @see transitionStyle
 */
- (void)presentInViewController:(UIViewController *)viewController completion:(void (^)(void))completion;

/**
 Dismiss the popup with transition style.
 @see transitionStyle
 */
- (void)dismiss;
/**
 Dismiss the popup with transition style.
 Completion block will be called after dismissing transition is finished.
 @see transitionStyle
 */
- (void)dismissWithCompletion:(void (^)(void))completion;
@end
