//
//  MUCardView.m
//  AFNetworking
//
//  Created by Jekity on 2017/12/23.
//

#import "MUCardView.h"
#import "MUCardLayout.h"


///默认的自动轮播的时间间隔
#define MU_DEFAULT_TIME 2.0

///轮播两侧准备的item倍数 count of prepared item group at the both side
#define MU_ITEM_TIME 50

static NSString * const cellReusedIndentifier = @"cell";
@interface MUCardView()<UICollectionViewDelegate,UICollectionViewDataSource>
/**
 *   collection
 */
@property (nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic, strong)NSMutableArray *modelArray;
@property(nonatomic, strong)NSString *nibName;
@property(nonatomic, strong)NSString *cellClassName;
@property(nonatomic, strong)MUCardLayout *flowLayout;
@property (nonatomic,strong)NSArray *dataArray;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation MUCardView

-(instancetype)initWithFrame:(CGRect)frame modelArray:(NSArray *)array cellNibName:(NSString *)name{
    if (self = [super initWithFrame:frame]) {
        _allowedInfinite = YES;
        _scrollEnabled    = YES;
        _dataArray        = array;
        _autoScrollDirection = MUViewScrollDirectionHorizontal;
        _nibName          = name;
        MUCardLayout *layout = [[MUCardLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout = layout;
        [self configuredCollectionView:layout];
        
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame modelArray:(NSArray *)array cellClassName:(NSString *)cellClassName{
    if (self = [super initWithFrame:frame]) {
        _allowedInfinite = YES;
        _scrollEnabled    = YES;
        _dataArray        = array;
        _autoScrollDirection = MUViewScrollDirectionHorizontal;
        _cellClassName          = cellClassName;
        MUCardLayout *layout = [[MUCardLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout = layout;
        
        [self configuredCollectionView:layout];
        
    }
    return self;
}

#pragma mark -setter
-(void)setItemAlpha:(CGFloat)itemAlpha{
    _itemAlpha = itemAlpha;
    self.flowLayout.itemAlpha = itemAlpha;
}
-(void)setItemSize:(CGSize)itemSize{
    _itemSize = itemSize;
    self.flowLayout.itemSize = itemSize;
}

-(void)setMinimumLineSpacing:(CGFloat)minimumLineSpacing{
    _minimumLineSpacing = minimumLineSpacing;
    self.flowLayout.minimumLineSpacing = minimumLineSpacing;
}
-(void)setMinimumInteritemSpacing:(CGFloat)minimumInteritemSpacing{
    _minimumInteritemSpacing = minimumInteritemSpacing;
    self.flowLayout.minimumInteritemSpacing = minimumInteritemSpacing;
}

-(void)setScrollEnabled:(BOOL)scrollEnabled{
    _scrollEnabled = scrollEnabled;
    self.collectionView.scrollEnabled = scrollEnabled;
}
-(void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
    self.flowLayout.currentIndex = currentIndex;
}
- (void)stopTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
- (void)beginTimer {
    [self stopTimer];
    if (@available(iOS 10.0, *)) {
        self.timer = [NSTimer timerWithTimeInterval:MU_DEFAULT_TIME repeats:YES block:^(NSTimer * _Nonnull timer) {
            //首先 切换至最中间一组，然后再滚动到下一张，避免长时间滚动造成滚动到最后一张
            [self timerAction];
            
        }];
         [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    } else {
        // Fallback on earlier versions
        self.timer = [NSTimer scheduledTimerWithTimeInterval:MU_DEFAULT_TIME target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
//         [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
   
}
-(void)timerAction{
    //首先 切换至最中间一组，然后再滚动到下一张，避免长时间滚动造成滚动到最后一张
    CGPoint pointInView = [self convertPoint:self.collectionView.center toView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:pointInView];
    NSIndexPath *beginIndexPath = [NSIndexPath indexPathForItem:indexPath.item % self.dataArray.count + self.dataArray.count * 50 inSection:indexPath.section];
    [self.collectionView scrollToItemAtIndexPath:beginIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:beginIndexPath.item + 1 inSection:beginIndexPath.section];
    [self.collectionView scrollToItemAtIndexPath:newIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}
-(void)setAutoScrollEnabled:(BOOL)autoScrollEnabled{
    _autoScrollEnabled = autoScrollEnabled;
    if (autoScrollEnabled&&_allowedInfinite) {
        [self beginTimer];
    }
}
-(void)setAutoScrollDirection:(MUViewScrollDirection)autoScrollDirection{
    _autoScrollDirection = autoScrollDirection;
    if (autoScrollDirection == MUViewScrollDirectionVertical) {
        self.flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
}
-(void)setThreeDimensionalScale:(CGFloat)threeDimensionalScale{
    _threeDimensionalScale = threeDimensionalScale;
    self.flowLayout.threeDimensionalScale = threeDimensionalScale;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    if(self.allowedInfinite){
        CGPoint offet;
        if (self.autoScrollDirection<=1) {
            offet = (CGPoint){(self.itemSize.width+self.minimumInteritemSpacing)*(self.dataArray.count)*MU_ITEM_TIME,0};
        }else{
            offet = (CGPoint){0,(self.itemSize.height+self.minimumInteritemSpacing)*(self.dataArray.count)*MU_ITEM_TIME};
        }
        
        [self.collectionView setContentOffset:offet];
    }
}
-(void)configuredCollectionView:(MUCardLayout *)layout{
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:(CGRect){0,0,self.frame.size} collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    if (self.nibName.length > 0) {
        
        [self.collectionView registerNib:[UINib nibWithNibName:_nibName bundle:nil] forCellWithReuseIdentifier:cellReusedIndentifier];
    }
    if (self.cellClassName) {
        [self.collectionView registerClass:NSClassFromString(self.cellClassName) forCellWithReuseIdentifier:cellReusedIndentifier];
    }
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = self.scrollEnabled;
    [self addSubview:self.collectionView];
    
    [self.collectionView reloadData];
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.modelArray.count * MU_ITEM_TIME  inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

#pragma mark -collection delegate/datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count*100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *resultCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReusedIndentifier forIndexPath:indexPath];
    id object = self.dataArray[indexPath.item % self.dataArray.count];
    if (self.renderBlock) {
        self.renderBlock(resultCell, indexPath, object);
    }
    return resultCell;

}

// 点击item的时候
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGPoint pInUnderView = [self convertPoint:collectionView.center toView:collectionView];
    
    // 获取中间的indexpath
    NSIndexPath *indexpathNew = [collectionView indexPathForItemAtPoint:pInUnderView];
    NSLog(@"%ld",indexpathNew.row);
    if (indexPath.row == indexpathNew.row)
    {
        //点击了中间的广告
          id object = self.modelArray[indexPath.row];
        if (self.muDidClickItem) {
            self.muDidClickItem(indexPath.row,object);
        }
    }
    else
    {
        if (self.autoScrollDirection<1) {
            //点击了背后的广告，将会被移动上来
            [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        }else{
            [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
        }
        
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //每次拖拽完成后，自动重置到中间一组，避免多次拖拽造成滚动到最后一张
    if (self.allowedInfinite) {
        CGPoint pointInView = [self convertPoint:self.collectionView.center toView:self.collectionView];
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:pointInView];
        NSIndexPath *beginIndexPath = [NSIndexPath indexPathForItem:indexPath.item % self.dataArray.count + self.dataArray.count * MU_ITEM_TIME inSection:indexPath.section];
        [self.collectionView scrollToItemAtIndexPath:beginIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        [self beginTimer];
    }
    //拖拽完成后，重启自动滚动
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //开始拖拽时 停止timer，避免拖拽时间过长造成的停止拖拽瞬间滚动到下一张
    [self stopTimer];
}
@end
