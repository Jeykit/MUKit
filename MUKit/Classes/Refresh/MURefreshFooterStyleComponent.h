//
//  MURefreshFooterStyleComponent.h
//  MUKit
//
//  Created by Jekity on 2018/6/4.
//

#import "MURefreshFooterComponent.h"
#import "MUReplicatorLayer.h"

@interface MURefreshFooterStyleComponent : MURefreshFooterComponent

@property (assign, nonatomic) MUReplicatorLayerAnimationStyle animationStyle;
@property (nonatomic,strong) UIColor *styleColor;
@end
