//
//  MURefreshHeaderComponent.h
//  Pods
//
//  Created by Jekity on 2017/8/30.
//
//

#import <UIKit/UIKit.h>

@interface MURefreshHeaderComponent : UIView
@property(nonatomic, copy)void(^callback)(MURefreshHeaderComponent *refresh);
@property(nonatomic, strong)UIImage *backgroundImage;
-(instancetype)initWithFrame:(CGRect)frame callback:(void(^)(MURefreshHeaderComponent *refresh))callback;
-(void)startRefresh;
-(void)endRefreshing;
@end
