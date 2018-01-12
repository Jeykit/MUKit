#import "MUAssetsViewController.h"
#import <Photos/Photos.h>
#import "MUAssetCell.h"
#import "MUImagePickerManager.h"
#import "MUAssetsFooterView.h"
#import "MUPhotoPreviewController.h"

@implementation NSIndexSet (MUConvenience)

- (NSArray *)mu_indexPathsFromIndexesWithSection:(NSUInteger)section
{
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [indexPaths addObject:[NSIndexPath indexPathForItem:idx inSection:section]];
    }];
    return indexPaths;
}

@end

@implementation UICollectionView (MUConvenience)

- (NSArray *)mu_indexPathsForElementsInRect:(CGRect)rect
{
    NSArray *allLayoutAttributes = [self.collectionViewLayout layoutAttributesForElementsInRect:rect];
    if (allLayoutAttributes.count == 0) { return nil; }
    
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:allLayoutAttributes.count];
    for (UICollectionViewLayoutAttributes *layoutAttributes in allLayoutAttributes) {
        NSIndexPath *indexPath = layoutAttributes.indexPath;
        [indexPaths addObject:indexPath];
    }
    return indexPaths;
}

@end
@interface MUAssetsViewController ()<PHPhotoLibraryChangeObserver ,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) PHFetchResult         *fetchResult;
@property (nonatomic, strong) PHCachingImageManager *cacheImageManager;
@property (nonatomic, assign) CGRect                 previousPreheatRect;
@property (nonatomic, assign) BOOL                   disableScrollToBottom;
@property (nonatomic, strong) NSIndexPath           *lastSelectedItemIndexPath;
@property(nonatomic, assign ,getter=isEditing)BOOL editing;
@property(nonatomic, strong)UIButton *rightBarItem;
@property(nonatomic, strong)UIButton *lefttBarItem;

@end

@implementation MUAssetsViewController

static NSString * const reuseIdentifier = @"MUAssetCell";
static NSString * const reuseFooterIdentifier = @"MUFooterView";
-(void)loadView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    CGFloat width = [UIScreen mainScreen].bounds.size.width / self.imagePickerController.numberOfColumnsInPortrait;
    flowLayout.itemSize        = CGSizeMake(width, width);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.footerReferenceSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 44.);
 
    UICollectionView *collectionVoew      = [[UICollectionView alloc]initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:flowLayout];
    collectionVoew.backgroundColor = [UIColor whiteColor];
    collectionVoew.dataSource      = self;
    collectionVoew.delegate        = self;
    self.collectionView = collectionVoew;
    [collectionVoew registerClass:[MUAssetCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [collectionVoew registerClass:[MUAssetsFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:reuseFooterIdentifier];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"相片胶卷";
    self.editing = NO;
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    // Register observer
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
    // Do any additional setup after loading the view.
    
    [self setUpToolbarItems];
    // Fetch user albums and smart albums
    [self updateFetchRequest];
    
    //Setup bar button item
    [self configuredBarButtonItem];
}
-(void)configuredBarButtonItem{
    [self rightBarButtonItem];
    [self leftBarButtonItem];
}
- (void)setUpToolbarItems
{
    // Space
    UIBarButtonItem *leftSpace = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:nil action:NULL];;
    UIBarButtonItem *rightSpace = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:nil action:NULL];;
    NSDictionary *attributes = @{ NSForegroundColorAttributeName: [UIColor blackColor] };
    
    leftSpace.enabled = NO;
    [leftSpace setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [leftSpace setTitleTextAttributes:attributes forState:UIControlStateDisabled];
    
    rightSpace.enabled = NO;
    [rightSpace setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [rightSpace setTitleTextAttributes:attributes forState:UIControlStateDisabled];
    // Info label
  
    UIBarButtonItem *infoButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:NULL];
    infoButtonItem.enabled = NO;
    [infoButtonItem setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [infoButtonItem setTitleTextAttributes:attributes forState:UIControlStateDisabled];
    
    
    UIBarButtonItem *leftSpace1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *rightSpace1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.toolbarItems = @[leftSpace1,leftSpace, infoButtonItem, rightSpace,rightSpace1];
}
-(void)rightBarButtonItem{
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44., 44.)];
    [button setTitle:@"编辑" forState:UIControlStateNormal];
    [button setTitleColor:self.navigationController.navigationBar.tintColor forState:UIControlStateNormal];
    [button addTarget:self action:@selector(mu_rightButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightButton;
    _rightBarItem = button;
    
    UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44., 44.)];
    [button1 setTitle:@"取消" forState:UIControlStateNormal];
    [button1 setTitleColor:self.navigationController.navigationBar.tintColor forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(mu_rightButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightButton1 = [[UIBarButtonItem alloc]initWithCustomView:button1];
    self.navigationItem.rightBarButtonItems = @[rightButton,rightButton1];
//    _rightBarItem = button;
}
-(void)leftBarButtonItem{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44., 44.)];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button setTitleColor:self.navigationController.navigationBar.tintColor forState:UIControlStateNormal];
    [button addTarget:self action:@selector(mu_leftButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = rightButton;
    _lefttBarItem = button;
}
-(void)mu_leftButtonClicked{
    [self.imagePickerController dismiss];
    self.imagePickerController = nil;
}
-(void)mu_rightButtonClicked{
    self.editing  = !self.editing;
    if (self.editing) {
          [self.rightBarItem setTitle:@"完成" forState:UIControlStateNormal];
        _rightBarItem.enabled = NO;
        _rightBarItem.hidden = YES;
        self.lefttBarItem.hidden = YES;
    }else{
         [self.rightBarItem setTitle:@"选择" forState:UIControlStateNormal];
        self.lefttBarItem.hidden = NO;
       
    }
    [self.collectionView reloadData];
}
- (void)updateFetchRequest
{
    PHFetchOptions *options = [PHFetchOptions new];
    switch (self.imagePickerController.mediaType) {
        case MUImagePickerMediaTypeImage:
            self.fetchResult = [PHAsset fetchAssetsInAssetCollection:self.assetCollections[0] options:options];
            break;
        case MUImagePickerMediaTypeVideo:
            self.fetchResult = [PHAsset fetchAssetsInAssetCollection:self.assetCollections[2] options:options];
            break;
        default:
            break;
    }
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self updateCachedAssets];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:YES animated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
}
-(void)updateButtonState:(NSUInteger)count{
    
    if (self.allowsMultipleSelection) {
        BOOL enable = self.maximumNumberOfSelection <= count;
        if (self.minimumNumberOfSelection != 0) {
            enable = self.minimumNumberOfSelection <= count;
        }
        self.rightBarItem.enabled = enable;
    }
}
#pragma mark -lazy loading
-(PHCachingImageManager *)cacheImageManager{
    if (!_cacheImageManager) {
        _cacheImageManager = [PHCachingImageManager new];
    }
    return _cacheImageManager;
}

