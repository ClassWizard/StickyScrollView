//
//  HomeMapViewController.m
//  StickyScrollView
//
//  Created by ClassWizard on 16/3/31.
//  Copyright © 2016年 ClassWizard. All rights reserved.
//

#import "HomeMapViewController.h"
#import "EVPassThroughScrollView.h"
#import <MapKit/MapKit.h>

@interface HomeMapViewController () <MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) MKMapView *myMapView;
@property (nonatomic, strong) EVPassThroughScrollView *scrollView;
@property (nonatomic, strong) UITableView *electricPileTableView;

@property (nonatomic, strong) NSMutableArray<UIView *> *stickyViewArr;

@property (nonatomic, assign) CGPoint lastScrollViewOffset;
@property (nonatomic, assign) CGPoint lastElectricPileTableViewOffset;


@end

@implementation HomeMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupMap];
    [self setupScrollView];

}

#pragma mark - UI
- (void)setupMap {
    self.myMapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, SCREEN_HEIGHT - 64 - 49)];
    self.myMapView.delegate = self;
    [self.view addSubview: self.myMapView];
    [self.view sendSubviewToBack:self.myMapView];
//    MKCoordinateRegion region;
//    region.span = MKCoordinateSpanMake(0.1, 0.1);
//    region.center = [[DMLocationManager shareInstance] getLastLocation];
//    if (region.center.latitude > 0 && region.center.longitude > 0) {
//        [self.myMapView setRegion:region animated:YES];
//    }
//    self.myMapView.showsUserLocation = YES;
//    self.myMapView.userTrackingMode = MKUserTrackingModeNone;
//    self.myMapView.userInteractionEnabled = YES;
//    self.myMapView.rotateEnabled = NO;
    
    
}

- (void)setupScrollView {
    
    UIPanGestureRecognizer *scrollPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleScrollViewPanGesture:)];
    
    // 1.外部滚动视图
    self.scrollView = [[EVPassThroughScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    self.scrollView.delegate = self;
    self.scrollView.scrollEnabled = NO;
    [self.scrollView addGestureRecognizer:scrollPanGesture];
    //由于要遮罩标签栏,所以放在keyWindow上
    NSArray *windows = [UIApplication sharedApplication].windows;
    [windows.firstObject addSubview:self.scrollView];
    
    // contentView
    // 2.1头部简要信息 briefInfoView
    UIView *briefInfoView = [UIView new];
    briefInfoView.backgroundColor = [UIColor redColor];
    [self.scrollView.contentView addSubview:briefInfoView];
    
    [briefInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.equalTo(300);
    }];
    
    // 2.1.1 segmentStickyView
    UIView *segmentStickyView = [UIView new];
    segmentStickyView.backgroundColor = [UIColor purpleColor];
    [briefInfoView addSubview:segmentStickyView];
    [segmentStickyView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.equalTo(44);
    }];
    
    // 2.2横向ScrollView
    UIScrollView *pageScrollView = [UIScrollView new];
    pageScrollView.pagingEnabled = YES;
    pageScrollView.bounces = NO;
    pageScrollView.showsHorizontalScrollIndicator = NO;
    [self.scrollView.contentView addSubview:pageScrollView];
    pageScrollView.backgroundColor = [UIColor blueColor];
    [pageScrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(briefInfoView.mas_bottom);
        make.left.right.offset(0);
        make.height.equalTo(SCREEN_HEIGHT - 64 - 44);
        make.bottom.offset(0);
    }];
    UIView *pageScrollContainer = [UIView new];
    [pageScrollView addSubview:pageScrollContainer];
    [pageScrollContainer makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsZero);
    }];
    
    // 2.2.1桩位
    self.electricPileTableView = [UITableView new];
    self.electricPileTableView.delegate = self;
    self.electricPileTableView.dataSource = self;
    self.electricPileTableView.scrollEnabled = NO;
    [pageScrollContainer addSubview:self.electricPileTableView];
    [self.electricPileTableView makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(pageScrollView);
        make.top.left.bottom.offset(0);
    }];
    
    // 2.2.2信息
    UIView *infoView = [UIView new];
    infoView.backgroundColor = [UIColor yellowColor];
    [pageScrollContainer addSubview:infoView];
    [infoView makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(pageScrollView);
        make.top.bottom.offset(0);
        make.left.equalTo(self.electricPileTableView.mas_right);
    }];
    
    // 2.2.3评论
    UIView *commetView = [UIView new];
    commetView.backgroundColor = [UIColor greenColor];
    [pageScrollContainer addSubview:commetView];
    [commetView makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(pageScrollView);
        make.top.bottom.right.offset(0);
        make.left.equalTo(infoView.mas_right);
    }];
    
    
    // 配置悬浮框
    self.stickyViewArr = [NSMutableArray arrayWithCapacity:2];
    [self.stickyViewArr addObject:segmentStickyView];
}

#pragma mark - UITableView DataSource And Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"cell%@",@(indexPath.row)];
    return cell;
}

#pragma mark - Actions
- (void)handleScrollViewPanGesture:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.lastScrollViewOffset = self.scrollView.contentOffset;
        self.lastElectricPileTableViewOffset = self.electricPileTableView.contentOffset;
    }
    CGPoint gestureOffset = [sender translationInView:sender.view];
    CGFloat expectY = self.lastScrollViewOffset.y - gestureOffset.y;//上次外层scrollview的位置
//    NSLog(@">>>>>>orign:%@",NSStringFromCGPoint(self.lastScrollViewOffset));
//    NSLog(@">>>>>>pan:%@",NSStringFromCGPoint(gestureOffset));
//    NSLog(@"<<<<<<expect:%f",expectY);//向上移动时,外层scrollView应该滑动的距离
    CGFloat topOffset = SCREEN_HEIGHT - 64 + CGRectGetMinY(self.stickyViewArr[0].frame);
    if (gestureOffset.y < 0) {//向上
        if (expectY < topOffset) {
            [self.scrollView setContentOffset:CGPointMake(0, expectY)];
        }
        else {
            [self.scrollView setContentOffset:CGPointMake(0, topOffset)];
            [self.electricPileTableView setContentOffset:CGPointMake(0, self.lastElectricPileTableViewOffset.y + expectY - topOffset)];
        }
    }
    else {//向下
        if (self.lastElectricPileTableViewOffset.y > topOffset - expectY) {//滑动table
            [self.electricPileTableView setContentOffset:CGPointMake(0, self.lastElectricPileTableViewOffset.y + expectY - topOffset)];
        }
        else {//固定table,滑动外层scrollView
            [self.electricPileTableView setContentOffset:CGPointMake(0, 0)];
            [self.scrollView setContentOffset:CGPointMake(0, self.lastScrollViewOffset.y - gestureOffset.y + self.lastElectricPileTableViewOffset.y)];
        }
    }
    
    
    
    
}

- (IBAction)show:(UIButton *)sender {
    [self.scrollView showBriefInfo];
}

@end
