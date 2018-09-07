//
//  MUAsyncDispalyLayer.h
//  MUAsyncDisplayLayer
//
//  Created by Jekity on 6/5/17.
//  Copyright © 2017年 Jekity. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>


@protocol MUAsyncDispalyLayerDelegate;
@interface MUAsyncDispalyLayer : CALayer

@property (nonatomic, assign) BOOL displaysAsynchronously;

@property (nonatomic,weak)id<MUAsyncDispalyLayerDelegate> asyncDelegate;

@property (nonatomic,assign,getter=isDisplaySuspended) BOOL displaySuspended;

+ (dispatch_queue_t)displayQueue;
@end

@protocol MUAsyncDispalyLayerDelegate <NSObject>
@optional
-(void)willDisplayAsyncLayer:(MUAsyncDispalyLayer *)asyncLayer asynchously:(BOOL)asynchronously;

-(void)displayAsyncLayer:(MUAsyncDispalyLayer *)asyncLayer asynchously:(BOOL)asyncronously;
-(void)cancelDisplayAsyncLayer:(MUAsyncDispalyLayer *)asyncLayer;


@end
