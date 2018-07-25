//
//  MUImagePickerManager.m
//  MUKit_Example
//
//  Created by Jekity on 2017/11/7.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "MUImagePickerManager.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "MUAssetsViewController.h"
#import "MUAuthorizationStatusController.h"

@interface MUImagePickerNavigationController : UINavigationController

@end
@implementation MUImagePickerNavigationController

@end

@interface MUImagePickerManager()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) MUImagePickerNavigationController *albumsNavigationController;
@property (nonatomic, copy) NSArray *fetchResults;//提取的结果集
@property (nonatomic, copy) NSArray *assetCollections;//资源集合
@property(nonatomic, weak)MUAssetsViewController *assetsViewController;
@property (nonatomic,weak) UIViewController *senderController;
@property(nonatomic, strong)UIImagePickerController *pickerImageController;
@end

static void(^callBack)(UIImage * origalImage ,UIImage *editedImage);
static MUImagePickerManager *tempObject;
@implementation MUImagePickerManager
-(instancetype)init{
    if (self = [super init]) {
        // Set default values
    
        
         _selectedAssets                = [NSMutableOrderedSet orderedSet];
        self.mediaType                  = MUImagePickerMediaTypeImage;//默认是图片
       
        
        self.allowsMultipleSelection    = YES;
        self.minimumNumberOfSelection   = 1;
        self.numberOfColumnsInPortrait  = 4;
        self.numberOfColumnsInLandscape = 7;
        
        
    }
    return self;
}
- (void)initalization{
    
    self.assetCollectionSubtypes = @[
                                     @(PHAssetCollectionSubtypeSmartAlbumUserLibrary),
                                     @(PHAssetCollectionSubtypeAlbumMyPhotoStream),
                                     @(PHAssetCollectionSubtypeSmartAlbumPanoramas),
                                     @(PHAssetCollectionSubtypeSmartAlbumVideos),
                                     @(PHAssetCollectionSubtypeSmartAlbumBursts)
                                     ];
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
    PHFetchResult *userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
    self.fetchResults = @[smartAlbums, userAlbums];
    [self updateAssetCollections];
}
- (void)updateAssetCollections
{
 
    // Filter albums
    NSArray *assetCollectionSubtypes = self.assetCollectionSubtypes;
    NSMutableDictionary *smartAlbums = [NSMutableDictionary dictionaryWithCapacity:assetCollectionSubtypes.count];
    NSMutableArray *userAlbums = [NSMutableArray array];
    
    for (PHFetchResult *fetchResult in self.fetchResults) {
        [fetchResult enumerateObjectsUsingBlock:^(PHAssetCollection *assetCollection, NSUInteger index, BOOL *stop) {
            PHAssetCollectionSubtype subtype = assetCollection.assetCollectionSubtype;
            
            if (subtype == PHAssetCollectionSubtypeAlbumRegular) {
                [userAlbums addObject:assetCollection];
            } else if ([assetCollectionSubtypes containsObject:@(subtype)]) {
                if (!smartAlbums[@(subtype)]) {
                    smartAlbums[@(subtype)] = [NSMutableArray array];
                }
                [smartAlbums[@(subtype)] addObject:assetCollection];
            }
        }];
    }
    
    NSMutableArray *assetCollections = [NSMutableArray array];
    
    // Fetch smart albums
    for (NSNumber *assetCollectionSubtype in assetCollectionSubtypes) {
        NSArray *collections = smartAlbums[assetCollectionSubtype];
        
        if (collections) {
            [assetCollections addObjectsFromArray:collections];
        }
    }
    
    // Fetch user albums
    [userAlbums enumerateObjectsUsingBlock:^(PHAssetCollection *assetCollection, NSUInteger index, BOOL *stop) {
        [assetCollections addObject:assetCollection];
    }];
    
    self.assetCollections = assetCollections;
}
//初始化
- (void)setUpAlbumsNavigationViewController{
   
   NSString *count = [[NSUserDefaults standardUserDefaults] valueForKey:@"MUAssetsFirstShow"];
    if (self.mediaType == MUImagePickerMediaTypeImage&&!count) {
        MUAuthorizationStatusController *assetsController = [MUAuthorizationStatusController new];
        assetsController.imagePickerController   = self;
        self.albumsNavigationController = [[MUImagePickerNavigationController alloc]initWithRootViewController:assetsController];
       
    }else{
        [self initalization];
        if ([self havePhotoLibraryAuthority]) {
            MUAssetsViewController *assetsController = [MUAssetsViewController new];
            assetsController.imagePickerController   = self;
            assetsController.assetCollections        = self.assetCollections;
            self.assetsViewController                = assetsController;
            self.albumsNavigationController = [[MUImagePickerNavigationController alloc]initWithRootViewController:assetsController];
        }else{
            MUAuthorizationStatusController *assetsController = [MUAuthorizationStatusController new];
            assetsController.imagePickerController   = self;
            self.albumsNavigationController = [[MUImagePickerNavigationController alloc]initWithRootViewController:assetsController];
        }
    }
   
}
- (void)takePhotoPresentIn:(UIViewController *)controller allowedEditedImage:(BOOL)allowed selectedImage:(void (^)(UIImage *, UIImage *))selectedImage{
    callBack = selectedImage;
    [controller presentViewController:self.pickerImageController animated:YES completion:^{
        if (self.albumsNavigationController) {
            [self.albumsNavigationController dismissViewControllerAnimated:NO completion:nil];
        }
    }];
   
}
-(void)presentInViewController:(UIViewController *)viewController{
    _senderController = viewController;
    [self presentInViewController:viewController completion:nil];
}