- (void)updateCachedAssets
{
    BOOL isViewVisible = [self isViewLoaded] && self.view.window != nil;
    if (!isViewVisible) { return; }
    
    // The preheat window is twice the height of the visible rect
    CGRect preheatRect = self.collectionView.bounds;
    preheatRect = CGRectInset(preheatRect, 0.0, -0.5 * CGRectGetHeight(preheatRect));
    
    // If scrolled by a "reasonable" amount...
    CGFloat delta = ABS(CGRectGetMidY(preheatRect) - CGRectGetMidY(self.previousPreheatRect));
    
    if (delta > CGRectGetHeight(self.collectionView.bounds) / 3.0) {
        // Compute the assets to start caching and to stop caching
        NSMutableArray *addedIndexPaths = [NSMutableArray array];
        NSMutableArray *removedIndexPaths = [NSMutableArray array];
        
        [self computeDifferenceBetweenRect:self.previousPreheatRect andRect:preheatRect addedHandler:^(CGRect addedRect) {
            NSArray *indexPaths = [self.collectionView mu_indexPathsForElementsInRect:addedRect];
            [addedIndexPaths addObjectsFromArray:indexPaths];
        } removedHandler:^(CGRect removedRect) {
            NSArray *indexPaths = [self.collectionView mu_indexPathsForElementsInRect:removedRect];
            [removedIndexPaths addObjectsFromArray:indexPaths];
        }];
        
        NSArray *assetsToStartCaching = [self assetsAtIndexPaths:addedIndexPaths];
        NSArray *assetsToStopCaching = [self assetsAtIndexPaths:removedIndexPaths];
        
        CGSize itemSize = [(UICollectionViewFlowLayout *)self.collectionViewLayout itemSize];
        CGSize targetSize = CGSizeScale(itemSize, [[UIScreen mainScreen] scale]);
        
        [self.cacheImageManager startCachingImagesForAssets:assetsToStartCaching
                                                 targetSize:targetSize
                                                contentMode:PHImageContentModeAspectFill
                                                    options:nil];
        [self.cacheImageManager stopCachingImagesForAssets:assetsToStopCaching
                                                targetSize:targetSize
                                               contentMode:PHImageContentModeAspectFill
                                                   options:nil];
        
        self.previousPreheatRect = preheatRect;
    }
}
static CGSize CGSizeScale(CGSize size, CGFloat scale) {
    return CGSizeMake(size.width * scale, size.height * scale);
}
- (void)computeDifferenceBetweenRect:(CGRect)oldRect andRect:(CGRect)newRect addedHandler:(void (^)(CGRect addedRect))addedHandler removedHandler:(void (^)(CGRect removedRect))removedHandler
{
    if (CGRectIntersectsRect(newRect, oldRect)) {
        CGFloat oldMaxY = CGRectGetMaxY(oldRect);
        CGFloat oldMinY = CGRectGetMinY(oldRect);
        CGFloat newMaxY = CGRectGetMaxY(newRect);
        CGFloat newMinY = CGRectGetMinY(newRect);
        
        if (newMaxY > oldMaxY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, oldMaxY, newRect.size.width, (newMaxY - oldMaxY));
            addedHandler(rectToAdd);
        }
        if (oldMinY > newMinY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, newMinY, newRect.size.width, (oldMinY - newMinY));
            addedHandler(rectToAdd);
        }
        if (newMaxY < oldMaxY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, newMaxY, newRect.size.width, (oldMaxY - newMaxY));
            removedHandler(rectToRemove);
        }
        if (oldMinY < newMinY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, oldMinY, newRect.size.width, (newMinY - oldMinY));
            removedHandler(rectToRemove);
        }
    } else {
        addedHandler(newRect);
        removedHandler(oldRect);
    }
}

