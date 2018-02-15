//
//  KWHomeIPViewController.m
//  KWMakeXScreenshots
//
//  Created by korwin on 2018/2/14.
//  Copyright © 2018年 korwin. All rights reserved.
//

#import "KWHomeIPViewController.h"

@interface KWHomeIPViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@end

@implementation KWHomeIPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"imagePick";
    
    //获取照片的类型
    UIImagePickerControllerSourceType sourcheType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.sourceType = sourcheType;
    //设置代理
    self.delegate = self;
    //是否允许编辑
    self.allowsEditing = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    NSLog(@"%@",image);
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
