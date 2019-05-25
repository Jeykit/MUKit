//
//  MUAdaptiveView.m
//  MUKit
//
//  Created by Jekity on 2017/12/20.
//

#import "MUAdaptiveView.h"
#import "MUAdaptiveViewCell.h"



static CGFloat margin = 64;
@interface MUAdaptiveView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic, strong)UICollectionView *collectionView;

@property(nonatomic, strong)UILabel *tipsLabel;

@property(nonatomic, strong)UICollectionViewFlowLayout *flowLayout;

@property (nonatomic,copy) void(^configuredImage)(UIImageView *imageView ,NSUInteger index ,id model);
@end

static NSString * const cellReusedIndentifier = @"MUAdaptiveViewCell";
@implementation MUAdaptiveView

- (instancetype)initWithFrame:(CGRect)frame configured:(void (^)(UIImageView *, NSUInteger, id))configured{
    if (self = [super initWithFrame:frame]) {
        _rowItemCount = 4.;
        _scrollDirection = UICollectionViewScrollDirectionVertical;
        _showTipsImage = YES;
        _configuredImage = configured;
        [self initCollectionView];
    }
    return self;
}
-(void)initCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 20.;
    _flowLayout = layout;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) collectionViewLayout:layout];
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.scrollEnabled = NO;
    [_collectionView registerClass:[MUAdaptiveViewCell class] forCellWithReuseIdentifier:cellReusedIndentifier];
    //上传图片提示
    [self addSubview:_collectionView];
}
-(void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection{
    _scrollDirection = scrollDirection;
    if (scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        _flowLayout.scrollDirection = scrollDirection;
        _collectionView.scrollEnabled = YES;
    }
}
- (UILabel *)tipsLabel{
    if (!_tipsLabel) {
        _tipsLabel = [UILabel new];
        _tipsLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    }
    return _tipsLabel;
}
-(void)setTipsString:(NSString *)tipsString{
    _tipsString = tipsString;
    self.tipsLabel.text = tipsString;
    [_tipsLabel sizeToFit];
    _tipsLabel.center = self.center;
    [_collectionView addSubview:_tipsLabel];
    
}
-(void)setTipsTextColor:(UIColor *)tipsTextColor{
    _tipsTextColor = tipsTextColor;
    _tipsLabel.textColor = tipsTextColor;
}
-(void)setImageArray:(NSMutableArray *)imageArray{
    _imageArray = [imageArray mutableCopy];
    if (imageArray.count == 0) return;
    [_collectionView reloadData];
    //    [self changeCollectionViewHeight];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //刷新完成
        [self changeCollectionViewHeight];
    });
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (self.showTipsImage) {
        return _imageArray.count+1;
    }
    return _imageArray.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // Set up the reuse identifier
    MUAdaptiveViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: cellReusedIndentifier forIndexPath:indexPath];
    if ((indexPath.row == _imageArray.count)&&self.showTipsImage) {
        cell.image = _tipsImage;
        if (self.cornerRadiusMu > 0) {
            cell.cornerRadiusMu = self.cornerRadiusMu;
        }
        if (self.tintColorMu) {
            cell.tintColorMu = self.tintColorMu;
        }
        _tipsLabel.center = CGPointMake(cell.center.x+ CGRectGetMaxX(cell.frame), cell.center.y);
        //没有任何图片
        //        if (_imageArray.count == 0) {
        //            _tipsLabel.hidden = NO;
        //        }
        //        else{
        //            _tipsLabel.hidden = YES;
        //        }
        cell.hideButton = YES;
    }
    else{
        if (self.cornerRadiusMu > 0) {
            cell.cornerRadiusMu = self.cornerRadiusMu;
        }
        if (self.tintColorMu) {
            cell.tintColorMu = self.tintColorMu;
        }
        id object = _imageArray[indexPath.item];
        if (self.configuredImage) {
            self.configuredImage(cell.imageView, indexPath.item, object);
        }
        
        cell.hideButton = NO;
    }
    
    __weak typeof(self)weakSelf = self;
    cell.deleteButtonByClicled = ^(NSUInteger flag){
        __strong typeof(weakSelf)self = weakSelf;
        [self.imageArray removeObjectAtIndex:flag];
        if (self.imageArray.count == 0) {
            self.tipsLabel.hidden = NO;
            self.tipsLabel.center = CGPointMake(weakSelf.center.x+ CGRectGetMaxX(weakSelf.frame), weakSelf.center.y);
        }
        [self.collectionView reloadData];
        
    };
    return cell;
}
#pragma mark <UICollectionViewDelegate>
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((CGRectGetWidth(self.frame)-margin) /_rowItemCount ,(CGRectGetWidth(self.frame)-margin) /_rowItemCount);
}

//定义每个UICollectionView 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, 12, 20, 12);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.item == _imageArray.count) {
        
        if (self.addItemByTaped) {
            self.addItemByTaped();
        }
    }else{
        if (self.itemByTaped) {
            self.itemByTaped(self.imageArray[indexPath.item], indexPath.item);
        }
    }
}
#pragma mark - 改变view，collectionView高度
- (void)changeCollectionViewHeight{
    CGRect newFrame = self.frame;
    NSUInteger count = (NSUInteger)(_imageArray.count / _rowItemCount);
    NSUInteger number = [self collectionView:self.collectionView numberOfItemsInSection:0];
    //    NSUInteger row =  self.imageArray.count % _rowItemCount;
    if (self.showTipsImage) {
        if ((number + 1) % _rowItemCount) {
            count += 1;
        }
    }else{
        if (number % _rowItemCount) {
            count += 1;
        }
    }
    CGFloat height = count * 104.;
    if (newFrame.size.height != height && height > 0) {
        
        newFrame.size.height = height;
        self.frame = newFrame;
        CGRect newsFrame = self.collectionView.frame;
        newsFrame.size.height = newFrame.size.height;
        self.collectionView.frame = newsFrame;
        if (self.changedFrameBlock) {
            self.changedFrameBlock(newFrame.size.height);
        }
    }
}
@end
