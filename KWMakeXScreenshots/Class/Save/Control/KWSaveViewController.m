//
//  KWSaveViewController.m
//  KWMakeXScreenshots
//
//  Created by korwin on 2018/2/21.
//  Copyright © 2018年 korwin. All rights reserved.
//

#import "KWSaveViewController.h"
#import "KWVisitViewController.h"
#import <Social/Social.h>
@import GoogleMobileAds;

#import "ViewController.h"

@interface KWSaveViewController ()<GADBannerViewDelegate>

@property(nonatomic, strong) GADBannerView *bannerView;
@property (weak, nonatomic) IBOutlet UIView *visitView;
@property (weak, nonatomic) IBOutlet UIView *shareView;
@property (weak, nonatomic) IBOutlet UIView *doneView;

@end

@implementation KWSaveViewController
- (IBAction)toVisitVC:(id)sender {
    KWVisitViewController *VisitVC = [[KWVisitViewController alloc]init];
    VisitVC.iXImage = self.iXImage;
    [self.navigationController pushViewController:VisitVC animated:YES];
}
- (IBAction)share:(id)sender {
    NSArray *images = @[self.iXImage];
    UIActivityViewController *activityController=[[UIActivityViewController alloc]initWithActivityItems:images applicationActivities:nil];
    [self.navigationController presentViewController:activityController animated:YES completion:nil];
}
- (IBAction)done:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"已保存";
    
    [self initButtonView];
    // In this case, we instantiate the banner with desired ad size.
    self.bannerView = [[GADBannerView alloc]
                       initWithAdSize:kGADAdSizeBanner];
    self.bannerView.adUnitID = @"ca-app-pub-3589264864117411/8040074451";
    self.bannerView.rootViewController = self;
    [self.bannerView loadRequest:[GADRequest request]];
    [self addBannerViewToView:_bannerView];
    self.bannerView.delegate = self;
}

- (void)initButtonView {
    //设置阴影和圆角
    self.visitView.layer.cornerRadius = 40;
    self.visitView.backgroundColor = [Utils colorWithHexString:@"515151"];
    
    self.shareView.layer.cornerRadius = 10;
    self.shareView.layer.borderWidth = 1.5;
    self.shareView.layer.borderColor = [UIColor grayColor].CGColor;
    
    self.doneView.layer.cornerRadius = 10;
    self.doneView.layer.borderWidth = 1.5;
    self.doneView.layer.borderColor = [UIColor grayColor].CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addBannerViewToView:(UIView *)bannerView {
    bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:bannerView];
    [self.view addConstraints:@[
                                [NSLayoutConstraint constraintWithItem:bannerView
                                                             attribute:NSLayoutAttributeBottom
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.bottomLayoutGuide
                                                             attribute:NSLayoutAttributeTop
                                                            multiplier:1
                                                              constant:0],
                                [NSLayoutConstraint constraintWithItem:bannerView
                                                             attribute:NSLayoutAttributeCenterX
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view
                                                             attribute:NSLayoutAttributeCenterX
                                                            multiplier:1
                                                              constant:0]
                                ]];
}

/// Tells the delegate an ad request loaded an ad.
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    NSLog(@"adViewDidReceiveAd");
}

/// Tells the delegate an ad request failed.
- (void)adView:(GADBannerView *)adView
didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"adView:didFailToReceiveAdWithError: %@", [error localizedDescription]);
}

/// Tells the delegate that a full-screen view will be presented in response
/// to the user clicking on an ad.
- (void)adViewWillPresentScreen:(GADBannerView *)adView {
    NSLog(@"adViewWillPresentScreen");
}

/// Tells the delegate that the full-screen view will be dismissed.
- (void)adViewWillDismissScreen:(GADBannerView *)adView {
    NSLog(@"adViewWillDismissScreen");
}

/// Tells the delegate that the full-screen view has been dismissed.
- (void)adViewDidDismissScreen:(GADBannerView *)adView {
    NSLog(@"adViewDidDismissScreen");
}

/// Tells the delegate that a user click will open another app (such as
/// the App Store), backgrounding the current app.
- (void)adViewWillLeaveApplication:(GADBannerView *)adView {
    NSLog(@"adViewWillLeaveApplication");
}
@end
