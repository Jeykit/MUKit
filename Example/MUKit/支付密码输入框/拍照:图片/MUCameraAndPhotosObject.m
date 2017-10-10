//
//  MUCameraAndPhotosObject.m
//  ZhaoCaiHuiBaoSeller
//
//  Created by Jekity on 2017/9/21.
//  Copyright © 2017年 Jekity. All rights reserved.
//

#import "MUCameraAndPhotosObject.h"

@interface MUCameraAndPhotosObject()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic, strong)UIImagePickerController *pickerImageController;
@end

static void(^callBack)(UIImage * image);
static MUCameraAndPhotosObject *tempObject;

@implementation MUCameraAndPhotosObject
-(UIImagePickerController *)pickerImageController{
    if (!_pickerImageController) {
        
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            return nil;
        }
        // 2. 创建图片选择控制器
        _pickerImageController = [[UIImagePickerController alloc] init];
        /**
         typedef NS_ENUM(NSInteger, UIImagePickerControllerSourceType) {
         UIImagePickerControllerSourceTypePhotoLibrary, // 相册
         UIImagePickerControllerSourceTypeCamera, // 用相机拍摄获取
         UIImagePickerControllerSourceTypeSavedPhotosAlbum // 相簿
         }
         */
        _pickerImageController.allowsEditing = YES;
        // 3. 设置打开照片相册类型(显示所有相簿)
        _pickerImageController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // ipc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        // 照相机
        // ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
        // 4.设置代理
        _pickerImageController.delegate = self;
        tempObject                      = self;

    }
    return _pickerImageController;
}

-(void)pickImageControllerPresentIn:(UIViewController *)controller selectedImage:(void (^)(UIImage *))selectedImage{
    
    callBack = selectedImage;
    [controller presentViewController:self.pickerImageController animated:YES completion:nil];
}

-(void)takePhotoControllerPresentIn:(UIViewController *)controller selectedImage:(void (^)(UIImage *))selectedImage{
    self.pickerImageController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    callBack = selectedImage;
     [controller presentViewController:self.pickerImageController animated:YES completion:nil];
}
#pragma mark -- <UIImagePickerControllerDelegate>--
// 获取图片后的操作
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 销毁控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // 设置图片
    if (callBack) {
        callBack(info[UIImagePickerControllerOriginalImage]);
    }
    tempObject = nil;
}

-(void)dealloc{
    NSLog(@"被销毁了");
}
@end
