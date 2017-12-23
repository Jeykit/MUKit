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
///2D时自动计算linespacing的倍数
#define MU_AUTO_SET_LINESPACING_RATIO 0.15
///不使用3D缩放  >0起效
#define MU_NO_3D -1
///最小的行间距 如果不足够大，会出现两行的情况
#define MU_DEFAULT_MINIMUMINTERITEMSPACING 10000
///轮播两侧准备的item倍数 count of prepared item group at the both side
#define MU_ITEM_TIME 2

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
@end

@implementation MUCardView

-(instancetype)initWithFrame:(CGRect)frame modelArray:(NSArray *)array cellNibName:(NSString *)name{
    if (self = [super initWithFrame:frame]) {
        _allowedInfinite = YES;
        _scrollEnabled    = YES;
        _dataArray        = array;
        _autoScrollDirection = MUViewScrollDirectionLeft;
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
        _autoScrollDirection = MUViewScrollDirectionLeft;
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
    _flowLayout.currentIndex = self.allowedInfinite?self.dataArray.count*MU_ITEM_TIME:-1;
    if(self.autoScrollDirection>1){
        CGFloat y_inset =(self.frame.size.height-itemSize.height) / 2.f;
        _flowLayout.sectionInset = UIEdgeInsetsMake(y_inset,0,y_inset,0);
    }else{
        CGFloat x_inset =(self.frame.size.width-itemSize.width) / 2.f;
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, x_inset, 0, x_inset);
    }
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
-(void)setAutoScrollDirection:(MUViewScrollDirection)autoScrollDirection{
    _autoScrollDirection = autoScrollDirection;
    if (autoScrollDirection > 1) {
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
            offet = (CGPoint){(self.flowLayout.itemSize.width+self.flowLayout.minimumLineSpacing)*(self.dataArray.count)*MU_ITEM_TIME,0};
        }else{
            offet = (CGPoint){0,(self.flowLayout.itemSize.height+self.flowLayout.minimumLineSpacing)*(self.dataArray.count)*MU_ITEM_TIME};
        }
        
        [self.collectionView setContentOffset:offet];
    }
}
-(void)configuredCollectionView:(MUCardLayout *)layout{
    
    NSArray *dataArray = @[];
    if (!self.allowedInfinite) {
        if (self.dataArray) {
            self.modelArray = [NSMutableArray arrayWithArray:self.dataArray];
        }
    }else{//无限轮播
        if (self.dataArray && self.dataArray.count>0) {
            for (int i=0;i<2*MU_ITEM_TIME+1;i++) {
                dataArray = [dataArray arrayByAddingObjectsFromArray:self.dataArray];
            }
        }
        self.modelArray = [NSMutableArray arrayWithArray:dataArray];
    }
   
 
    if(self.autoScrollDirection>1){
        CGFloat y_inset =(self.frame.size.height-layout.itemSize.height) / 2.f;
        layout.sectionInset = UIEdgeInsetsMake(y_inset,0,y_inset,0);
    }else{
        CGFloat x_inset =(self.frame.size.width-layout.itemSize.width) / 2.f;
        layout.sectionInset = UIEdgeInsetsMake(0, x_inset, 0, x_inset);
    }
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
    self.collectionView.decelerationRate = 0;
    self.collectionView.scrollEnabled = self.scrollEnabled;
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
    return self.modelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *resultCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReusedIndentifier forIndexPath:indexPath];
    id object = self.modelArray[indexPath.row];
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

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self _secretlyChangeIndex];
   
}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self _secretlyChangeIndex];
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
   
}

-(void)_secretlyChangeIndex{
    if (!self.allowedInfinite)return;
    CGPoint pInUnderView = [self convertPoint:self.collectionView.center toView:self.collectionView];
    // 获取中间的indexpath
    NSIndexPath *indexpath = [self.collectionView indexPathForItemAtPoint:pInUnderView];
    NSInteger itemCount =self.dataArray.count;
    if (indexpath.row<itemCount*MU_ITEM_TIME || indexpath.row>=itemCount*(MU_ITEM_TIME+1)) {
        NSIndexPath *to_indexPath =[NSIndexPath indexPathForRow:indexpath.row%itemCount+itemCount*MU_ITEM_TIME inSection:0];
        if (self.autoScrollDirection>1) {
            [self.collectionView scrollToItemAtIndexPath:to_indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
        }else{
            [self.collectionView scrollToItemAtIndexPath:to_indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        }
    }
}

@end
