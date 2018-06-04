//
//  MURefreshHeaderStyleComponent.h
//  MUKit
//
//  Created by Jekity on 2018/6/4.
//

#import "MURefreshHeaderComponent.h"
#import "MUReplicatorLayer.h"

@interface MURefreshHeaderStyleComponent : MURefreshHeaderComponent

@property (assign, nonatomic) MUReplicatorLayerAnimationStyle animationStyle;

@property (nonatomic,strong) UIColor *styleColor;
@end
