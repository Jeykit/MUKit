//
//  MUSearchController.m
//  MUKit_Example
//
//  Created by Jekity on 2018/2/2.
//  Copyright © 2018年 Jeykit. All rights reserved.
//

#import "MUSearchController.h"
#import "MUSearchCell.h"
#import "MUSearchCollectionReusableView.h"

@interface MUSearchController ()<UISearchResultsUpdating,UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSArray *dataSource;/**<排序前的整个数据源*/
@property (strong, nonatomic) NSDictionary *allDataSource;/**<排序后的整个数据源*/
@property (strong, nonatomic) NSMutableArray *searchDataSource;/**<搜索结果数据源*/
@property (strong, nonatomic) NSArray *indexDataSource;/**<索引数据源*/
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)UICollectionView *collectionView;
@end

@implementation MUSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.searchController.searchBar;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(self.searchController.view.hidden){
        self.searchController.view.hidden = NO;
        
    }
    if (!self.searchController.view.hidden&&!self.searchController.view.hidden) {
         self.edgesForExtendedLayout = UIRectEdgeBottom;
    }
  
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -lazy loading
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    }
    return _tableView;
}
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width - 20. - 50.)/4, 44.);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.minimumLineSpacing = 10.;
        flowLayout.minimumInteritemSpacing = 10.;
        CGFloat height = CGRectGetHeight(self.navigationController.navigationBar.frame)+CGRectGetHeight(self.searchController.searchBar.frame);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(10., height, [UIScreen mainScreen].bounds.size.width - 20., [UIScreen mainScreen].bounds.size.height - height) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.hidden     = YES;
        [_collectionView registerNib:[UINib nibWithNibName:@"MUSearchCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
        [_collectionView registerNib:[UINib nibWithNibName:@"MUSearchCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
        
    }
    return _collectionView;
}
- (UISearchController *)searchController {
    if (!_searchController) {
        _searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
        _searchController.searchResultsUpdater = self;
        _searchController.dimsBackgroundDuringPresentation = NO;
        _searchController.hidesNavigationBarDuringPresentation = YES;
        _searchController.searchBar.placeholder = @"输入商品关键词搜索";
        [_searchController.searchBar sizeToFit];
        //修改标题和标题颜色
        [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor grayColor]];
        [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTitle:@"取消"];
      
    }
    return _searchController;
}
#pragma mark - UISearchDelegate
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    [_searchDataSource removeAllObjects];
    if (self.searchController.active) {
         self.tableView.hidden = YES;
        self.collectionView.hidden = NO;
    }else{
         self.tableView.hidden = NO;
        self.collectionView.hidden = YES;
    }
   
//    [self.collectionView reloadData];
}
#pragma mark - UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MUSearchCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    return cell;
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
   
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        MUSearchCollectionReusableView *label = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:indexPath];
        return label;
    }
    return nil;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size={[UIScreen mainScreen].bounds.size.width - 20.,44};
    return size;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.searchController.view.hidden = YES;
    self.navigationBarHiddenMu = YES;
    [self.navigationController pushViewControllerStringMu:NameToString(MUSearchBarController) animated:YES parameters:^(NSMutableDictionary *dict) {
        
    }];
  
}
@end
