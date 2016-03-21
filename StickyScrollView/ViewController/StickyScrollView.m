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

@property (strong, nonatomic) NSMutableArray *stickyViewArr;

@property (strong, nonatomic) UIView *viewOne;
@property (strong, nonatomic) UIView *viewTwo;
@end

@implementation StickyScrollView
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView.delegate = self;
    
    NSLog(@"=========one:%@====%f=====",NSStringFromCGRect(self.stickyViewOne.frame),CGRectGetMinY(self.stickyViewOne.frame));
    NSLog(@"=========two:%@=======",NSStringFromCGRect(self.stickyViewTwo.frame));
    
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"%@",NSStringFromCGPoint(scrollView.contentOffset));
    
    if ((scrollView.contentOffset.y) < CGRectGetMinY(self.stickyViewOne.frame)) {
        NSLog(@"top");
        //销毁第一个悬浮框
        [self.viewOne removeFromSuperview];
        //显示stickyView;
        self.stickyViewOne.hidden = NO;
    }
    else if (scrollView.contentOffset.y < CGRectGetMaxY(self.stickyViewOne.frame)) {
        //第一个悬浮框开始
        NSLog(@"fist begin");
        //右移
        CGRect frame = self.viewOne.frame;
        frame.origin.x = scrollView.contentOffset.y - CGRectGetMinY(self.stickyViewOne.frame);
        self.viewOne.frame = frame;
        [self.view addSubview:self.viewOne];
        //隐藏stickyView;
        self.stickyViewOne.hidden = YES;
    }
    else if (scrollView.contentOffset.y < CGRectGetMaxY(self.stickyViewTwo.frame) - self.viewOne.frame.size.height) {
        //将第一个悬浮框设置到最终位置
        CGRect frame = self.viewOne.frame;
        frame.origin.x = CGRectGetMaxY(self.stickyViewOne.frame) - CGRectGetMinY(self.stickyViewOne.frame);
        self.viewOne.frame = frame;
        
        // 404 = 460 - 100 + 44
        //第二个悬浮框开始
        NSLog(@"中间区域");
        
        //销毁第二个悬浮框
        [self.viewTwo removeFromSuperview];
    }
    else if (scrollView.contentOffset.y < CGRectGetMaxY(self.stickyViewTwo.frame) - CGRectGetHeight(self.viewOne.frame) + CGRectGetHeight(self.viewTwo.frame)) {
        
        // 384 + 64 =
        //上个区域到这个条件为第二个悬浮框区域
        NSLog(@"second begin");
        [self.view addSubview:self.viewTwo];
        [self.view bringSubviewToFront:self.viewOne];\
        CGRect frame = self.viewTwo.frame;
        frame.origin.y = scrollView.contentOffset.y - 404 + CGRectGetMaxY(self.viewOne.frame) - frame.size.height;
        self.viewTwo.frame = frame;
    }
    else {
        NSLog(@"bottom");
        //设置第二个悬浮框至终点位置
        CGRect frame = self.viewTwo.frame;
        frame.origin.y = CGRectGetMaxY(self.viewOne.frame);
        self.viewTwo.frame = frame;
    }
}

#pragma mark - lazy load
- (NSMutableArray *)stickyViewArr {
    if (!_stickyViewArr) {
        _stickyViewArr = [NSMutableArray array];
        [_stickyViewArr addObject:self.stickyViewOne];
        [_stickyViewArr addObject:self.stickyViewTwo];
    }
    return _stickyViewArr;
}

- (UIView *)viewOne {
    if (!_viewOne) {
        CGRect frame = self.stickyViewOne.bounds;
        frame.origin.y += 64;
        _viewOne = [[UIView alloc] initWithFrame:frame];
        _viewOne.backgroundColor = [UIColor yellowColor];
    }
    return _viewOne;
}

- (UIView *)viewTwo {
    if (!_viewTwo) {
        CGRect frame = self.stickyViewTwo.bounds;
        frame.origin.y = CGRectGetMaxY(self.viewOne.frame) - frame.size.height;
        _viewTwo = [[UIView alloc] initWithFrame:frame];
        _viewTwo.backgroundColor = [UIColor whiteColor];
    }
    return _viewTwo;
}
@end
