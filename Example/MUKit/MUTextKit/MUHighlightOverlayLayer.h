//
//  MUHighlightOverlayLayer.h
//  MUAsyncDisplayLayer
//
//  Created by Jekity on 2018/9/7.
//  Copyright © 2018年 Jekity. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface MUHighlightOverlayLayer : CALayer

/**
 @summary Initializes with CGRects for the highlighting, in the targetLayer's coordinate space.
 
 @desc This is the designated initializer.
 
 @param rects Array containing CGRects wrapped in NSValue.
 @param targetLayer The layer that the rects are relative to.  The rects will be translated to the receiver's coordinate space when rendering.
 */
- (instancetype)initWithRects:(NSArray<NSValue *> *)rects targetLayer:(nullable CALayer *)targetLayer;

/**
 @summary Initializes with CGRects for the highlighting, in the receiver's coordinate space.
 
 @param rects Array containing CGRects wrapped in NSValue.
 */
- (instancetype)initWithRects:(NSArray<NSValue *> *)rects;

@property (nullable, nonatomic, strong) __attribute__((NSObject)) CGColorRef highlightColor;
@property (nonatomic, weak) CALayer *targetLayer;

@end


NS_ASSUME_NONNULL_END
