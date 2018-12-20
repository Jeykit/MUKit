//
//  UIImageView+MUCache.m
//  MUKit_Example
//
//  Created by Jekity on 2018/12/19.
//  Copyright © 2018 Jeykit. All rights reserved.
//

#import "UIImageView+MUCache.h"
#import "MUImageCacheManager.h"
#import <objc/message.h>

@implementation UIImageView (MUCache)

- (void)setIconURLString:(NSString *)imageURLString{
    
    [self setIconURLString:imageURLString
      placeHolderImageName:nil];
}

- (void)setIconURLString:(NSString *)imageURLString
    placeHolderImageName:(NSString *)imageName{
    
    [self setIconURLString:imageURLString
      placeHolderImageName:imageName
              cornerRadius:0];
}

- (void)setIconURLString:(NSString *)imageURLString
    placeHolderImageName:(NSString *)imageName
            cornerRadius:(CGFloat)cornerRadius{
    
    NSParameterAssert(imageURLString != nil);
    
    NSString* renderer = objc_getAssociatedObject(self, @selector(setIconURLString:placeHolderImageName:cornerRadius:));
    if (renderer && [renderer isEqualToString:imageURLString]) {
        
        return ;
    }
    objc_setAssociatedObject(self, @selector(setIconURLString:placeHolderImageName:cornerRadius:), imageURLString, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
     __weak typeof(self)weakSelf = self;
    [[MUImageCacheManager sharedInstance] asyncGetIconWithURLString:imageURLString
                                               placeHolderImageName:imageName
                                                           drawSize:self.bounds.size
                                                       cornerRadius:cornerRadius
                                                          completed:^(NSString *key, UIImage *image, NSString *filePath) {
                                                              
                                                              __strong typeof(weakSelf)self = weakSelf; 
                                                               NSString* renderer = objc_getAssociatedObject(self, @selector(setIconURLString:placeHolderImageName:cornerRadius:));
                                                              if (renderer && [renderer isEqualToString:key]) {
                                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                                      self.image = image;
                                                                      [self setNeedsDisplay];
                                                                  });
                                                              }
        
    }];
 
                                                            
}

- (void)setImageURLString:(NSString *)imageURLString{
    
    [self setImageURLString:imageURLString placeHolderImageName:nil];
}

- (void)setImageURLString:(NSString *)imageURLString
     placeHolderImageName:(NSString *)imageName{
    
    [self setImageURLString:imageURLString placeHolderImageName:imageName cornerRadius:0];
}

- (void)setImageURLString:(NSString *)imageURLString
     placeHolderImageName:(NSString *)imageName
             cornerRadius:(CGFloat)cornerRadius{
    
    
      NSParameterAssert(imageURLString != nil);
    
     NSString* renderer = objc_getAssociatedObject(self, @selector(setImageURLString:placeHolderImageName:cornerRadius:));
    if (renderer && [renderer isEqualToString:imageURLString]) {
        
        return ;
    }
    objc_setAssociatedObject(self, @selector(setImageURLString:placeHolderImageName:cornerRadius:), imageURLString, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
   

    __weak typeof(self)weakSelf = self;
    [[MUImageCacheManager sharedInstance] asyncGetImageWithURLString:imageURLString
                                                placeHolderImageName:imageName
                                                           drawSize:self.bounds.size
                                                        cornerRadius:cornerRadius
                                                           completed:^(NSString *key, UIImage *image, NSString *filePath) {
                                                               __strong typeof(weakSelf)self = weakSelf;
                                                               
                                                               NSString* renderer = objc_getAssociatedObject(self, @selector(setImageURLString:placeHolderImageName:cornerRadius:));
                                                               if (renderer && [renderer isEqualToString:key]) {
                                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                                       self.image = image;
                                                                       [self setNeedsDisplay];
                                                                   });
                                                               }
                                                               
                                                           }];
}
@end
