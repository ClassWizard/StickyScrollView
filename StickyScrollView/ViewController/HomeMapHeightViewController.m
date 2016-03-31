//
//  HomeMapHeightViewController.m
//  StickyScrollView
//
//  Created by ClassWizard on 16/3/31.
//  Copyright © 2016年 ClassWizard. All rights reserved.
//

#import "HomeMapHeightViewController.h"
#import "EVPassThroughScrollView.h"
#import <MapKit/MapKit.h>
#import "EVStationInfoView.h"

static CGFloat cellHeight = 44;

@interface HomeMapHeightViewController ()<MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) MKMapView *myMapView;
@property (nonatomic, strong) EVPassThroughScrollView *scrollView;
@property (nonatomic, strong) UIScrollView *pageScrollView;
@property (nonatomic, strong) UITableView *electricPileTableView;
@property (nonatomic, strong) EVStationInfoView *infoView;
//悬浮框相关
@property (nonatomic, strong) UIView *segmentStickyView;
@property (nonatomic, strong) UIView *segmentView;
//数据源
@property (nonatomic, strong) NSMutableArray *pileArr;
//底部背景图
@property (nonatomic, strong) UIView *bottomBackgroundView;

@end

@implementation HomeMapHeightViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupMap];
    [self setupScrollView];
}

- (void)dealloc {
    [self.segmentStickyView removeFromSuperview];
    [self.scrollView removeFromSuperview];
    [self.bottomBackgroundView removeFromSuperview];
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
    // 1.外部滚动视图
    self.scrollView = [[EVPassThroughScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    self.scrollView.delegate = self;
    //由于要遮罩标签栏,所以放在keyWindow上
    NSArray *windows = [UIApplication sharedApplication].windows;
    [windows.firstObject addSubview:self.scrollView];
    
    //如果bounce为YES 则需要底部处理
    self.scrollView.bounces = YES;
    self.bottomBackgroundView = [[UIView alloc] init];
    self.bottomBackgroundView.backgroundColor = [UIColor whiteColor];
    [windows.firstObject addSubview:self.bottomBackgroundView];
    [self.bottomBackgroundView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.equalTo(0);
    }];
    
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
    self.segmentView = [UIView new];
    self.segmentView.backgroundColor = [UIColor purpleColor];
    [briefInfoView addSubview:self.segmentView];
    [self.segmentView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.equalTo(44);
    }];
    
    // 2.2横向ScrollView
    self.pageScrollView = [UIScrollView new];
    self.pageScrollView.delegate = self;
    self.pageScrollView.pagingEnabled = YES;
    self.pageScrollView.bounces = NO;
    self.pageScrollView.showsHorizontalScrollIndicator = NO;
    [self.scrollView.contentView addSubview:self.pageScrollView];
    self.pageScrollView.backgroundColor = [UIColor blueColor];
    [self.pageScrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(briefInfoView.mas_bottom);
        make.left.right.offset(0);
        make.height.equalTo([self pileTableHeight]);
        make.bottom.offset(0);
    }];
    UIView *pageScrollContainer = [UIView new];
    [self.pageScrollView addSubview:pageScrollContainer];
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
        make.size.equalTo(self.pageScrollView);
        make.top.left.bottom.offset(0);
    }];
    
    // 2.2.2信息
    self.infoView = [[EVStationInfoView alloc] init];
    [pageScrollContainer addSubview:self.infoView];
    [self.infoView makeConstraints:^(MASConstraintMaker *make) {
//        make.size.equalTo(pageScrollView);
        make.width.equalTo(self.pageScrollView);
        make.height.equalTo([self infoViewHeight]);
        make.top.offset(0);
        make.left.equalTo(self.electricPileTableView.mas_right);
    }];
    
    
    
    // 2.2.3评论
    UIView *commetView = [UIView new];
    commetView.backgroundColor = [UIColor greenColor];
    [pageScrollContainer addSubview:commetView];
    [commetView makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.pageScrollView);
        make.top.bottom.right.offset(0);
        make.left.equalTo(self.infoView.mas_right);
    }];
    
    
    // 配置悬浮框
    self.segmentStickyView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 44)];
    self.segmentStickyView.backgroundColor = [UIColor purpleColor];
    self.segmentStickyView.hidden = YES;
    [windows.firstObject addSubview:self.segmentStickyView];
}

