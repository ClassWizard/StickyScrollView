//
//  EVStationInfoView.m
//  StickyScrollView
//
//  Created by ClassWizard on 16/3/31.
//  Copyright © 2016年 ClassWizard. All rights reserved.
//

#import "EVStationInfoView.h"

@implementation EVStationInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIView *scoreView = [[UIView alloc] init];
    scoreView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:scoreView];
    
    [scoreView makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(15);
        make.left.right.offset(0);
        make.height.equalTo(44);
    }];
    
    UILabel *scoreLabel = [[UILabel alloc] init];
    scoreLabel.text = @"站点评分";
    [scoreView addSubview:scoreLabel];
    
    [scoreLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.left.offset(15);
    }];
    
    UIView *lastView = scoreView;
    
    UIView *picView = [[UIView alloc] init];
    picView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:picView];
    [picView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastView.mas_bottom).offset(10);
        make.left.right.offset(0);
        make.height.equalTo(60);
    }];
    
    lastView = picView;
    
    UIView *openTimeView = [[UIView alloc] init];
    openTimeView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:openTimeView];
    [openTimeView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastView.mas_bottom).offset(10);
        make.left.right.offset(0);
        make.height.equalTo(120);
    }];
    
    lastView = openTimeView;
    
    UIView *chargeCostView = [[UIView alloc] init];
    chargeCostView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:chargeCostView];
    [chargeCostView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastView.mas_bottom).offset(10);
        make.left.right.offset(0);
        make.height.equalTo(300);
    }];
    
    lastView = nil;
    
    
}

@end
