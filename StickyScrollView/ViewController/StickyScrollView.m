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
    
    if ((scrollView.contentOffset.y + 64) < CGRectGetMinY(self.stickyViewOne.frame)) {
        NSLog(@"top");
        //销毁第一个悬浮框
        [self.viewOne removeFromSuperview];
        self.viewOne = nil;
        //显示stickyView;
        self.stickyViewOne.hidden = NO;
    }
    else if (scrollView.contentOffset.y + 64 < CGRectGetMaxY(self.stickyViewOne.frame)) {
        //第一个悬浮框开始
        NSLog(@"fist begin");
        CGRect frame = self.viewOne.frame;
        frame.origin.x = scrollView.contentOffset.y + 64 - CGRectGetMinY(self.stickyViewOne.frame);
        self.viewOne.frame = frame;
        [self.view addSubview:self.viewOne];
        //隐藏stickyView;
        self.stickyViewOne.hidden = YES;
    }
    else if (scrollView.contentOffset.y + 64 < CGRectGetMinY(self.stickyViewTwo.frame) - self.viewOne.frame.size.height + self.stickyViewTwo.frame.size.height) {
        // 404 = 460 - 100 + 44
        //第二个悬浮框开始
        NSLog(@"中间区域");
    }
    else if (scrollView.contentOffset.y + 64 < CGRectGetMaxY(self.stickyViewTwo.frame) - self.stickyViewTwo.frame.size.height){
        // 384 + 64 =
        //上个区域到这个条件为第二个悬浮框区域
        NSLog(@"second begin");
        [self.view addSubview:self.viewTwo];
    }
    else {
        NSLog(@"bottom");
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
