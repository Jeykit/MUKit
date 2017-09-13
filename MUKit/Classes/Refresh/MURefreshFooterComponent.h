//
//  MURefreshFooterComponent.h
//  Pods
//
//  Created by Jekity on 2017/9/1.
//
//

#import <UIKit/UIKit.h>

@interface MURefreshFooterComponent : UIView
@property(nonatomic, copy)void(^callback)(MURefreshFooterComponent *refresh);
@property(nonatomic, strong)UIImage *backgroundImage;
-(instancetype)initWithFrame:(CGRect)frame callback:(void(^)(MURefreshFooterComponent *refresh))callback;
@property(nonatomic, assign ,getter=isRefresh)BOOL refresh;//是否正在刷新
-(void)startRefresh;
-(void)endRefreshing;
-(void)noMoreData;
@end
