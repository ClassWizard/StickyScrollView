//
//  EVPassThroughScrollView.m
//  EVCharger
//
//  Created by ClassWizard on 16/3/30.
//  Copyright © 2016年 DianZhuangTechnology. All rights reserved.
//

#import "EVPassThroughScrollView.h"
#import "Masonry.h"

@interface EVPassThroughScrollView ()

@property (nonatomic, strong) UIView *clearView;//穿透区域

@end

@implementation EVPassThroughScrollView

static CGFloat briefInfoHeight = 300;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.bounces = NO;
        //穿透区域
        self.clearView = [UIView new];
        [self addSubview:self.clearView];
        [self.clearView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_offset(0);
            make.size.equalTo(self);
        }];
        //内容区域
        self.contentView = [UIView new];
        self.contentView.backgroundColor = [UIColor yellowColor];
        [self addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_offset(0);
            make.top.equalTo(self.clearView.mas_bottom);
//            make.height.equalTo(800);//先随便写一个
        }];
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    if ([hitView isEqual:self.clearView]) {
        return nil;//如果事件点击在透明区域,不传递,设置nil使其穿透
        //或者用下面的方法才是正解...
        //        UIView *calloutView = self.ownController.mapView;
        //        CGPoint pointInCalloutView = [self convertPoint:point toView:calloutView];
        //        hitView = [calloutView hitTest:pointInCalloutView withEvent:event];
    }
    return hitView;
}

- (void)hide {
    [self setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)showBriefInfo {
    [self setContentOffset:CGPointMake(0, briefInfoHeight) animated:YES];
}

- (CGFloat)minOffsetY {
    return briefInfoHeight;
}
@end
