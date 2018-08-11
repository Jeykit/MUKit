//
//  RootViewController.m
//  Demo
//
//  Created by Ye Tong on 3/24/16.
//  Copyright © 2016 NorrisTong. All rights reserved.
//

#import "RootViewController.h"
#import "BaseTableViewCell.h"
#import "SDImageCache.h"
#import "SDWebImageManager.h"
#import "YYFPSLabel.h"

@interface RootViewController () <UITableViewDataSource, UITableViewDelegate, SDWebImageManagerDelegate>

@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, assign) CGFloat itemHeight;
@property (nonatomic, strong) YYFPSLabel *fpsLabel;
@end

@implementation RootViewController {
    UITableView *_tableView;
    UISegmentedControl *_segment;
    
    NSMutableArray *_imageURLs;
    NSMutableArray *_cells;
    NSMutableArray *_indentifiers;
    
    CADisplayLink *_link;
    NSUInteger _count;
    NSTimeInterval _lastTime;
    
    UILabel *label_;
}

- (instancetype)init {
    if (self = [super init]) {
        _cells = [[NSMutableArray alloc] init];
        _indentifiers = [[NSMutableArray alloc] init];
        _activeIndex = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // setup image paths
    _imageURLs = [[NSMutableArray alloc] init];
    for (int i=0; i<100; i++) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://flyimage.oss-us-west-1.aliyuncs.com/%d%@", i, self.suffix ]];
        [_imageURLs addObject:url];
    }
    
    [self testFPSLabel];
    CGFloat segmentHeight = 30;
    CGRect bounds = self.view.bounds;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, bounds.size.width, bounds.size.height-segmentHeight)
                                              style:UITableViewStylePlain];
    _tableView.opaque = YES;
    _tableView.directionalLockEnabled = YES;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.allowsSelection = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    NSMutableArray *items = [NSMutableArray array];
    for (NSDictionary *info in _cells) {
        [items addObject: [info objectForKey:@"title"]];
        
        Class class = [info objectForKey:@"class"];
        NSString *indentifier = NSStringFromClass(class);
        [_indentifiers addObject:indentifier];
        [_tableView registerClass:class forCellReuseIdentifier:indentifier];
    }
    [self.view addSubview:_tableView];
    
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:10], NSFontAttributeName, nil];
    [[UISegmentedControl appearance] setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    
    _segment = [[UISegmentedControl alloc] initWithItems:items];
    _segment.backgroundColor = [UIColor whiteColor];
    _segment.frame = CGRectMake(0, kScreenHeight - self.navigationBarAndStatusBarHeight - segmentHeight, bounds.size.width, segmentHeight);
    [_segment setSelectedSegmentIndex:_activeIndex];
    [_segment addTarget:self action:@selector(onTapSegment) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_segment];
    
    SDWebImageManager *sdManager = [SDWebImageManager sharedManager];
    sdManager.delegate = self;
    
    _itemWidth = floor(self.view.frame.size.width / _cellsPerRow) - 4;
    _itemHeight = _heightOfCell - 4;
}
#pragma mark - FPS demo

- (void)testFPSLabel {
    _fpsLabel = [YYFPSLabel new];
    _fpsLabel.frame = CGRectMake(200, 200, 50, 30);
    [_fpsLabel sizeToFit];
    self.titleViewMu = _fpsLabel;
    //    [self.titleViewMu addSubview:_fpsLabel];
    
    // 如果直接用 self 或者 weakSelf，都不能解决循环引用问题
    
    // 移除也不能使 label里的 timer invalidate
    //        [_fpsLabel removeFromSuperview];
}

#pragma mark - 子线程 timer demo

- (void)testSubThread {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(200, 200, 100, 50)];
    label_ = label;
    label.backgroundColor = [UIColor grayColor];
    //    [table_ addSubview:label];
    
    
    // 开启子线程，新建 runloop， 避免主线程 阻塞时， timer不能用
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];
        
        // NOTE: 子线程的runloop默认不创建； 在子线程获取 currentRunLoop 对象的时候，就会自动创建RunLoop
        
        // 这里不加到 main loop，必须创建一个 runloop
        NSRunLoop *runloop = [NSRunLoop currentRunLoop];
        [_link addToRunLoop:runloop forMode:NSRunLoopCommonModes];
        
        // 必须 timer addToRunLoop 后，再run
        [runloop run];
    });
    
    // 模拟 主线程阻塞 （不应该模拟主线程卡死，模拟卡顿即可）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSLog(@"即将阻塞");
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"同步阻塞主线程");
        });
        NSLog(@"不会执行");
    });
}

- (void)tick:(CADisplayLink *)link {
    if (_lastTime == 0) {
        _lastTime = link.timestamp;
        return;
    }
    
    _count++;
    NSTimeInterval delta = link.timestamp - _lastTime;
    if (delta < 1) return;
    _lastTime = link.timestamp;
    float fps = _count / delta;
    _count = 0;
    
    NSString *text = [NSString stringWithFormat:@"%d FPS",(int)round(fps)];
    
    // 尝试1：主线程阻塞， 这里就不能获取到主线程了
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        //  阻塞时，想通过 在主线程更新UI 来查看是不可行了
    //        label_.text = text;
    //    });
    
    // 尝试2：不在主线程操作 UI ，界面会发生变化
    label_.text = text;
    
    NSLog(@"%@", text);
}
#pragma mark - SDWebImageManagerDelegate

- (UIImage *)imageManager:(SDWebImageManager *)imageManager transformDownloadedImage:(UIImage *)image withURL:(NSURL *)imageURL{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(_itemWidth, _heightOfCell), NO, [UIScreen mainScreen].scale);
    
    CGRect box = CGRectMake(0, 0, _itemWidth, _itemHeight);
    [[UIBezierPath bezierPathWithRoundedRect:box cornerRadius:10.f] addClip];
    [image drawInRect:box];
    
    UIImage* ret = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return ret;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)onTapSegment {
    _activeIndex = _segment.selectedSegmentIndex;
    
    [_tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2000;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.heightOfCell;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger startIndex = ([indexPath row] * self.cellsPerRow) % [_imageURLs count];
    NSInteger count = MIN(self.cellsPerRow, [_imageURLs count] - startIndex);
    NSArray *photos = [_imageURLs subarrayWithRange:NSMakeRange(startIndex, count)];
    
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_indentifiers[_activeIndex] forIndexPath:indexPath];
    [cell displayImageWithPhotos:photos];
    
    return cell;
}

@end
