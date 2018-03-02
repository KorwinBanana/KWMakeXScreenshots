//
//  KWHelpViewController.m
//  KWMakeXScreenshots
//
//  Created by korwin on 2018/2/26.
//  Copyright © 2018年 korwin. All rights reserved.
//

#import "KWHelpViewController.h"
#import <Masonry/Masonry.h>
@import GoogleMobileAds;


@interface KWHelpViewController ()<GADBannerViewDelegate>

@property (nonatomic,strong) UIImageView *HelpView;//初始界面
@property(nonatomic, strong) GADBannerView *bannerView;


@end

@implementation KWHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"使用说明";
    [self setupHelpView];
    
    // In this case, we instantiate the banner with desired ad size.
    self.bannerView = [[GADBannerView alloc]
                       initWithAdSize:kGADAdSizeBanner];
    
    self.bannerView.adUnitID = @"ca-app-pub-3589264864117411/2616836317";
    self.bannerView.rootViewController = self;
    [self addBannerViewToView:_bannerView];
    self.bannerView.delegate = self;

    [self.bannerView loadRequest:[GADRequest request]];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupHelpView {
    self.HelpView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"help"]];
    [self.view addSubview:self.HelpView];
    [self.HelpView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
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
