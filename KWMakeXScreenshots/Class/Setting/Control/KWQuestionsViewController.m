//
//  KWQuestionsViewController.m
//  KWMakeXScreenshots
//
//  Created by korwin on 2018/2/26.
//  Copyright © 2018年 korwin. All rights reserved.
//

#import "KWQuestionsViewController.h"
#import "KWQuestionViewCell.h"
#import <TYAttributedLabel/TYAttributedLabel.h>

@interface KWQuestionsViewController ()

@end

@implementation KWQuestionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"常见问题";
    self.tableView.estimatedRowHeight=44;
    self.tableView.rowHeight=UITableViewAutomaticDimension;
    
    self.tableView = [[UITableView alloc]initWithFrame:self.tableView.bounds style:UITableViewStylePlain];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([KWQuestionsViewController class]) bundle:nil] forCellReuseIdentifier:@"questionCell"];//注册cell-重用
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KWQuestionViewCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([KWQuestionViewCell class]) owner:nil options:nil][0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        cell.questionLabel.text = @"iXShot可以制作任何类型的「iPhone X」截图吗？\n";
        cell.answerLabel.text = @"目前仅支持「顶部带导航栏」的APP界面截图，和部分网页截图，后续会持续优化并增加新功能。\n";
    } else if (indexPath.section == 1) {
        cell.questionLabel.text = @"iXShot支持「iPhone X」吗\n";
        cell.answerLabel.text = @"iXShot是针对非「iPhone X」用户，也可以截取分享与「iPhone X」一样的截图，截图虽然不完全与「iPhone X」一模，但也十分接近，是根据「iPhone X」截图规格计算而来的，对于一些不够精确的会在后续版本递送中优化。「iPhone X」用户请使用系统截图。\n";
    } else if (indexPath.section == 2) {
        cell.questionLabel.text = @"对于一些「底部标签栏」颜色不匹配怎么办？\n";
        cell.answerLabel.text = @"1.可以点击左下角按钮，通过放大「截图一」，点击「底部标签栏」颜色获取。由于目前技术问题，对于渐变颜色的「底部标签栏」无法做到匹配对应颜色，还请见谅，会在后续版本继续优化。\n2.可以更换成「无标签栏」样式解决。\n";
    } else if (indexPath.section == 3) {
        cell.questionLabel.text = @"对于一些「顶部导航栏」颜色不匹配怎么办？\n";
        cell.answerLabel.text = @"可以点击左下角按钮，通过放大「截图一」，点击「顶部导航栏」颜色获取。由于目前技术问题，对于渐变颜色的「顶部导航栏」无法做到匹配对应颜色，还请见谅，会在后续版本继续优化。\n";
    } else if (indexPath.section == 4) {
        cell.questionLabel.text = @"支持「Safari浏览器」截图的制作吗？\n";
        cell.answerLabel.text = @"大部分支持，对于一些特殊情况可能不支持。\n";
    } else if (indexPath.section == 5) {
        cell.questionLabel.text = @"其他情况\n";
        cell.answerLabel.text = @"如果以上的问题并没有包括您遇到的情况，请您发送邮件反馈问题。请返回到「设置页面」→「联系」→「点击邮箱」\n";
        return cell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
}

@end
