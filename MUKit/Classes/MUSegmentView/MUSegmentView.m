//
//  MUSegmentView.m
//  ZPApp
//
//  Created by Jekity on 2018/9/18.
//  Copyright © 2018年 Jekity. All rights reserved.
//

#import "MUSegmentView.h"


@interface MUSegmentScrollView : UIScrollView

@property (nonatomic,assign) NSUInteger maxinumCount;

@property (nonatomic,assign) NSUInteger totalCount;

@property (nonatomic,assign) MUSegmentOrganiseMode organiseMode;

@property (nonatomic,assign) CGFloat segmentWidthOrHeight;

@property (nonatomic,assign) CGFloat dividerWidth;

@property (nonatomic,strong) UIColor *dividerColour;
@end

@implementation MUSegmentScrollView

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    if (_totalCount > _maxinumCount) {
        return;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawDividerWithContext:context];
}

- (void)drawDividerWithContext:(CGContextRef) context{
    
    if (_totalCount > 1) {
        
        if (self.organiseMode == MUSegmentOrganiseModeHorizontal) {
            CGFloat originX = _segmentWidthOrHeight + _dividerWidth/2.;
            
            for (NSUInteger index = 1; index < _totalCount; index ++) {
                CGContextMoveToPoint(context, originX, 0.);
                CGContextAddLineToPoint(context, originX, self.frame.size.height);
                originX += _segmentWidthOrHeight + _dividerWidth;
            }
            
        }
        else {
            CGFloat originY  = _segmentWidthOrHeight + _dividerWidth/2.0;
            for (NSUInteger index = 1; index < _totalCount; index ++) {
                CGContextMoveToPoint(context, 0., originY);
                CGContextAddLineToPoint(context, self.frame.size.width, originY);
                originY += _segmentWidthOrHeight + _dividerWidth;
            }
            
        }
        [_dividerColour setStroke];
        CGContextSetLineWidth(context, _dividerWidth);
        CGContextDrawPath(context,kCGPathStroke);
        
    }
    
}
@end



@interface MUSegmentView()<UIScrollViewDelegate>
@property (nonatomic,weak) MUSegment *selectedSegment;
@property (nonatomic,strong) NSMutableArray *segmentsArray;

@end
@implementation MUSegmentView{
    
    MUSegmentScrollView *_scrollView;
    UIColor * _dividerColour;
    CGFloat _dividerWidth ;
}

- (NSInteger)selectedSegmentIndex{
    
    if (self.selectedSegment) {
      return  self.selectedSegment.tag;
    }
    return UISegmentedControlNoSegment;
}

- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex{
    
    if (selectedSegmentIndex >= 0 && selectedSegmentIndex < self.segmentsArray.count) {
        [self deselectSegment];
        MUSegment *currentSegment = self.segmentsArray[selectedSegmentIndex];
        [self selectSegment:currentSegment];
//        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _dividerColour = [UIColor lightGrayColor];
        _dividerWidth = 1.;
        [self customizer];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame dividerColor:(UIColor *)dividerColor dividerWidth:(CGFloat)dividerWidth{
    if (self = [super initWithFrame:frame]) {
        _dividerColour = dividerColor;
        _dividerWidth = 0;
       [self customizer];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self =  [super initWithCoder:aDecoder]) {
        _dividerColour = [UIColor lightGrayColor];
        _dividerWidth = 1.;
        [self customizer];
    }
    return self;
   
    
}

- (void)customizer{
    self.backgroundColor = [UIColor clearColor];
    self.layer.masksToBounds = YES;
    
    _organiseMode = MUSegmentOrganiseModeHorizontal;
    
    _segmentsArray = [NSMutableArray array];
    _maxinumCount = 5;
    
    _scrollView = [[MUSegmentScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.dividerWidth = _dividerWidth;
    _scrollView.dividerColour = _dividerColour;
    _scrollView.maxinumCount = _maxinumCount;
    
    [self addSubview:_scrollView];
}
- (void)selectSegment:(MUSegment *)segment{
    segment.selected = YES;
    self.selectedSegment = segment;
    [self adjusterSegment:segment];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)adjusterSegment:(MUSegment *)segment{
    NSUInteger currentPageNumber = segment.tag;
    NSUInteger totalCount = self.segmentsArray.count;
    if (totalCount > _maxinumCount) {
        if (self.organiseMode == MUSegmentOrganiseModeHorizontal) {
            CGFloat width = segment.frame.size.width;
            CGFloat offsetX = 0;
            if (currentPageNumber >= 2) {
                if (currentPageNumber <= totalCount - 3) {
                    offsetX = (currentPageNumber - 2) * width;
                }
                else {
                    if (currentPageNumber == totalCount - 2) {
                        offsetX = (currentPageNumber - 3) * width;
                    }else {
                        offsetX = (currentPageNumber - 4) * width;
                    }
                }
            }
            else {
                if (currentPageNumber == 1) {
                    offsetX = 0 * width;
                }else {
                    offsetX = currentPageNumber * width;
                }
            }
            [_scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
        }else{
            CGFloat height = segment.frame.size.height;
            CGFloat offsetY = 0;
            if (currentPageNumber >= 2) {
                if (currentPageNumber <= totalCount - 3) {
                    offsetY = (currentPageNumber - 2) * height;
                }
                else {
                    if (currentPageNumber == totalCount - 2) {
                        offsetY = (currentPageNumber - 3) * height;
                    }else {
                        offsetY = (currentPageNumber - 4) * height;
                    }
                }
            }
            else {
                if (currentPageNumber == 1) {
                    offsetY = 0 * height;
                }else {
                    offsetY = currentPageNumber * height;
                }
            }
            [_scrollView setContentOffset:CGPointMake(0, offsetY) animated:YES];
        }
    }
}
- (void)deselectSegment{
    self.selectedSegment.selected = NO;
    self.selectedSegment = nil;
}
- (void)addSegmentWithSegment:(MUSegment *)segment{
    
    [self insertSegmentWithSegment:segment index:self.segmentsArray.count];
}

- (void)insertSegmentWithSegment:(MUSegment *)segment index:(NSUInteger)index{
    
    segment.tag = index;
    
    __weak typeof(self)weakSelf = self;
    segment.didSelectSegment = ^(MUSegment *segmentmu){
        __strong typeof(weakSelf)self = weakSelf;
        
        if (self.selectedSegment != segmentmu) {
            
            [self deselectSegment];
            [self selectSegment:segmentmu];
        }
    };
    
    [self resetSegmentIndicesWithIndex:index by:1];
    [self.segmentsArray insertObject:segment atIndex:index];
    [_scrollView addSubview:segment];
}

- (void)removeSegmentAtIndex:(NSUInteger)index{
    NSAssert(index >= 0 && index < self.segmentsArray.count, @"Index (\(index)) is out of range");
    if (index == self.selectedSegmentIndex) {
        self.selectedSegmentIndex = UISegmentedControlNoSegment;
    }
    [self resetSegmentIndicesWithIndex:index by:-1];
    
    MUSegment *segment = [self.segmentsArray objectAtIndex:index];
    [self.segmentsArray removeObjectAtIndex:index];
    [segment removeFromSuperview];
    [self updateSegmentsLayout];
}

- (void)resetSegmentIndicesWithIndex:(NSInteger)index by:(NSUInteger)by{
    
    if (index < self.segmentsArray.count) {
        for (MUSegment *segment in self.segmentsArray) {
            segment.tag += by;
        }
    }
}

// MARK: UI
// MARK: Update layout
- (void)layoutSubviews{
    [super layoutSubviews];
    [self updateSegmentsLayout];
}

- (void)updateSegmentsLayout{
    
    if (self.segmentsArray.count == 0) {
        return;
    }
    if (self.segmentsArray.count > 1) {
        if (self.organiseMode == MUSegmentOrganiseModeHorizontal) {
            
            CGFloat segmentWidth =0.0;
            if (self.segmentsArray.count > _maxinumCount) {
                segmentWidth = ceil((self.frame.size.width - _dividerWidth * (_maxinumCount-1)) / _maxinumCount);
            }else{
                segmentWidth = ceil((self.frame.size.width - _dividerWidth * (self.segmentsArray.count-1)) / self.segmentsArray.count);
            }
            _scrollView.organiseMode = MUSegmentOrganiseModeHorizontal;
            _scrollView.totalCount = self.segmentsArray.count;
            _scrollView.segmentWidthOrHeight = segmentWidth;
            
            _scrollView.contentSize = CGSizeMake(segmentWidth * self.segmentsArray.count, self.frame.size.height);
            CGFloat originX = 0.0;
            for (MUSegment *segment in self.segmentsArray) {
                segment.frame = CGRectMake(originX, 0.0, segmentWidth, self.frame.size.height);
                originX += segmentWidth + _dividerWidth;
            }
            
        }
        else {
            
            CGFloat segmentHeight = ceil((self.frame.size.height - _dividerWidth * (self.segmentsArray.count-1)) / self.segmentsArray.count);

            _scrollView.organiseMode = MUSegmentOrganiseModeVertical;
            _scrollView.totalCount = self.segmentsArray.count;
            _scrollView.segmentWidthOrHeight = segmentHeight;
            
             _scrollView.contentSize = CGSizeMake(0,self.segmentsArray.count * segmentHeight);
            CGFloat originY = 0.0;
            for (MUSegment *segment in self.segmentsArray) {
                segment.frame = CGRectMake(0.0, originY, self.frame.size.width,segmentHeight);
                originY += segmentHeight + _dividerWidth;
            }
        }
    }else{
        
        MUSegment *segment = self.segmentsArray[0];
        segment.frame =CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height);
    }
    
    [self setNeedsDisplay];
}

//- (void)drawRect:(CGRect)rect{
//    [super drawRect:rect];
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    [self drawDividerWithContext:context];
//}
//
//- (void)drawDividerWithContext:(CGContextRef) context{
//
//    if (self.segmentsArray.count > 1) {
//
//        if (self.organiseMode == MUSegmentOrganiseModeHorizontal) {
//            MUSegment *segment = self.segmentsArray[0];
//            CGFloat originX = segment.frame.size.width + _dividerWidth/2.;
//
//            for (NSUInteger index = 1; index < self.segmentsArray.count; index ++) {
//                MUSegment *segmentmu = self.segmentsArray[index];
//                CGContextMoveToPoint(context, originX, 0.);
//                CGContextAddLineToPoint(context, originX, self.frame.size.height);
//                originX += segmentmu.frame.size.width + _dividerWidth;
//            }
//
//        }
//        else {
//            MUSegment *segment = self.segmentsArray[0];
//            CGFloat originY  = segment.frame.size.height + _dividerWidth/2.0;
//            for (NSUInteger index = 1; index < self.segmentsArray.count; index ++) {
//                MUSegment *segmentmu = self.segmentsArray[index];
//                CGContextMoveToPoint(context, 0., originY);
//                CGContextAddLineToPoint(context, self.frame.size.width, originY);
//                originY += segmentmu.frame.size.height + _dividerWidth;
//            }
//
//        }
//        [_dividerColour setStroke];
//        CGContextSetLineWidth(context, _dividerWidth);
//        CGContextDrawPath(context,kCGPathStroke);
//
//    }
//
//}

#pragma mark -scroll delegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//
//
//}

@end