#pragma mark - UITableView DataSource And Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.pileArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.pileArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}
- (IBAction)show:(id)sender {
    [self.scrollView showBriefInfo];
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isKindOfClass:[EVPassThroughScrollView class]]) {
        NSLog(@"--外scroll--%@",NSStringFromCGPoint(scrollView.contentOffset));
        //悬浮框
        if (scrollView.contentOffset.y < SCREEN_HEIGHT - 64 + CGRectGetMinY(self.segmentView.frame)) {
            self.segmentStickyView.hidden = YES;
        }
        else {
            self.segmentStickyView.hidden = NO;
        }
        //修改底部遮挡视图约束
        CGFloat height = scrollView.contentOffset.y - CGRectGetMaxY(self.electricPileTableView.frame) - 300;
        NSLog(@"height:%@",@(height));
        NSLog(@"tableY:%f",CGRectGetMaxY(self.electricPileTableView.frame));
        [self.bottomBackgroundView updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(MAX(height, 0));
        }];
        
        switch ([self offsetYSection:scrollView.contentOffset.y]) {
            case 0://顶部
                NSLog(@"top");
                break;
            case 1://顶部贴边
                NSLog(@"贴边");
                break;
            case 2://第一个悬浮框开始
                NSLog(@"first begin");
                break;
            case 3://第一个悬浮框结束
                NSLog(@"first end,中间区域");
                break;
            default:
                break;
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.pageScrollView) {
        int currentPage = scrollView.contentOffset.x / SCREEN_WIDTH;
        NSLog(@"currentPage:%d",currentPage);
        
        switch (currentPage) {
            case 0: {
                [self.pageScrollView updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo([self pileTableHeight]);
                }];
                [UIView animateWithDuration:0.5 animations:^{
                    [self.scrollView layoutIfNeeded];
                }];
            }
                break;
            case 1: {
                [self.pageScrollView updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo([self infoViewHeight]);
                }];
                [UIView animateWithDuration:0.5 animations:^{
                    [self.scrollView layoutIfNeeded];
                }];
            }
                break;
            case 2: {
                [self.pageScrollView updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo([self pileTableHeight]);
                }];
                [UIView animateWithDuration:0.5 animations:^{
                    [self.scrollView layoutIfNeeded];
                }];
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark - Helper
- (CGFloat)pileTableHeight {
    return  MAX(SCREEN_HEIGHT - 64 - 44, self.pileArr.count * cellHeight);
}

- (CGFloat)infoViewHeight {
    return MAX(SCREEN_HEIGHT - 64 - 44, 300);
}

- (NSUInteger)offsetYSection:(CGFloat)offsetY {
    //分区
    if (offsetY < SCREEN_HEIGHT - 64) {
        return 0;
    }
    else if (offsetY < SCREEN_HEIGHT - 64 + CGRectGetMinY(self.segmentView.frame)) {
        return 1;
    }
    else if (offsetY < SCREEN_HEIGHT - 64 + CGRectGetMaxY(self.segmentView.frame)) {
        return 2;
    }
    else {
        return 3;
    }
}

#pragma mark - 模拟DataSource
- (NSMutableArray *)pileArr {
    if (!_pileArr) {
        _pileArr = [NSMutableArray arrayWithCapacity:40];
        for (NSInteger i = 1; i <= 25; i++) {
            [_pileArr addObject:[NSString stringWithFormat:@"桩位%@",@(i)]];
        }
    }
    return _pileArr;
}

@end
