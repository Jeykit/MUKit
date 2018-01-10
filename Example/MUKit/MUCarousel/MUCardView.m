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

@implementation MUCardView{
    CGFloat _dragStartX;
    
    CGFloat _dragEndX;
}

-(instancetype)initWithFrame:(CGRect)frame modelArray:(NSArray *)array cellNibName:(NSString *)name{
    if (self = [super initWithFrame:frame]) {
    
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
//    self.collectionView.scrollEnabled = self.scrollEnabled;
    self.collectionView.pagingEnabled = YES;
    [self addSubview:self.collectionView];
    
    [self.collectionView reloadData];
    
}

#pragma mark -collection delegate/datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
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
//    if (indexPath.row == indexpathNew.row)
//    {
//        //点击了中间的广告
//          id object = self.modelArray[indexPath.row];
//        if (self.muDidClickItem) {
//            self.muDidClickItem(indexPath.row,object);
//        }
//    }
//    else
//    {
//        if (self.autoScrollDirection == MUViewScrollDirectionHorizontal) {
//            //点击了背后的广告，将会被移动上来
//            [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
//        }else{
//            [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
//        }
//        
//    }
}
#pragma mark CollectionDelegate
//配置cell居中
- (void)fixCellToCenter {
    //最小滚动距离
    float dragMiniDistance = self.bounds.size.width/20.0f;
    if (_dragStartX -  _dragEndX >= dragMiniDistance) {
        _selectedIndex -= 1;//向右
    }else if(_dragEndX -  _dragStartX >= dragMiniDistance){
        _selectedIndex += 1;//向左
    }
    NSInteger maxIndex = [_collectionView numberOfItemsInSection:0] - 1;
    _selectedIndex = _selectedIndex <= 0 ? 0 : _selectedIndex;
    _selectedIndex = _selectedIndex >= maxIndex ? maxIndex : _selectedIndex;
    [self scrollToCenter];
}

//滚动到中间
- (void)scrollToCenter {
    
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
//    [self performDelegateMethod];
}

#pragma mark -
//在不使用分页滚动的情况下需要手动计算当前选中位置 -> _selectedIndex
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_pagingEnabled) {return;}
    if (!_collectionView.visibleCells.count) {return;}
    if (!scrollView.isDragging) {return;}
    CGRect currentRect = _collectionView.bounds;
    currentRect.origin.x = _collectionView.contentOffset.x;
    for (UICollectionViewCell *card in _collectionView.visibleCells) {
        if (CGRectContainsRect(currentRect, card.frame)) {
            NSInteger index = [_collectionView indexPathForCell:card].row;
            if (index != _selectedIndex) {
                _selectedIndex = index;
            }
        }
    }
}

//手指拖动开始
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _dragStartX = scrollView.contentOffset.x;
}

//手指拖动停止
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!_pagingEnabled) {return;}
    _dragEndX = scrollView.contentOffset.x;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self fixCellToCenter];
    });
}
@end
