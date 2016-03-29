//
//  PassThroughScrollView.m
//  StickyScrollView
//
//  Created by ClassWizard on 16/3/22.
//  Copyright © 2016年 ClassWizard. All rights reserved.
//

//#import "MapStickyScrollView.h"
#import "PassThroughScrollView.h"

@interface PassThroughScrollView ()

@property (strong, nonatomic) IBOutlet UIView *clearView;

@end

@implementation PassThroughScrollView

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

@end
