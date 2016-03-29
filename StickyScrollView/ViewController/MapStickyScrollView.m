//
//  MapStickyScrollView.m
//  StickyScrollView
//
//  Created by ClassWizard on 16/3/22.
//  Copyright © 2016年 ClassWizard. All rights reserved.
//

#import "MapStickyScrollView.h"
#import "PassThroughScrollView.h"
#import "StationInfoView.h"

@interface MapStickyScrollView () <UIScrollViewDelegate,MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet PassThroughScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *scrollContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeight;

@end

@implementation MapStickyScrollView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
//    self.scrollView.ownController = self;
    [self addAnnotations];
    
//    StationInfoView *stationInfoView = [UINib nibWithNibName:<#(nonnull NSString *)#> bundle:<#(nullable NSBundle *)#>]

}

- (void)addAnnotations {
    MKPointAnnotation *pin = [[MKPointAnnotation alloc] init];
    pin.coordinate = CLLocationCoordinate2DMake(30.54432, 104.065988);
    [self.mapView addAnnotation:pin];
    pin.title = @"成都";
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"offset:%@",NSStringFromCGPoint(scrollView.contentOffset));
    NSLog(@"maxY:%f",CGRectGetMaxY(self.scrollContentView.frame));
    
    //修改底部遮挡视图约束
    CGFloat height = scrollView.contentOffset.y - (CGRectGetMaxY(self.scrollContentView.frame) - (self.view.bounds.size.height - 64));
    self.bottomHeight.constant = MAX(height, 0);
    NSLog(@"height:%f",height);
}

#pragma mark - MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    NSLog(@"点击了mark:%@",view);
}


@end
