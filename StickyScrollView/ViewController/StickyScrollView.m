//
//  StickyScrollView.m
//  StickyScrollView
//
//  Created by ClassWizard on 16/3/21.
//  Copyright © 2016年 ClassWizard. All rights reserved.
//

#import "StickyScrollView.h"

@interface StickyScrollView () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *stickyViewOne;
@property (weak, nonatomic) IBOutlet UIView *stickyViewTwo;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) NSMutableArray<UIView *> *stickyViewArr;

@property (strong, nonatomic) UIView *viewOne;
@property (strong, nonatomic) UIView *viewTwo;

@end

@implementation StickyScrollView
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - UI

/**
 *  建立UI
 *  1.显式UI
 *  2.悬浮框UI
 */

- (void)setupUI {
    //1.故事版实现
    //2.
    self.scrollView.delegate = self;
    self.title = @"Frame实现";
    
    //2.1 顶部悬浮框
    CGRect frame = self.stickyViewOne.bounds;
    frame.origin.y += 64;
    self.viewOne = [[UIView alloc] initWithFrame:frame];
    self.viewOne.backgroundColor = [UIColor yellowColor];
    self.viewOne.hidden = YES;//默认隐藏
    [self.view addSubview:self.viewOne];
    
    //2.2 中部悬浮框
    frame = self.stickyViewTwo.bounds;
    frame.origin.y = CGRectGetMaxY(self.viewOne.frame) - frame.size.height;
    self.viewTwo = [[UIView alloc] initWithFrame:frame];
    self.viewTwo.backgroundColor = [UIColor whiteColor];
    self.viewTwo.hidden = YES;//默认隐藏
    [self.view addSubview:self.viewTwo];
    
    //2.3 添加数组
    [self.stickyViewArr addObject:self.viewOne];
    [self.stickyViewArr addObject:self.viewTwo];
    
    //将顶部悬浮框置顶
    [self.view bringSubviewToFront:self.viewOne];
}

/**
 *  区域
 
  屏幕     <- : 表示滚动视图使ScorllView顶部至此(如有显示的悬浮框,则为最后一个显示的悬浮框的maxY)
 
 ------------------------
 |文本一                 |
 |                      |
 |                      |   <- 屏幕顶部至此:无
 |                      |                                         0
 ------------------------   <- 悬浮一顶部重合就开始处理       ------ 分界 ------
 |悬浮一                 |   <- 右移操作
 |                      |                                         1
 ------------------------   <- 结束对悬浮一的操作            ------ 分界 ------
 |文本二                 |
 |                      |
 |                      |
 |                      |
 ------------------------
 |悬浮二                 |
 |                      |                                          2
 ------------------------   <- 悬浮二底部重合才开始处理        ------ 分界 ------
 |文本三                 |   <- 下移操作      |_
 |                      |                   |  悬浮二的高度          3
 |                      |   <- 结束对悬浮二的操作             ------ 分界 ------
 |                      |                                          4
 ------------------------
 
 根据悬浮框个数n返回2n+1个区域,如上例,2个悬浮框,上下分别一个分界(共4个)返回5个区域(0-4)

 */

- (NSUInteger)offsetYSection:(CGFloat)offsetY {
    if (offsetY < CGRectGetMinY(self.stickyViewOne.frame)) {
        return 0;
    }
    else if (offsetY < CGRectGetMaxY(self.stickyViewOne.frame)) {
        return 1;
    }
    else if (offsetY + CGRectGetHeight(self.viewOne.frame) < CGRectGetMaxY(self.stickyViewTwo.frame)) {
        return 2;
    }
    else if (offsetY + CGRectGetHeight(self.viewOne.frame) < CGRectGetMaxY(self.stickyViewTwo.frame) + CGRectGetHeight(self.viewTwo.frame)) {
        return 3;
    }
    else {
        return 4;
    }
}

#pragma mark - UIScrollView Delegate
/**
 *  处理流程:
 *      悬浮框开始---结束区域
 *  1.当前悬浮框显示
 *  2.当前悬浮框移动操作
 *  3.文本中对应当前悬浮框的隐藏
 *      上一个悬浮框结束---下一个悬浮框开始区域
 *  4.下一个悬浮框的隐藏
 *  5.文本中对应的下一个悬浮框显示
 *  6.上一个悬浮框的最终位置
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"%@",NSStringFromCGPoint(scrollView.contentOffset));
    switch ([self offsetYSection:scrollView.contentOffset.y]) {
        case 0://顶部
            NSLog(@"top");
            //隐藏第一个悬浮框
            self.viewOne.hidden = YES;
            //显示原文的stickyView;
            self.stickyViewOne.hidden = NO;
            break;
        case 1://第一个悬浮框开始
            NSLog(@"fist begin");
            //右移
            CGRect frame = self.viewOne.frame;
            frame.origin.x = scrollView.contentOffset.y - CGRectGetMinY(self.stickyViewOne.frame);
            self.viewOne.frame = frame;
            self.viewOne.hidden = NO;
            //隐藏原文的stickyView;
            self.stickyViewOne.hidden = YES;
            break;
        case 2://第一个悬浮框结束
            NSLog(@"中间区域");
            //将第一个悬浮框设置到最终位置
            frame = self.viewOne.frame;
            frame.origin.x = CGRectGetMaxY(self.stickyViewOne.frame) - CGRectGetMinY(self.stickyViewOne.frame);
            self.viewOne.frame = frame;
            //隐藏第二个悬浮框
            self.viewTwo.hidden = YES;
            break;
        case 3://第二个悬浮框开始
            NSLog(@"second begin");
            //显示悬浮二
            self.viewTwo.hidden = NO;
            //悬浮二下移
            frame = self.viewTwo.frame;
            //起点+偏移
            frame.origin.y = (CGRectGetMaxY(self.viewOne.frame) - frame.size.height) + (scrollView.contentOffset.y + CGRectGetHeight(self.viewOne.frame) - CGRectGetMaxY(self.stickyViewTwo.frame));
            self.viewTwo.frame = frame;
            break;
        case 4://第二个悬浮结束
            NSLog(@"bottom");
            //设置第二个悬浮框至终点位置
            frame = self.viewTwo.frame;
            frame.origin.y = CGRectGetMaxY(self.viewOne.frame);
            self.viewTwo.frame = frame;
            break;
        default:
            break;
    }
}

@end
