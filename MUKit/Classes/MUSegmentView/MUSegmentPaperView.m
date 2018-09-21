//
//  MUSegmentPaperView.m
//  ZPApp
//
//  Created by Jekity on 2018/9/18.
//  Copyright © 2018年 Jekity. All rights reserved.
//

#import "MUSegmentPaperView.h"
#import "MUSegmentView.h"


@interface MUSegmentPaperView()<UIScrollViewDelegate>

@property (nonatomic,strong) NSArray *viewsArray;
@property (nonatomic,strong) NSArray *segmentsArray;

@property (nonatomic,weak) UIViewController *weakViewController;
@property(nonatomic, assign)id lastObject;
@property(nonatomic, assign)id currentObject;
@property(nonatomic, strong)NSMutableArray *loadedArray;


@end

#define MaxNums  12 //Max limit number,recommand below 10.
@implementation MUSegmentPaperView{
    
    MUSegmentView *_segments;
    UIScrollView *_scrollView;
    BOOL _viewAlloc[MaxNums];
    CGFloat _topHeight;
}

- (instancetype)initWithFrame:(CGRect)frame withSegments:(NSArray *)segments withView:(nonnull NSArray *)objects{
    
    if (self = [super initWithFrame:frame]) {
        _viewsArray = [objects copy];
        _segmentsArray = [segments copy];
        _topHeight = 30.;
        _segments = [[MUSegmentView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, _topHeight)];
        [_segments addTarget:self action:@selector(segmentsValueChanged) forControlEvents:UIControlEventValueChanged];
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, _topHeight, frame.size.width, frame.size.height - _topHeight)];
        _scrollView.delegate  = self;
        [self addSubview:_segments];
        [self addSubview:_scrollView];
        
        [self addSegments:_segmentsArray];
        
        _loadedArray  = [NSMutableArray array];
    }
    return self;
}
- (void)addSegments:(NSArray *)array{
    if (array.count) {
        return;
    }
    for (MUSegment *segments in array) {
        [_segments addSegmentWithSegment:segments];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
      NSInteger currentPageNumber = (NSInteger)((scrollView.contentOffset.x + CGRectGetWidth(self.frame) / 2) / CGRectGetWidth(self.frame));
    for (NSUInteger number = 0; number < _viewsArray.count; number++) {
       
                if ([_viewsArray[currentPageNumber] isKindOfClass:[UIViewController class]]) {
                    UIViewController *ctrl = _viewsArray[currentPageNumber];
                    if (ctrl && _viewAlloc[currentPageNumber] == NO) {
                        [self createOtherViewControllers:ctrl WithControllerTag:currentPageNumber];
                    }else if (!ctrl) {
                        NSLog(@"Your Controller or View %li is not found in this project!",(long)currentPageNumber + 1);
                    }
                }else if ([_viewsArray[currentPageNumber] isKindOfClass:[UIView class]]) {
                    UIView *singleView = _viewsArray[currentPageNumber];
                    singleView.frame = CGRectMake(CGRectGetWidth(self.frame) * currentPageNumber, 0, CGRectGetWidth(self.frame), self.frame.size.height - _topHeight);
                    [_scrollView addSubview:singleView];
                }
            }
    

}

- (void)createOtherViewControllers:(UIViewController *)currentController WithControllerTag:(NSInteger)tag {
    if (!self.weakViewController) {
        
        self.weakViewController = [self getViewControllerFromCurrentView];
    }
    if (!self.weakViewController) {
        return;
    }
    [self.weakViewController addChildViewController:currentController];
    self.lastObject = self.currentObject;
    self.currentObject = currentController;
    [_loadedArray addObject:@{@"tag":@(tag),@"controller":currentController}];
#ifdef DEBUG
    NSLog(@"Use new created controller or view%li",(long)tag + 1);
#endif
    currentController.view.frame = CGRectMake(CGRectGetWidth(self.frame) * tag, 0, CGRectGetWidth(self.frame), self.frame.size.height - _topHeight);
    [_scrollView addSubview:currentController.view];
    _viewAlloc[tag] = YES;
}
-(UIViewController*)getViewControllerFromCurrentView{
    
    UIResponder *nextResponder = self.nextResponder;
    //     NSLog(@"%@",NSStringFromClass([nextResponder class]));
    while (nextResponder != nil) {
        
        
        if ([nextResponder isKindOfClass:[UINavigationController class]]) {
            self.weakViewController = nil;
            break;
        }
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
            break;
            
        }
        nextResponder = nextResponder.nextResponder;
    }
    return nil;
}
#pragma mark -action
- (void)segmentsValueChanged{
    
      [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.frame) * _segments.selectedSegmentIndex, 0) animated:YES];
}
@end
