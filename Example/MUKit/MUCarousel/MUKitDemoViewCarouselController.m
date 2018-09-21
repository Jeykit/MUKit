//
//  MUKitDemoViewCarouselController.m
//  MUKit_Example
//
//  Created by Jekity on 2017/12/18.
//  Copyright © 2017年 Jeykit. All rights reserved.
//

#import "MUKitDemoViewCarouselController.h"
#import "MUAdaptiveView.h"
#import "MUCameraAndPhotosManager.h"
#import "MUCardView.h"
#import "MUCardLayout.h"
#import "MUPhotoPreviewController.h"
#import "UIImageView+MUImageCache.h"
#import "MUImageCacheManager.h"

@interface MUKitDemoViewCarouselController ()
@property(nonatomic, strong)MUCarouselView *carouselView1;
@property(nonatomic, strong)MUCarouselView *carouselView2;
@property(nonatomic, strong)MUAdaptiveView *adaptiveView;
@property(nonatomic, strong)MUCardView *cardView;
@end

@implementation MUKitDemoViewCarouselController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationBarBackgroundImageMu = [UIImage imageFromColorMu:[UIColor colorWithHexString:@"#60B3E9"
                                                                     
                                                                     ]];
    self.title = @"Carousel";
    
    MUPhotoPreviewController *controller = [MUPhotoPreviewController new];
    controller.currentIndex = 1;
    controller.mediaType = 1;
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 22, 22)];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(Carousel) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 22, 22)];
    button1.backgroundColor = [UIColor purpleColor];
    button1.titleStringMu = @"分享";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:button1];
    controller.toolbar.items = @[leftItem,rightItem];

    controller.configuredImageBlock = ^(UIImageView *imageView, NSUInteger index, id model ,NSString **caption) {
        [imageView setImageURL:model placeHolderImageName:@"1024_s"];

*caption = @"sekfjsdgkldllgldhttp://pic34.nipic.com/20131028/2455348_171218804000_2.jpghttp://pic34.nipic.com/20131028/2455348_171218804000_2.jpghttp://pic34.nipic.com/20131028/2455348_171218804000_2.jpg";
    };
    controller.modelArray = @[
                              @"http://pic34.nipic.com/20131028/2455348_171218804000_2.jpg",
                              @"http://img1.3lian.com/2015/a2/228/d/129.jpg",
                              @"http://img.boqiicdn.com/Data/Bbs/Pushs/img79891399602390.jpg",
                              @"http://sc.jb51.net/uploads/allimg/150703/14-150F3164339355.jpg",
                              @"http://img1.3lian.com/2015/a2/243/d/187.jpg",
                              @"http://pic7.nipic.com/20100503/1792030_163333013611_2.jpg",
                              @"http://www.microfotos.com/pic/0/90/9023/902372preview4.jpg",
                              @"http://pic1.win4000.com/wallpaper/b/55b9e2271b119.jpg"
                              ];
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithTitle:@"选择" style:UIBarButtonItemStylePlain target:nil action:nil];
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:nil action:nil];
//    controller.toolbar.items = @[leftItem,rightItem];
    [self.navigationController pushViewController:controller animated:YES];
   
//        self.carouselView1 = [[MUCarouselView alloc]initWithFrame:CGRectMake(0, 0.0, kScreenWidth, 300)];
//        [self.view addSubview:self.carouselView1];
//        self.carouselView1.scrollDirection = MUCarouselScrollDirectionHorizontal;
//        self.carouselView1.placeholderImage = [UIImage imageNamed:@"1024_s"];
//     网络图片数组
//        self.carouselView1.urlImages = @[
//                           @"http://pic34.nipic.com/20131028/2455348_171218804000_2.jpg",
//                           @"http://img1.3lian.com/2015/a2/228/d/129.jpg",
////                           @"http://img.boqiicdn.com/Data/Bbs/Pushs/img79891399602390.jpg",
////                           @"http://sc.jb51.net/uploads/allimg/150703/14-150F3164339355.jpg",
////                           @"http://img1.3lian.com/2015/a2/243/d/187.jpg",
////                           @"http://pic7.nipic.com/20100503/1792030_163333013611_2.jpg",
////                           @"http://www.microfotos.com/pic/0/90/9023/902372preview4.jpg",
////                           @"http://pic1.win4000.com/wallpaper/b/55b9e2271b119.jpg"
//                           ];
//
//    self.carouselView2 = [[MUCarouselView alloc]initWithFrame:CGRectMake(0, 350., kScreenWidth, 44.)];
//    [self.view addSubview:self.carouselView2];
//    self.carouselView2.titleColor = [UIColor purpleColor];
//    self.carouselView2.textAlignment = NSTextAlignmentLeft;
//    self.carouselView2.backgroundColor = [UIColor lightGrayColor];
//    self.carouselView2.scrollDirection = MUCarouselScrollDirectionVertical;
//        self.carouselView2.titlesArray = @[
//                                          @"http://pic34.nipic.com/20131028/2455348_171218804000_2.jpg",
//                                          @"http://img1.3lian.com/2015/a2/228/d/129.jpg",
//                                          @"http://img.boqiicdn.com/Data/Bbs/Pushs/img79891399602390.jpg",
//                                          @"http://sc.jb51.net/uploads/allimg/150703/14-150F3164339355.jpg",
//                                          @"http://img1.3lian.com/2015/a2/243/d/187.jpg",
//                                          @"http://pic7.nipic.com/20100503/1792030_163333013611_2.jpg",
//                                          @"http://www.microfotos.com/pic/0/90/9023/902372preview4.jpg",
//                                          @"http://pic1.win4000.com/wallpaper/b/55b9e2271b119.jpg"
//                                          ];
//
//    self.adaptiveView = [[MUAdaptiveView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.carouselView2.frame)+100,kScreenWidth, 120.)];
//    self.adaptiveView.tipsImage = [UIImage imageNamed:@"plus"];
////    self.adaptiveView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    [self.view addSubview:self.adaptiveView];
//    self.adaptiveView.tintColorMu = [UIColor orangeColor];
//    self.adaptiveView.cornerRadiusMu = 10.;
//    self.adaptiveView.rowItemCount = 3;
//    self.adaptiveView.showTipsImage = NO;
//    NSMutableArray *mArray = [NSMutableArray array];
//    weakify(self)
//    self.adaptiveView.addItemByTaped  = ^() {
//        normalize(self)
//        [MUCameraAndPhotosManager pickImageControllerPresentIn:self selectedImage:^(UIImage *image) {
//
//            [mArray addObject:image];
//            self.adaptiveView.imageArray = mArray;
//        }];
//    };
//
//    self.adaptiveView.changedFrameBlock = ^(CGFloat needHeight) {
//
//        NSLog(@"========height=======%lf",needHeight);
//    };
    
   
//    NSArray *testArray =@[@"刘备",@"李白",@"嬴政",@"韩信"];
//
////   CGSize size = [UIScreen mainScreen].bounds.size;
//    self.cardView = [[MUCardView alloc]initWithFrame:CGRectMake(0, 100, kScreenWidth,400.) modelArray:testArray cellNibName:@"SCAdDemoCollectionViewCell"];
//    [self.view addSubview:self.self.cardView];
//    self.cardView.pagingEnabled = YES;
//    self.cardView.renderBlock = ^void (UICollectionViewCell *cell, NSIndexPath *indexPath, id model) {
//
//        [cell setValue:model forKey:@"name"];
//
//    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)Carousel{
    NSLog(@"sdkfkjsdkfld");
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
