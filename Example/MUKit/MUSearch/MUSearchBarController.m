//
//  MUSearchBarController.m
//  MUKit_Example
//
//  Created by Jekity on 2018/2/3.
//  Copyright © 2018年 Jeykit. All rights reserved.
//

#import "MUSearchBarController.h"

@interface MUSearchBarController ()<UISearchBarDelegate>
@property (strong, nonatomic) UITableView *friendTableView;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *dataSource;/**<排序前的整个数据源*/
@property (strong, nonatomic) NSDictionary *allDataSource;/**<排序后的整个数据源*/
@property (strong, nonatomic) NSMutableArray *searchDataSource;/**<搜索结果数据源*/
@property (strong, nonatomic) NSArray *indexDataSource;/**<索引数据源*/
@end

@implementation MUSearchBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationBarBackgroundImageMu = [UIImage imageFromColorMu:[UIColor greenColor]];
    //titleView添加UISearchBar，需要添加背景视图
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds) * 0.85;
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 30)];
    backgroundView.backgroundColor = [UIColor clearColor];
    backgroundView.layer.cornerRadius = 15.;
    backgroundView.layer.masksToBounds = YES;
    [backgroundView addSubview:self.searchBar];
    self.titleViewMu = backgroundView;
//    self.titleViewMu.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 22);
    self.view.backgroundColor = [UIColor whiteColor];
    
}
- (UISearchBar *)searchBar {
    if (!_searchBar) {
          CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds) * 0.85;
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, width, 30)];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"输入关键字搜索商品";
        _searchBar.clipsToBounds  = YES;
        _searchBar.showsCancelButton = NO;
        _searchBar.layer.cornerRadius = 15.;
        _searchBar.layer.masksToBounds = YES;
        UITextField *textField = [[[_searchBar.subviews firstObject] subviews] lastObject];
        textField.layer.cornerRadius = 15.;
        textField.layer.masksToBounds = YES;
    }
    return _searchBar;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
  
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {

}

@end
