//
//  MUWeChatController.m
//  MUSignal_Example
//
//  Created by Jekity on 2018/6/27.
//  Copyright © 2018年 392071745@qq.com. All rights reserved.
//

#import "MUWeChatController.h"
#import "MUWeChatModel.h"
#import "MUChatKeyboardView.h"
#import "MUEmotionManager.h"
#import "MUMessageTableView.h"



@interface MUWeChatController ()<UITextFieldDelegate ,UIImagePickerControllerDelegate ,UINavigationControllerDelegate>
@property (nonatomic,strong) MUTableViewManager *tableViewManager;
@property (nonatomic,strong) NSMutableArray *modelArray;


@property (nonatomic,strong) MUChatKeyboardView *keyboardView;

@property (nonatomic,strong) MUMessageTableView *tableView;
@property (nonatomic,strong) NSMutableArray *imageArray;

@property (nonatomic,assign) NSUInteger currentIndex;

@end
static NSString * const tempCellStr = @"cell";
static NSString * const tempImageCellStr = @"imageCell";

@implementation MUWeChatController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleColorMu = [UIColor whiteColor];
    [self MVVMTableView];
    [self customzingKeyboard];

    NSArray *array = @[[self modelWithText:@"试试"],[self modelWithText:@"试U87324823"],[self modelWithText:@"ERSFDTERT3"]];
    self.tableViewManager.modelArray = array;
    
  
}

//自定义键盘
- (void)customzingKeyboard{
    _keyboardView = [[MUChatKeyboardView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 49. - self.navigationBarAndStatusBarHeight, kScreenWidth, 49.)];
    weakify(self)
    [self.view addSubview:_keyboardView];
    _keyboardView.transformedView = self.view;
    _keyboardView.adjustView = self.tableView;

    _keyboardView.sendMessageCallback = ^(NSString *message) {
        normalize(self)
        NSMutableArray *mArray = [self.tableViewManager.modelArray mutableCopy];
        MUWeChatModel *model = [self modelWithText:message];
        [mArray addObject:model];
        self.tableViewManager.modelArray = mArray;
        if (self.tableViewManager.modelArray.count > 0) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.tableViewManager.modelArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];//滚动到最后一行
            [self.keyboardView autoAdjustContentOffsetY];
        }

    };
    
    

       
}


- (void)MVVMTableView{
    
    _tableView = [[MUMessageTableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - self.navigationBarAndStatusBarHeight - 49.) style:UITableViewStylePlain];
     _tableView.backgroundView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat_bg_default"]];
    [self.view addSubview:_tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"MUWeChatFriendCell" bundle:nil] forCellReuseIdentifier:tempCellStr];
    self.tableViewManager = [[MUTableViewManager alloc]initWithTableView:self.tableView registerCellNib:NameToString(MUWeChatCell) subKeyPath:nil];
         weakify(self)

    self.tableViewManager.renderBlock = ^UITableViewCell *(UITableViewCell *cell, NSIndexPath *indexPath, id model, CGFloat *height) {
        [cell setValue:model forKey:@"model"];
        
        return cell;
    };
    
    self.tableViewManager.scrollViewWillBeginDragging = ^(UIScrollView *scrollView) {
        normalize(self)

        self.keyboardView.showKeyboard = NO;
        
    };
}
-(MUWeChatModel *)modelWithText:(NSString *)text{
    MUWeChatModel *model = [MUWeChatModel new];
    model.text = text;
    return model;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
