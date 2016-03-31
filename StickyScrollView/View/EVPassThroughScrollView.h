//
//  EVPassThroughScrollView.h
//  EVCharger
//
//  Created by ClassWizard on 16/3/30.
//  Copyright © 2016年 DianZhuangTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVPassThroughScrollView : UIScrollView

@property (nonatomic, strong) UIView *contentView;//内容区域,必须设置高度
@property (nonatomic, assign, readonly) CGFloat minOffsetY;

- (void)showBriefInfo;
- (void)hide;

@end