- (NSArray *)assetsAtIndexPaths:(NSArray *)indexPaths
{
    if (indexPaths.count == 0) { return nil; }
    
    NSMutableArray *assets = [NSMutableArray arrayWithCapacity:indexPaths.count];
    for (NSIndexPath *indexPath in indexPaths) {
        if (indexPath.item < self.fetchResult.count) {
            PHAsset *asset = self.fetchResult[indexPath.item];
            [assets addObject:asset];
        }
    }
    return assets;
}

#pragma mark - PHPhotoLibraryChangeObserver
- (void)photoLibraryDidChange:(PHChange *)changeInstance
{
    dispatch_async(dispatch_get_main_queue(), ^{
        PHFetchResultChangeDetails *collectionChanges = [changeInstance changeDetailsForFetchResult:self.fetchResult];
        
        if (collectionChanges) {
            // Get the new fetch result
            self.fetchResult = [collectionChanges fetchResultAfterChanges];
            
            if (![collectionChanges hasIncrementalChanges] || [collectionChanges hasMoves]) {
                // We need to reload all if the incremental diffs are not available
                [self.collectionView reloadData];
            } else {
                // If we have incremental diffs, tell the collection view to animate insertions and deletions
                [self.collectionView performBatchUpdates:^{
                    NSIndexSet *removedIndexes = [collectionChanges removedIndexes];
                    if ([removedIndexes count]) {
                        [self.collectionView deleteItemsAtIndexPaths:[removedIndexes mu_indexPathsFromIndexesWithSection:0]];
                    }
                    
                    NSIndexSet *insertedIndexes = [collectionChanges insertedIndexes];
                    if ([insertedIndexes count]) {
                        [self.collectionView insertItemsAtIndexPaths:[insertedIndexes mu_indexPathsFromIndexesWithSection:0]];
                    }
                    
                    NSIndexSet *changedIndexes = [collectionChanges changedIndexes];
                    if ([changedIndexes count]) {
                        [self.collectionView reloadItemsAtIndexPaths:[changedIndexes mu_indexPathsFromIndexesWithSection:0]];
                    }
                } completion:NULL];
            }
            
            [self resetCachedAssets];
        }
    });
}
#pragma mark - Asset Caching

