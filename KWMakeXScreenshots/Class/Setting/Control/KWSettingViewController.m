//
//  KWSettingViewController.m
//  KWMakeXScreenshots
//
//  Created by korwin on 2018/2/17.
//  Copyright © 2018年 korwin. All rights reserved.
//

#import "KWSettingViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <MessageUI/MessageUI.h>
#import "KWHelpViewController.h"
#import "KWQuestionsViewController.h"
#import "Utils.h"

@import GoogleMobileAds;

@interface KWSettingViewController ()<MFMailComposeViewControllerDelegate>

@property(nonatomic,assign) NSInteger settingVcCount;

@end

@implementation KWSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.settingVcCount = rewardCount;
    self.navigationItem.title = @"设置";
    self.tableView = [[UITableView alloc]initWithFrame:self.tableView.bounds style:UITableViewStyleGrouped];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (section == 0) {
//        return 1;
//    } else
    if (section == 0) {
        return 2;
    } else if (section == 1) {
        return 1;
    } else if (section == 2) {
        return 3;
    } else if (section == 3) {
        return 2;
    } else
        return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    if (section == 0) {
//        return @"奖励";
//    } else
    if (section == 0) {
        return @"帮助";
    } else if (section == 1) {
        return @"样张";
    } else if (section == 2) {
        return @"联系";
    } else if (section == 3) {
        return @"贡献";
    } else if (section == 4) {
        return @"关于";
    } else return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    
//    if (indexPath.section == 0) {
//        cell.textLabel.text = [NSString stringWithFormat:@"剩余次数:%ld",rewardCount];
//        cell.imageView.image = [UIImage imageNamed:@"envelope"];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        return cell;
//    }else
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"使用说明";
            cell.imageView.image = [UIImage imageNamed:@"bookmark"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        } else {
            cell.textLabel.text = @"常见问题";
            cell.imageView.image = [UIImage imageNamed:@"question-circle"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
    } else if (indexPath.section == 1) {
        cell.textLabel.text = @"各类APP样张";
        cell.imageView.image = [UIImage imageNamed:@"image"];
        return cell;
    } else if(indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"korwin.zhang@gmail.com";
            cell.imageView.image = [UIImage imageNamed:@"envelope"];
            return cell;
        } if (indexPath.row == 1) {
            cell.textLabel.text = @"@Korwin";
            cell.imageView.image = [UIImage imageNamed:@"c"];
            return cell;
        } else {
            cell.textLabel.text = @"@我的你的K";
            cell.imageView.image = [UIImage imageNamed:@"weibo"];
            return cell;
        }
    } else if(indexPath.section == 3) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"去App Store评分";
            cell.imageView.image = [UIImage imageNamed:@"star"];
            return cell;
        } else {
            cell.textLabel.text = @"推荐给好友";
            cell.imageView.image = [UIImage imageNamed:@"share-alt"];
            return cell;
        }
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell2"];
        cell.textLabel.text = @"版本";
        cell.detailTextLabel.text = @"1.0";
        cell.imageView.image = [UIImage imageNamed:@"code-fork"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
//    if (indexPath.section == 0) {
//        [self getReward];
//    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self toHelpVc];
        } else {
            [self toQuestionVc];
        }
    } else if (indexPath.section == 1) {
        [self toTestVc];
    } else if(indexPath.section == 2) {
        if (indexPath.row == 0) {
            [self sendEmailVc];
        } else if (indexPath.row == 2) {
            [self toTwitterVc];
        } else {
            [self toSinaVc];
        }
    } else if(indexPath.section == 3) {
        if (indexPath.row == 0) {
            [self toAppStoreVc];
        } else {
            [self toShareVc];
        }
    } else {
        
    }
}

- (void)toTestVc {
    static NSString * const reviewURL = @"https://www.jianshu.com/p/5d153e9bd6de";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:reviewURL]];
}

- (void)toAppStoreVc {
    static NSString * const reviewURL = @"itms-apps://itunes.apple.com/cn/app/id1353774556?mt=8&action=write-review";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:reviewURL]];
}

#warning 分享APP
- (void)toShareVc {
    //https://itunes.apple.com/app/id1346521270
    NSURL *reviewURL = [NSURL URLWithString:@"https://itunes.apple.com/cn/app/%E8%8C%B6%E7%8F%82/id1353774556?mt=8"];
    NSArray *appURL = @[reviewURL];
    UIActivityViewController *activityController=[[UIActivityViewController alloc]initWithActivityItems:appURL applicationActivities:nil];
    [self.navigationController presentViewController:activityController animated:YES completion:nil];
}

- (void)toTwitterVc {
    static NSString * const reviewURL = @"https://twitter.com/KorwinShan";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:reviewURL]];
}

- (void)toSinaVc {
    static NSString * const reviewURL = @"https://www.weibo.com/5318353308/profile?rightmod=1&wvr=6&mod=personinfo&is_all=1";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:reviewURL]];
}

#pragma mark - 跳转帮助页面
- (void)toHelpVc {
    KWHelpViewController *helpVc = [[KWHelpViewController alloc]init];
    [self.navigationController pushViewController:helpVc animated:YES];
}

#pragma mark - 跳转常见问题
- (void)toQuestionVc {
    KWQuestionsViewController *questionVc = [[KWQuestionsViewController alloc]init];
    [self.navigationController pushViewController:questionVc animated:YES];
}

#pragma mark - send Email
- (void)sendEmailVc {
    //判断用户是否已设置邮件账户
    if ([MFMailComposeViewController canSendMail]) {
        [self sendEmailAction]; // 调用发送邮件的代码
    }else{
        //给出提示,设备未开启邮件服务
    }
}

-(void)sendEmailAction{
    // 创建邮件发送界面
    MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
    // 设置邮件代理
    [mailCompose setMailComposeDelegate:self];
    // 设置收件人
    [mailCompose setToRecipients:@[@"korwin.zhang@gmail.com"]];
    // 弹出邮件发送视图
    [self.navigationController presentViewController:mailCompose animated:YES completion:nil];
}

#pragma mark - MFMailComposeViewControllerDelegate的代理方法：
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail send canceled: 用户取消编辑");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: 用户保存邮件");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent: 用户点击发送");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail send errored: %@ : 用户尝试保存或发送邮件失败", [error localizedDescription]);
            break;
    }
    // 关闭邮件发送视图
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 广告增加次数
- (void)getReward {
    if ([[GADRewardBasedVideoAd sharedInstance] isReady]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [[GADRewardBasedVideoAd sharedInstance] presentFromRootViewController:self];
            });
            sleep(1);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
                [Utils updateCache:@"Reward" andID:@"PopSingle" andValue:@"0"];//标记变为0
            });
        });
    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [SVProgressHUD show];
            sleep(0.5);
            [SVProgressHUD showErrorWithStatus:@"广告尚未准备好,请稍等"];
            sleep(1);
            [SVProgressHUD dismiss];
        });
    }
    
}

@end