-(void)presentInViewController:(UIViewController *)viewController completion:(void (^)(void))completion{
     _senderController = viewController;
    [self setUpAlbumsNavigationViewController];
    [viewController presentViewController:self.albumsNavigationController animated:YES completion:^{
        if (completion) {
            completion();
        }
    }];
}
-(void)dismiss{
    [self dismissWithCompletion:nil];
}
-(void)dismissWithCompletion:(void (^)(void))completion{
    [self.albumsNavigationController dismissViewControllerAnimated:YES completion:^{
        
        if (completion) {
            completion();
        }
    }];
}

-(void)setAllowsMultipleSelection:(BOOL)allowsMultipleSelection{
    _allowsMultipleSelection = allowsMultipleSelection;
    self.assetsViewController.allowsMultipleSelection = allowsMultipleSelection;
}
-(void)setMaximumNumberOfSelection:(NSUInteger)maximumNumberOfSelection{
    _maximumNumberOfSelection = maximumNumberOfSelection;
    self.assetsViewController.maximumNumberOfSelection = maximumNumberOfSelection;
}
-(void)setMinimumNumberOfSelection:(NSUInteger)minimumNumberOfSelection{
    _minimumNumberOfSelection = minimumNumberOfSelection;
    self.assetsViewController.minimumNumberOfSelection = minimumNumberOfSelection;
}
-(void)setNumberOfColumnsInPortrait:(NSUInteger)numberOfColumnsInPortrait{
    _numberOfColumnsInPortrait = numberOfColumnsInPortrait;
    self.assetsViewController.numberOfColumnsInPortrait = numberOfColumnsInPortrait;
}
-(void)setNumberOfColumnsInLandscape:(NSUInteger)numberOfColumnsInLandscape{
    _numberOfColumnsInLandscape = numberOfColumnsInLandscape;
    self.assetsViewController.numberOfColumnsInLandscape = numberOfColumnsInLandscape;
}



#pragma mark - 权限相关
- (BOOL)havePhotoLibraryAuthority
{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusAuthorized) {
        return YES;
    }
    return NO;
}

- (BOOL)haveCameraAuthority
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusRestricted ||
        status == AVAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
}

- (BOOL)haveMicrophoneAuthority
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (status == AVAuthorizationStatusRestricted ||
        status == AVAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
}

-(UIImagePickerController *)pickerImageController{
    if (!_pickerImageController) {
        
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            return nil;
        }
        // 2. 创建图片选择控制器
        _pickerImageController = [[UIImagePickerController alloc] init];
      
        _pickerImageController.allowsEditing = YES;
        // 3. 设置打开照片相册类型(显示所有相簿)
        _pickerImageController.sourceType = UIImagePickerControllerSourceTypeCamera;
        // 4.设置代理
        _pickerImageController.delegate = self;
        tempObject = self;
        
    }
    return _pickerImageController;
}
#pragma mark -- <UIImagePickerControllerDelegate>--
// 获取图片后的操作
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 销毁控制器
    [picker dismissViewControllerAnimated:YES completion:^{
        
        // 设置图片
        if (callBack) {
            callBack(info[UIImagePickerControllerOriginalImage] ,info[UIImagePickerControllerEditedImage]);
           
        }
        tempObject = nil;
    }];
}
@end
