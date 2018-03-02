//
//  AppDelegate.m
//  KWMakeXScreenshots
//
//  Created by korwin on 2018/2/14.
//  Copyright © 2018年 korwin. All rights reserved.
//

#import "AppDelegate.h"
#import "KWHomeViewController.h"
#import "KWNavigationViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "Utils.h"
#import "KWSettingViewController.h"
@import GoogleMobileAds;

#warning 激励视频V1.1 GADRewardBasedVideoAdDelegate
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];//设置APPHUD样式
    
    // Use Firebase library to configure APIs.
//    [FIRApp configure];
    // Initialize the Google Mobile Ads SDK.
    [GADMobileAds configureWithApplicationID:@"ca-app-pub-3589264864117411~1773037243"];
    
#warning 激励视频V1.1
    //剩余次数
//    NSInteger num = 5;
//    [Utils saveCache:@"AdMob" andID:@"Reward" andValue:[NSString stringWithFormat:@"%ld",num]];
    
    //激励视频
//    [GADRewardBasedVideoAd sharedInstance].delegate = self;
//    [[GADRewardBasedVideoAd sharedInstance] loadRequest:[GADRequest request]
//                                           withAdUnitID:@"ca-app-pub-3589264864117411/2275121194"];
        
    KWHomeViewController *homeVc = [[KWHomeViewController alloc]init];
    KWNavigationViewController *nv = [[KWNavigationViewController alloc]initWithRootViewController:homeVc];
    self.window.rootViewController = nv;
    
    [self.window makeKeyWindow];
    
    [NSThread sleepForTimeInterval:0.5];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#warning 激励视频V1.1
#pragma mark - GADRewardBasedVideoAd
//- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
//   didRewardUserWithReward:(GADAdReward *)reward {
////    NSString *rewardMessage =
////    [NSString stringWithFormat:@"Reward received with currency %@ , amount %lf",
////     reward.type,
////     [reward.amount doubleValue]];[Utils getCache:@"AdMob" andID:@"Reward"]
//
//    NSInteger numReward = [[Utils getCache:@"AdMob" andID:@"Reward"] integerValue];
//    NSLog(@"1 = %ld",numReward);
//    numReward = numReward + [reward.amount doubleValue];
//    NSLog(@"2 = %ld",numReward);
//
//    [Utils updateCache:@"AdMob" andID:@"Reward" andValue:[NSString stringWithFormat:@"%ld",numReward]];
//    NSLog(@"3 = %lf",[[Utils getCache:@"AdMob" andID:@"Reward"] doubleValue]);
//
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
//        [SVProgressHUD show];
//        sleep(1);
//        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"次数增加成功\n剩余次数:%ld",numReward]];
//        sleep(1);
//        [SVProgressHUD dismiss];
//    });
//
//}
//
//- (void)rewardBasedVideoAdDidReceiveAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
//    NSLog(@"Reward based video ad is received.");
//}
//
//- (void)rewardBasedVideoAdDidOpen:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
//    NSLog(@"Opened reward based video ad.");
//}
//
//- (void)rewardBasedVideoAdDidStartPlaying:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
//    NSLog(@"Reward based video ad started playing.");
//}
//
//- (void)rewardBasedVideoAdDidClose:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
//    NSLog(@"Reward based video ad is closed.");
//    [[GADRewardBasedVideoAd sharedInstance] loadRequest:[GADRequest request]
//                                           withAdUnitID:@"ca-app-pub-3589264864117411/2275121194"];
//}
//
//- (void)rewardBasedVideoAdWillLeaveApplication:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
//    NSLog(@"Reward based video ad will leave application.");
//}
//
//- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
//    didFailToLoadWithError:(NSError *)error {
//    NSLog(@"Reward based video ad failed to load.");
//    //失败
//    [[GADRewardBasedVideoAd sharedInstance] loadRequest:[GADRequest request]
//                                           withAdUnitID:@"ca-app-pub-3589264864117411/2275121194"];
//}


@end
