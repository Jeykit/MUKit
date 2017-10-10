//
//  MUCameraAndPhotosManager.m
//  ZhaoCaiHuiBaoSeller
//
//  Created by Jekity on 2017/9/21.
//  Copyright © 2017年 Jekity. All rights reserved.
//

#import "MUCameraAndPhotosManager.h"
#import "MUCameraAndPhotosObject.h"

@implementation MUCameraAndPhotosManager
+(void)pickImageControllerPresentIn:(UIViewController *)controller selectedImage:(void (^)(UIImage *))selectedImage{
    
    [[[MUCameraAndPhotosObject alloc]init] pickImageControllerPresentIn:controller selectedImage:selectedImage];
}
+(void)takePhotoControllerPresentIn:(UIViewController *)controller selectedImage:(void (^)(UIImage *))selectedImage{
    [[[MUCameraAndPhotosObject alloc]init] takePhotoControllerPresentIn:controller selectedImage:selectedImage];
}
@end