- (void)resetCachedAssets
{
    [self.cacheImageManager stopCachingImagesForAllAssets];
    self.previousPreheatRect = CGRectZero;
}
-(void)dealloc{
    
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.fetchResult.count;;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MUAssetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.tag = indexPath.item;
    cell.tintColor = self.navigationController.navigationBar.tintColor;
    
    // Image
    PHAsset *asset = self.fetchResult[indexPath.item];
    CGSize itemSize = [(UICollectionViewFlowLayout *)collectionView.collectionViewLayout itemSize];
    CGSize targetSize = CGSizeScale(itemSize, [[UIScreen mainScreen] scale]);
    
    [self.cacheImageManager requestImageForAsset:asset
                                      targetSize:targetSize
                                     contentMode:PHImageContentModeAspectFill
                                         options:nil
                                   resultHandler:^(UIImage *result, NSDictionary *info) {
                                       if (cell.tag == indexPath.item) {
                                           cell.imageView.image = result;
                                       }
                                   }];
    
    // Video indicator
    if (asset.mediaType == PHAssetMediaTypeVideo) {
                cell.videoIndicatorView.hidden = NO;
        
        NSInteger minutes = (NSInteger)(asset.duration / 60.0);
        NSInteger seconds = (NSInteger)ceil(asset.duration - 60.0 * (double)minutes);
                cell.videoIndicatorView.timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", (long)minutes, (long)seconds];
        
        if (asset.mediaSubtypes & PHAssetMediaSubtypeVideoHighFrameRate) {
                        cell.videoIndicatorView.videoIcon.hidden = YES;
                        cell.videoIndicatorView.slomoIcon.hidden = NO;
        }
        else {
                        cell.videoIndicatorView.videoIcon.hidden = NO;
                        cell.videoIndicatorView.slomoIcon.hidden = YES;
        }
    } else {
                cell.videoIndicatorView.hidden = YES;
    }
    if (self.isEditing) {
        cell.overlayView.hidden = NO;
        //     Selection state
        if ([self.imagePickerController.selectedAssets containsObject:asset]) {
            cell.picked = YES;
            [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        }else{
             cell.picked = NO;
        }
        
    }else{
        cell.overlayView.hidden = YES;
    }
    
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionFooter) {
        MUAssetsFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                                  withReuseIdentifier:reuseFooterIdentifier
                                                                                         forIndexPath:indexPath];
        
        // Number of assets
        UILabel *label = footerView.textLabel;
        
        NSUInteger numberOfPhotos = [self.fetchResult countOfAssetsWithMediaType:PHAssetMediaTypeImage];
        NSUInteger numberOfVideos = [self.fetchResult countOfAssetsWithMediaType:PHAssetMediaTypeVideo];
        
        switch (self.imagePickerController.mediaType) {
            case MUImagePickerMediaTypeAny:
            {
                NSString *format = @"共%ld 张照片, %ld 个视频";
                label.text = [NSString stringWithFormat:format, numberOfPhotos, numberOfVideos];
            }
                break;
                
            case MUImagePickerMediaTypeImage:
            {
                NSString *format = @"共%ld 张照片";
                label.text = [NSString stringWithFormat:format, numberOfPhotos];
            }
                break;
                
            case MUImagePickerMediaTypeVideo:
            {
                NSString *format = @"共%ld 个视频";
                label.text = [NSString stringWithFormat:format, numberOfVideos];
            }
                break;
        }
        [label sizeToFit];
        label.center = CGPointMake(footerView.center.x, 22.);
        return footerView;
    }
    
    return nil;
}

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.isEditing) {
        MUPhotoPreviewController *controller = [MUPhotoPreviewController new];
        controller.fetchResult               = self.fetchResult;
        controller.currentIndex              = indexPath.item;
        [self.navigationController pushViewController:controller animated:YES];
        return;
    }
    MUAssetCell *cell = (MUAssetCell *)[collectionView cellForItemAtIndexPath:indexPath];
    MUImagePickerManager *imagePickerController = self.imagePickerController;
    NSMutableOrderedSet *selectedAssets = imagePickerController.selectedAssets;
    PHAsset *asset = self.fetchResult[indexPath.item];
    if (selectedAssets.count == self.maximumNumberOfSelection) {
       
        if (cell.picked) {
              cell.picked    = !cell.picked;
        }
    }else{
        cell.picked    = !cell.picked;
    }
    if (cell.picked) {
        [selectedAssets addObject:asset];
    }else{
        [selectedAssets removeObject:asset];
    }
   
    if (selectedAssets.count > 0) {
        NSString *title = [NSString stringWithFormat:@"已选择%ld 张照片",selectedAssets.count];
        [(UIBarButtonItem *)self.toolbarItems[1] setTitle:title];
        if (selectedAssets.count == 1) {
            // Show toolbar
            [self.navigationController setToolbarHidden:NO animated:YES];
        }
        [self updateButtonState:selectedAssets.count];
        if (self.didPickedAImage) {
             self.didPickedAImage(cell.imageView.image);
        }
       
    }else{
        [(UIBarButtonItem *)self.toolbarItems[1] setTitle:@"已选择0 张照片"];
    }
    
}



#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger numberOfColumns;
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
        numberOfColumns = self.imagePickerController.numberOfColumnsInPortrait;
    } else {
        numberOfColumns = self.imagePickerController.numberOfColumnsInLandscape;
    }
    
    CGFloat width = (CGRectGetWidth(self.view.frame) - 2.0 * (numberOfColumns - 1)) / numberOfColumns;
    
    return CGSizeMake(width, width);
}


@end
