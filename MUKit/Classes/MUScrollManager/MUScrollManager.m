//
//  MUScrollManager.m
//  ZPWApp_Example
//
//  Created by Jekity on 2018/5/28.
//  Copyright © 2018年 Jekity. All rights reserved.
//

#import "MUScrollManager.h"
#import "MUMultiDelegate.h"
#import <MUHookMethodHelper.h>



@interface MUScrollManager()<UIScrollViewDelegate>

@property (nonatomic,weak) UIScrollView *originalScrollView;

@property (nonatomic,weak) UIScrollView *nestedScrollView;

@property (nonatomic,weak) UIScrollView *previousNestedScrollView;
//@property (nonatomic,strong) MUMultiDelegate *multiDelegate;
@property (nonatomic,assign) BOOL arrivedTop;
@property (nonatomic,strong) NSHashTable *hashTable;
@end

static  MUMultiDelegate *multiDelegate = nil;
static __weak  UIScrollView *oriScrollView = nil;
static __weak  UIScrollView *netScrollView = nil;

@implementation MUScrollManager
+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [MUHookMethodHelper muHookMethod:NSStringFromClass([UIScrollView class]) orignalSEL:@selector(setDelegate:) newClassName:NSStringFromClass([self class]) newSEL:@selector(setMuDelegate:)];
        multiDelegate = [[MUMultiDelegate alloc] init];
    });
}
-(instancetype)initWithScrollView:(UIScrollView *)scrollView nestedScrollView:(UIScrollView *)nestScrollView offset:(CGFloat)offset{
    if (self = [super init]) {
        self.originalScrollView = scrollView;
        oriScrollView = scrollView;
        self.nestedScrollView  = nestScrollView;
        self.nestScrollViewMU  = nestScrollView;
        self.previousNestedScrollView = nestScrollView;
        netScrollView = nestScrollView;
        self.offsetMU = offset;
        [multiDelegate addDelegate:self];
        scrollView.delegate = (id)multiDelegate;
        nestScrollView.delegate = (id)multiDelegate;
    }
    
    return self;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-pointer-types"

-(void)setMuDelegate:(id)delegate{
   
    if ( [self isEqual:oriScrollView]|| [self isEqual:netScrollView]) {
        if (multiDelegate) {
            
            if (delegate != multiDelegate) {
                [multiDelegate addDelegate:delegate];
            }
            [self setMuDelegate:(id)multiDelegate];
        }else{
            
            [self setMuDelegate:delegate];
        }
    }else{
        [self setMuDelegate:delegate];
    }
    
}

#pragma clang diagnostic pop
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.nestScrollViewMU) {
        if (!self.arrivedTop) {//没有到达顶部
            scrollView.contentOffset = CGPointZero;
        }
        if (scrollView.contentOffset.y < 0) {
            scrollView.contentOffset = CGPointZero;
            self.arrivedTop = NO;
        }
    }
    
    if (scrollView == self.originalScrollView) {
        if (scrollView.contentOffset.y >= self.offsetMU) {//到达顶部，可以滚动
            scrollView.contentOffset = CGPointMake(0, self.offsetMU);
            self.arrivedTop = YES;//到达顶部
        }else{
            
            if(self.arrivedTop&&self.nestScrollViewMU.contentSize.height>CGRectGetHeight(self.nestScrollViewMU.bounds)+self.marginHeight) {
                scrollView.contentOffset = CGPointMake(0, self.offsetMU);
            }
        }
    }
}

-(void)setNestScrollViewMU:(UIScrollView *)nestScrollViewMU{
    _nestScrollViewMU = nestScrollViewMU;
    self.nestedScrollView = _nestScrollViewMU;
    if (nestScrollViewMU&&nestScrollViewMU.delegate != multiDelegate) {
        [multiDelegate addDelegate:nestScrollViewMU.delegate];
        nestScrollViewMU.delegate =  (id)multiDelegate;
    }
}
-(void)dealloc{
    multiDelegate = nil;
}
@end
