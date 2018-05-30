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
@property (nonatomic,strong) MUMultiDelegate *multiDelegate;
@property (nonatomic,assign) BOOL arrivedTop;
@property (nonatomic,strong) NSHashTable *hashTable;
@end

static __weak MUMultiDelegate *tempMultiDelegate = nil;
@implementation MUScrollManager
-(instancetype)initWithScrollView:(UIScrollView *)scrollView nestedScrollView:(UIScrollView *)nestScrollView offset:(CGFloat)offset{
    if (self = [super init]) {
        self.originalScrollView = scrollView;
        self.nestedScrollView  = nestScrollView;
        self.nestScrollViewMU  = nestScrollView;
        self.previousNestedScrollView = nestScrollView;
        self.offsetMU = offset;

        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [MUHookMethodHelper muHookMethod:NSStringFromClass([UIScrollView class]) orignalSEL:@selector(setDelegate:) newClassName:NSStringFromClass([self class]) newSEL:@selector(setMuDelegate:)];
            
        });
         _multiDelegate = [[MUMultiDelegate alloc] init];
        [_multiDelegate addDelegate:self];
        tempMultiDelegate = _multiDelegate;
        scrollView.delegate = (id)_multiDelegate;
        nestScrollView.delegate = (id)_multiDelegate;
    }
    
    return self;
}

-(void)setMuDelegate:(id)delegate{
    if (delegate != tempMultiDelegate) {
       
        [tempMultiDelegate addDelegate:delegate];
        
    }
    if (tempMultiDelegate) {
        
        [self setMuDelegate:(id)tempMultiDelegate];
    }else{
        [self setMuDelegate:delegate];
    }
}

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
    if (nestScrollViewMU&&nestScrollViewMU.delegate != tempMultiDelegate) {
        [tempMultiDelegate addDelegate:nestScrollViewMU.delegate];
        nestScrollViewMU.delegate =  (id)tempMultiDelegate;
    }
}
@end
