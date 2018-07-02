//
//  MUWeChatController.m
//  MUSignal_Example
//
//  Created by Jekity on 2018/6/27.
//  Copyright © 2018年 392071745@qq.com. All rights reserved.
//

#import "MUWeChatController.h"
#import "MUWeChatCell.h"
#import "MUWeChatModel.h"
#import "MUWeChatImageCell.h"
#import "MUChatKeyboardView.h"
#import "MUEmotionManager.h"

@interface MUWeChatController ()<UITextFieldDelegate ,UIImagePickerControllerDelegate ,UINavigationControllerDelegate>
@property (nonatomic,strong) MUTableViewManager *tableViewManager;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (nonatomic,strong) NSMutableArray *modelArray;

@property (nonatomic,assign) CGFloat keyBoardHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (nonatomic,copy) NSString *UUID;
@property (nonatomic,copy) NSString *chatID;

@property (nonatomic,strong) MUChatKeyboardView *keyboardView;
@end
static NSString * const tempCellStr = @"cell";
static NSString * const tempImageCellStr = @"imageCell";

@implementation MUWeChatController


-(NSString *)UUID{
    if (!_UUID) {
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        CFStringRef strRef = CFUUIDCreateString(kCFAllocatorDefault , uuidRef);
        NSString *uuidString = [(__bridge NSString*)strRef stringByReplacingOccurrencesOfString:@"-" withString:@""];
        CFRelease(strRef);
        CFRelease(uuidRef);
        _UUID = uuidString;
    }
    return _UUID;
}
- (void)viewDidLoad {
    [super viewDidLoad];
   _keyboardView = [[MUChatKeyboardView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 49. - self.navigationBarAndStatusBarHeight, kScreenWidth, 49.)];
    weakify(self)
   
    [self.view addSubview:_keyboardView];
      _modelArray = [NSMutableArray array];
//    _zpSwiftR = [ZPWSwiftR sharedInstance];

    _keyboardView.changedFrameCallback = ^(CGRect frame) {
        normalize(self)
        self.bottomHeightConstraint.constant = kScreenHeight - self.navigationBarAndStatusBarHeight - frame.origin.y - 49.;
        self.keyBoardHeight = frame.origin.y;
        if (self.modelArray.count == 0) {
            return ;
        }
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.modelArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        dispatch_async(dispatch_get_main_queue(), ^{
            //刷新完成
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.modelArray.count - 1 inSection:0]];
            CGFloat temp =   self.keyBoardHeight;
            if (self.tabBarController) {
                temp -= CGRectGetHeight(self.tabBarController.tabBar.frame);
            }
            CGFloat height = CGRectGetMaxY(cell.frame);
            CGFloat margain =   temp - height;
            if (margain<0) {
                self.tableView.offsetYMu = -margain + 24.;
            }
        });
        
    };
    _keyboardView.sendMessageCallback = ^(NSString *message) {
        normalize(self)
        NSAttributedString *attribute =[MUEmotionManager transferMessageString:message font:[UIFont systemFontOfSize:16.0] lineHeight:[UIFont systemFontOfSize:16.0].lineHeight];
        
        MUWeChatModel * model = [MUWeChatModel new];
        model.attributeString = attribute;
        [self.modelArray addObject:model];
        self.tableViewManager.modelArray = self.modelArray;
        
    };
    self.title = @"聊天";
    self.tableView.backgroundColor = [UIColor lightTextColor];
    self.textField.delegate = self;
    self.textField.returnKeyType = UIReturnKeySend;
    [self.tableView registerNib:[UINib nibWithNibName:@"MUWeChatFriendCell" bundle:nil] forCellReuseIdentifier:tempCellStr];
//     [self.tableView registerNib:[UINib nibWithNibName:@"MUWeChatImageCell" bundle:nil] forCellReuseIdentifier:tempImageCellStr];
  
    self.tableViewManager = [[MUTableViewManager alloc]initWithTableView:self.tableView registerCellNib:NameToString(MUWeChatCell) subKeyPath:nil];
    self.tableViewManager.modelArray = _modelArray;
//     weakify(self)
    self.tableViewManager.renderBlock = ^UITableViewCell *(UITableViewCell *cell, NSIndexPath *indexPath, id model, CGFloat *height) {
        normalize(self)
        
        MUWeChatModel *tempModel = model;
        if (tempModel.chatID.length>0) {
            UITableViewCell *tempCell = [self.tableView dequeueReusableCellWithIdentifier:tempCellStr];
            [tempCell setValue:model forKey:@"model"];
            return tempCell;
        }
        [cell setValue:model forKey:@"model"];
    
        return cell;
    };
   
    self.tableViewManager.reloadDataFinished = ^(BOOL finished) {
        normalize(self)
      
        if (self.modelArray.count == 0) {
            return ;
        }
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.modelArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            dispatch_async(dispatch_get_main_queue(), ^{
                //刷新完成
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.modelArray.count - 1 inSection:0]];
                CGFloat temp =   self.keyBoardHeight;
                if (self.tabBarController) {
                    temp -= CGRectGetHeight(self.tabBarController.tabBar.frame);
                }
                CGFloat height = CGRectGetMaxY(cell.frame);
                CGFloat margain =   temp - height;
                if (margain<0) {
                    self.tableView.offsetYMu = -margain + 24.;
                }
            });
          

    };
    self.tableViewManager.scrollViewWillBeginDragging = ^(UIScrollView *scrollView) {
        normalize(self)
        [self.textField resignFirstResponder];
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

Click_MUSignal(imageButton){
    
    UIImagePickerController *pickerCtr = [[UIImagePickerController alloc] init];
    pickerCtr.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickerCtr.delegate = self;
    [self presentViewController:pickerCtr animated:YES completion:nil];

}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
//    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
//    if ([type isEqualToString:@"public.image"]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        MUWeChatModel *model = [MUWeChatModel new];
        model.isImage            = YES;
        model.image                  = image;
    [_modelArray addObject:model];
    self.tableViewManager.modelArray = _modelArray;
     [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.modelArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        //process image
        
        [picker dismissViewControllerAnimated:YES completion:nil];
//    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end
