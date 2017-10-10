//
//  MUCameraAndPhotosManager.h
//  ZhaoCaiHuiBaoSeller
//
//  Created by Jekity on 2017/9/21.
//  Copyright © 2017年 Jekity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MUCameraAndPhotosManager : NSObject
+(void)pickImageControllerPresentIn:(UIViewController *)controller selectedImage:(void(^)(UIImage *image))selectedImage;
+(void)takePhotoControllerPresentIn:(UIViewController *)controller selectedImage:(void(^)(UIImage *image))selectedImage;
@end
