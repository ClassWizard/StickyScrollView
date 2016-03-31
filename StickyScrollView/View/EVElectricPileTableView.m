//
//  EVElectricPileTableView.m
//  StickyScrollView
//
//  Created by ClassWizard on 16/3/31.
//  Copyright © 2016年 ClassWizard. All rights reserved.
//

#import "EVElectricPileTableView.h"

@implementation EVElectricPileTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - UIGestureRecognizer Delegate
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//    NSLog(@"手势代理");
//    return NO;
//}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    NSLog(@"手势shouldRequireFailureOfGestureRecognizer");
//    return YES;
//}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceivePress:(UIPress *)press {
//    NSLog(@"手势shouldReceivePress");
//    return YES;
//}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
//    NSLog(@"手势shouldReceiveTouch");
//    return YES;
//}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    NSLog(@"手势shouldRecognizeSimultaneouslyWithGestureRecognizer");
    
    return YES;
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    NSLog(@"手势shouldBeRequiredToFailByGestureRecognizer");
//    return YES;
//}

@end

//2016-03-31 15:48:35.540 StickyScrollView[5404:2180034] PanGesture:<UIScrollViewPanGestureRecognizer: 0x127d596b0; state = Possible; delaysTouchesEnded = NO; view = <EVElectricPileTableView 0x1280dd400>; target= <(action=handlePan:, target=<EVElectricPileTableView 0x1280dd400>)>>