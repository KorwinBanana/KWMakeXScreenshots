//
//  KWHomeViewController.m
//  KWMakeXScreenshots
//
//  Created by korwin on 2018/2/14.
//  Copyright © 2018年 korwin. All rights reserved.
//

#import "KWHomeViewController.h"
#import "KWHomeIPViewController.h"
#import "UIBarButtonItem+KWBarButtonItem.h"
#import "KWNavigationViewController.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import <Masonry/Masonry.h>
#import "UIView+KWFrame.h"
#import "Utils.h"
#import "UIImage+ColorAtPixel.h"
#import "UIImage+KWGetNewImage.h"
#import "UIButton+KWButton.h"
#import <ActionSheetPicker-3.0/ActionSheetStringPicker.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "KWSettingViewController.h"

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

@interface KWHomeViewController ()<TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate> {
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
//    BOOL _isSelectOriginalPhoto;
//
    CGFloat _iXViewH;
    CGFloat _iXViewW;
}

@property (nonatomic,strong) UIView *productView;

//结构View
@property (nonatomic,strong) UIScrollView *iXView;
@property (nonatomic,strong) UIView *iXFatView;
@property (nonatomic,strong) UIView *statusView;
@property (nonatomic,strong) UIView *navigationView;

@property (nonatomic,strong) UIImageView *imageView;//截图1
@property (nonatomic,strong) UIImageView *imageView2;//截图2
@property (nonatomic,strong) UIImageView *staView;
@property (nonatomic,strong) UIImageView *tabView;
@property (nonatomic,strong) UIImageView *tabViewForTab;

@property (nonatomic,strong) UIButton *saveButton;
@property (nonatomic,strong) UIButton *staButton;
@property (nonatomic,strong) UIButton *tabButton;
@property (nonatomic,strong) UIButton *moveButton;

@property(nonatomic,strong)UIScrollView *scrollViewSS1;
@property(nonatomic,strong)UIScrollView *scrollViewSS2;

@end

@implementation KWHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"MakeXSScreen";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"Screenshot"] hightImage:[UIImage imageNamed:@"Screenshot_click"] target:self action:@selector(imagePickerVc)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"setting"] hightImage:[UIImage imageNamed:@"setting_click"] target:self action:@selector(toSettingVc)];
    self.view.backgroundColor = [UIColor whiteColor];
    
//    self.productView = [[UIView alloc]init];
//    [self.view addSubview:self.productView];
//    [self.productView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.centerY.mas_equalTo(self.view);
//        make.width.equalTo(@(SCREENWIDTH/2));
//        make.height.equalTo(@250);
//    }];
//    self.productView.backgroundColor = [UIColor blueColor];
    
#warning 添加一个带scrollView页面展示——selectPhotos[0]图片，增加点击获取颜色的方法；来改变navigation的背景颜色
    
    [self makeXScreenshotsWithoutTabWithScreen:[UIImage imageNamed:@"333"] and:[UIImage imageNamed:@"444"]];
    [self addASaveButton];
}

- (void)imagePickerVc {
    // preview photos / 预览照片
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:2 delegate:self];
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    imagePickerVc.selectedAssets = _selectedAssets;
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        NSLog(@"photo = %@",photos);
        [_selectedPhotos removeAllObjects];
        [_selectedAssets removeAllObjects];
        _selectedAssets = [NSMutableArray arrayWithArray:assets];
        _selectedPhotos = [NSMutableArray arrayWithArray:photos];
        //刷新图片展示
        [self makeXScreenshotsWithoutTabWithScreen:_selectedPhotos[0] and:_selectedPhotos[1]];
        [self addASaveButton];
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)addASaveButton {
    self.saveButton = [[UIButton alloc]init];
    self.saveButton = [UIButton buttonWithImage:[UIImage imageNamed:@"saveButton"] hightImage:[UIImage imageNamed:@"saveButton_click"] target:self action:@selector(savePhoto)];
    [self.view addSubview:self.saveButton];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-30);
    }];
    
    UIImage *staImage = [UIImage imageNamed:@"sta"];
    self.staButton = [[UIButton alloc]init];
    self.staButton = [UIButton buttonWithImage:[UIImage imageNamed:@"sta"] hightImage:[UIImage imageNamed:@"sta_click"] target:self action:@selector(selectStaColor)];
    [self.view addSubview:self.staButton];
    [self.staButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(SCREENWIDTH/3 - staImage.size.width/2);
        make.bottom.equalTo(self.view.mas_bottom).offset(-30);
    }];
    
    self.tabButton = [[UIButton alloc]init];
    self.tabButton = [UIButton buttonWithImage:[UIImage imageNamed:@"tab"] hightImage:[UIImage imageNamed:@"tab_click"] target:self action:@selector(selectTabColor)];
    [self.view addSubview:self.tabButton];
    [self.tabButton mas_makeConstraints:^(MASConstraintMaker *make) {
         make.right.equalTo(self.view.mas_right).offset(-(SCREENWIDTH/3 - staImage.size.width/2));
        make.bottom.equalTo(self.view.mas_bottom).offset(-30);
    }];
    
    self.tabButton = [[UIButton alloc]init];
    self.tabButton = [UIButton buttonWithImage:[UIImage imageNamed:@"tab"] hightImage:[UIImage imageNamed:@"tab_click"] target:self action:@selector(selectTabColor)];
    [self.view addSubview:self.tabButton];
    [self.tabButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-(SCREENWIDTH/3 - staImage.size.width/2));
        make.bottom.equalTo(self.view.mas_bottom).offset(-30);
    }];
    
//    CGFloat typeH = -27.5;
//    if ([[Utils deviceModelName] isEqualToString:@"iPhone SE"]) {
//        typeH = -27;
//    }
    self.moveButton = [[UIButton alloc]init];
    self.moveButton = [UIButton buttonWithImage:[UIImage imageNamed:@"list"] hightImage:[UIImage imageNamed:@"list_click"] target:self action:@selector(selectType)];
    [self.view addSubview:self.moveButton];
    [self.moveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-((SCREENWIDTH/3 - staImage.size.width/2) / 3));
        make.bottom.equalTo(self.view.mas_bottom).offset(-30);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - scrollViewDelegate
// 用户开始拖拽时调用
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"开始拖拽");
}

// 滚动到某个位置时调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"拖拽中");
}

// 用户结束拖拽时调用
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"结束拖拽");
}

#pragma mark 属性get方法

- (UIScrollView *)scrollView
{
    if (!_iXView) {
        _iXView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    }
    return _iXView;
}

#pragma mark - GETPHOTO
- (UIImage*)convertViewToImage:(UIView*)v{
    CGSize s = v.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(s, YES, [UIScreen mainScreen].scale);
    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)savePhoto {
    UIImage *viewImage = [self convertViewToImage:_iXFatView];
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);
}

- (CGFloat)getNumberWithChuShu:(CGFloat)x ByChuShu:(CGFloat)y {
    NSString *xString = [NSString stringWithFormat:@"%lf",x];
    NSString *yString = [NSString stringWithFormat:@"%lf",y];
    NSDecimalNumber *decNumX = [NSDecimalNumber decimalNumberWithString:xString];
    NSDecimalNumber *decNumY = [NSDecimalNumber decimalNumberWithString:yString];
    NSDecimalNumber *result = [decNumX decimalNumberByDividingBy:decNumY];
    return [result doubleValue];
}

#pragma mark - pick
- (void)selectStaColor {
    UIButton *sender = self.staButton;
    NSArray *staColor = @[@"黑",@"白"];
    NSArray *stringColor = @[@"staB",@"staW"];
    ActionSheetStringPicker *picker = [[ActionSheetStringPicker alloc]initWithTitle:@"状态栏颜色" rows:staColor initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        self.staView.image = [UIImage imageNamed:stringColor[selectedIndex]];
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        NSLog(@"未选择");
    } origin:sender];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[Utils colorWithHexString:@"#d4237a"] forState:UIControlStateHighlighted];
    [cancelButton setFrame:CGRectMake(0, 0, 50, 45)];
    [picker setCancelButton:[[UIBarButtonItem alloc] initWithCustomView:cancelButton]];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [doneButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [doneButton setTitleColor:[Utils colorWithHexString:@"#d4237a"] forState:UIControlStateHighlighted];
    [doneButton setFrame:CGRectMake(0, 0, 50, 45)];
    [picker setDoneButton:[[UIBarButtonItem alloc] initWithCustomView:doneButton]];
    
    [picker showActionSheetPicker];
}

- (void)selectTabColor {
    UIButton *sender = self.staButton;
    NSArray *tabColor = @[@"黑",@"灰"];
    NSArray *stringColor = @[@"tabUnderb",@"tabUnderW"];
    ActionSheetStringPicker *picker = [[ActionSheetStringPicker alloc]initWithTitle:@"Home键颜色" rows:tabColor initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        self.tabView.image = [UIImage imageNamed:stringColor[selectedIndex]];
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        NSLog(@"未选择");
    } origin:sender];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[Utils colorWithHexString:@"#d4237a"] forState:UIControlStateHighlighted];
    [cancelButton setFrame:CGRectMake(0, 0, 50, 45)];
    [picker setCancelButton:[[UIBarButtonItem alloc] initWithCustomView:cancelButton]];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [doneButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [doneButton setTitleColor:[Utils colorWithHexString:@"#d4237a"] forState:UIControlStateHighlighted];
    [doneButton setFrame:CGRectMake(0, 0, 50, 45)];
    [picker setDoneButton:[[UIBarButtonItem alloc] initWithCustomView:doneButton]];
    
    [picker showActionSheetPicker];
}

- (void)selectType {
    UIButton *sender = self.staButton;
    NSArray *tabColor = @[@"有底栏",@"无底栏"];
    ActionSheetStringPicker *picker = [[ActionSheetStringPicker alloc]initWithTitle:@"选择X样式" rows:tabColor initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        if (selectedIndex == 0) {
            [self makeXScreenshotsWitTab:_selectedPhotos[0] and:_selectedPhotos[1]];
            [self addASaveButton];
        } else if (selectedIndex == 1) {
            [self makeXScreenshotsWithoutTabWithScreen:_selectedPhotos[0] and:_selectedPhotos[1]];
            [self addASaveButton];
        }
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        NSLog(@"未选择");
    } origin:sender];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[Utils colorWithHexString:@"#d4237a"] forState:UIControlStateHighlighted];
    [cancelButton setFrame:CGRectMake(0, 0, 50, 45)];
    [picker setCancelButton:[[UIBarButtonItem alloc] initWithCustomView:cancelButton]];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [doneButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [doneButton setTitleColor:[Utils colorWithHexString:@"#d4237a"] forState:UIControlStateHighlighted];
    [doneButton setFrame:CGRectMake(0, 0, 50, 45)];
    [picker setDoneButton:[[UIBarButtonItem alloc] initWithCustomView:doneButton]];
    
    [picker showActionSheetPicker];
}

#pragma mark - 跳转设置页面
- (void)toSettingVc {
    KWSettingViewController *settingVc = [[KWSettingViewController alloc]init];
    [self.navigationController pushViewController:settingVc animated:YES];
}

#pragma mark - 制作样式Type
- (void)makeXScreenshotsWitTab:(UIImage *)screen1 and:(UIImage *)screen2 {
    NSString *phoneType = [Utils deviceModelName];
    if ([phoneType isEqualToString:@"iPhone SE"]) {
        [self makeXScreenshotsWithScreenForSE:screen1 and:screen2];
    } else if ([phoneType isEqualToString:@"iPhone 8"]) {
        [self makeXScreenshotsWithScreenFor8And8Plus:screen1 and:screen2];
    }
}

//获取APP\带底栏截图
- (void)makeXScreenshotsWithScreenFor8And8Plus:(UIImage *)screen1 and:(UIImage *)screen2 {
    
    _iXViewW = SCREENWIDTH;
    _iXViewH = _iXViewW * [self getNumberWithChuShu:812 ByChuShu:375];
    
    /*********/
    //iXView内容
    self.iXView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _iXViewW , SCREENHEIGHT)];
    self.iXView.backgroundColor = [UIColor whiteColor];
    
    //1.1 设置UIScrollView内容的尺寸，滚动范围
    self.iXView.contentSize=CGSizeMake(0, _iXViewH);
    
    //1.2 设置UIScrollView的4周增加额外的滚动区域
    CGFloat distance = 65.0f;
    self.iXView.contentInset = UIEdgeInsetsMake(0, 0, distance, 0);
    
    //1.3 设置弹簧效果
    self.iXView.bounces = NO;
    
    //1.4 设置滚动不显示
    self.iXView.showsHorizontalScrollIndicator=YES;
    self.iXView.showsVerticalScrollIndicator=YES;
    
    //2 UIScrollView
    [self.view addSubview:self.iXView];
    
    //3 设置代理
    self.iXView.delegate = self;
    
    //内容View
    self.iXFatView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _iXViewW, _iXViewH)];
    [self.iXView addSubview:self.iXFatView];
    self.iXFatView.backgroundColor = [UIColor greenColor];
    
    /************/
    //scrollViewSS1
    
    CGFloat topInX =  _iXViewH*[self getNumberWithChuShu:48.543479 ByChuShu:812] - [self getNumberWithChuShu:(812*[self getNumberWithChuShu:20 ByChuShu:736]) ByChuShu:812] * _iXViewH;
    self.scrollViewSS1 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topInX , _iXViewW , SCREENHEIGHT)];
    self.scrollViewSS1.backgroundColor = [UIColor redColor];
    
    //1.1 设置UIScrollView内容的尺寸，滚动范围
    self.scrollViewSS1.contentSize=CGSizeMake(0, SCREENHEIGHT);
    
    //1.3 设置弹簧效果
    self.scrollViewSS1.bounces = NO;
    
    //1.4 设置滚动不显示
    self.scrollViewSS1.showsHorizontalScrollIndicator=NO;
    self.scrollViewSS1.showsVerticalScrollIndicator=NO;
    
    //2 UIScrollView
    [self.iXFatView addSubview:self.scrollViewSS1];
    
    //3 设置代理
    self.scrollViewSS1.delegate = self;
    
    //截图1
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _iXViewW, _scrollViewSS1.bounds.size.height)];
#warning 截图1
    _imageView.image = screen1;
    [self.scrollViewSS1 addSubview:_imageView];
    UIColor *staColor = [_imageView.image colorAtPixel:CGPointMake(_imageView.image.size.width/2, topInX + 1)];//获取颜色
    NSLog(@"staColor = %lf",_iXViewH*[self getNumberWithChuShu:48.543479 ByChuShu:812] + 0.5);
    
    //截取tab位置图片
#warning 计算图片位置
    UIImage *tabNewImage = [UIImage imageFromImage:_imageView.image inRect:CGRectMake(0, _imageView.image.size.height - [self getNumberWithChuShu:49 ByChuShu:736] * _imageView.image.size.height, _imageView.image.size.width, [self getNumberWithChuShu:49 ByChuShu:736] * _imageView.image.size.height)];
    UIImage *tabNewImage2 = [UIImage imageFromImage:tabNewImage inRect:CGRectMake(0, 5, tabNewImage.size.width, tabNewImage.size.height - 5)];
    NSLog(@"_imageView.image.size.height = %lf",_imageView.image.size.height);
    UIColor *tabNewColor = [tabNewImage2 colorAtPixel:CGPointMake(tabNewImage2.size.width/2, 2)];//获取颜色
    
    /************/
    //scrollViewSS2
    CGFloat ss2Top = _scrollViewSS1.KW_height - [self getNumberWithChuShu:(812*[self getNumberWithChuShu:20 ByChuShu:736]) ByChuShu:812] * _iXViewH - [self getNumberWithChuShu:(812*[self getNumberWithChuShu:49 ByChuShu:736]) ByChuShu:812] * _iXViewH + _iXViewH*[self getNumberWithChuShu:48.543479 ByChuShu:812] - 5;
    
    self.scrollViewSS2 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, ss2Top , _iXViewW ,200)];
    self.scrollViewSS2.backgroundColor = [UIColor yellowColor];
    
    //scrollViewSS2内容
    self.iXView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH , SCREENHEIGHT)];
    self.iXView.backgroundColor = [UIColor whiteColor];
    
    //1.1 设置scrollViewSS2内容的尺寸，滚动范围
    self.scrollViewSS2.contentSize=CGSizeMake(0, SCREENHEIGHT);
    
    //1.3 设置弹簧效果
    self.scrollViewSS2.bounces = NO;
    
    //1.4 设置滚动不显示
    self.scrollViewSS2.showsHorizontalScrollIndicator=NO;
    self.scrollViewSS2.showsVerticalScrollIndicator=YES;
    
    //2 UIScrollView
    [self.iXFatView addSubview:self.scrollViewSS2];
    
    //3 设置代理
    self.scrollViewSS2.delegate = self;
    
    //截图2
    _imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _iXViewW, _scrollViewSS1.bounds.size.height)];
#warning 截图2
    _imageView2.image = screen2;
    [self.scrollViewSS2 addSubview:_imageView2];
    
    /************/
    //statusView
    self.statusView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _iXViewW, _iXViewH*[self getNumberWithChuShu:48.543479 ByChuShu:812])];
    [self.iXFatView addSubview:self.statusView];
    self.statusView.backgroundColor = staColor;//设置颜色
    
    //staB 36c6c1
    UIImage *staImage = [UIImage imageNamed:@"staW"];
    CGFloat staImageH = [self getNumberWithChuShu:staImage.size.height ByChuShu:staImage.size.width] * _iXViewH;
    NSLog(@"staImageH = %lf",staImage.size.width);
    self.staView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _iXViewW, staImageH/2.3)];
    self.staView.image = staImage;
    self.staView.backgroundColor = [UIColor clearColor];
    [self.statusView addSubview:_staView];
    
    /************/
    //navigationView
    CGFloat navViewY = _iXViewH - _iXViewH*[self getNumberWithChuShu:83 ByChuShu:812];
    self.navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, navViewY, _iXViewW, _iXViewH*[self getNumberWithChuShu:83 ByChuShu:812])];
    [self.iXFatView addSubview:self.navigationView];
    self.navigationView.backgroundColor = tabNewColor;
    
    UIImage *tabImage = [UIImage imageNamed:@"tabUnderb"];
    CGFloat tabImageH = [self getNumberWithChuShu:staImage.size.height ByChuShu:staImage.size.width] * _iXViewH;
    CGFloat tabImageTop = _iXViewH*[self getNumberWithChuShu:83 ByChuShu:812] - tabImageH;
    NSLog(@"tabImageH = %lf",staImage.size.width);
    
    //tabViewForTab
    self.tabViewForTab = [[UIImageView alloc]initWithFrame:CGRectMake(0, tabImageTop, _iXViewW, 49)];
    self.tabViewForTab.image = tabNewImage2;
    [self.navigationView addSubview:_tabViewForTab];
    
    //tabW
    self.tabView = [[UIImageView alloc]initWithFrame:CGRectMake(0, tabImageH, _iXViewW, tabImageH/6)];
    self.tabView.image = tabImage;
    self.tabView.backgroundColor = [UIColor clearColor];
    [self.navigationView addSubview:_tabView];
}

//获取APP\带底栏截图 SE
- (void)makeXScreenshotsWithScreenForSE:(UIImage *)screen1 and:(UIImage *)screen2 {
    
    _iXViewW = SCREENWIDTH;
    _iXViewH = _iXViewW * [self getNumberWithChuShu:812 ByChuShu:375];
    
    /*********/
    //iXView内容
    self.iXView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _iXViewW , SCREENHEIGHT)];
    self.iXView.backgroundColor = [UIColor whiteColor];
    
    //1.1 设置UIScrollView内容的尺寸，滚动范围
    self.iXView.contentSize=CGSizeMake(0, _iXViewH);
    
    //1.2 设置UIScrollView的4周增加额外的滚动区域
    CGFloat distance = 65.0f;
    self.iXView.contentInset = UIEdgeInsetsMake(0, 0, distance, 0);
    
    //1.3 设置弹簧效果
    self.iXView.bounces = NO;
    
    //1.4 设置滚动不显示
    self.iXView.showsHorizontalScrollIndicator=YES;
    self.iXView.showsVerticalScrollIndicator=YES;
    
    //2 UIScrollView
    [self.view addSubview:self.iXView];
    
    //3 设置代理
    self.iXView.delegate = self;
    
    //内容View
    self.iXFatView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _iXViewW, _iXViewH)];
    [self.iXView addSubview:self.iXFatView];
    self.iXFatView.backgroundColor = [UIColor greenColor];
    
    /************/
    //scrollViewSS1
    
    CGFloat topInX =  _iXViewH*[self getNumberWithChuShu:48.543479 ByChuShu:812] - [self getNumberWithChuShu:(812*[self getNumberWithChuShu:20 ByChuShu:736]) ByChuShu:812] * _iXViewH;
    self.scrollViewSS1 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topInX , _iXViewW , SCREENHEIGHT)];
    self.scrollViewSS1.backgroundColor = [UIColor redColor];
    
    //1.1 设置UIScrollView内容的尺寸，滚动范围
    self.scrollViewSS1.contentSize=CGSizeMake(0, SCREENHEIGHT);
    
    //1.3 设置弹簧效果
    self.scrollViewSS1.bounces = NO;
    
    //1.4 设置滚动不显示
    self.scrollViewSS1.showsHorizontalScrollIndicator=NO;
    self.scrollViewSS1.showsVerticalScrollIndicator=NO;
    
    //2 UIScrollView
    [self.iXFatView addSubview:self.scrollViewSS1];
    
    //3 设置代理
    self.scrollViewSS1.delegate = self;
    
    //截图1
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _iXViewW, _scrollViewSS1.bounds.size.height)];
#warning 截图1
    _imageView.image = screen1;
    [self.scrollViewSS1 addSubview:_imageView];
    UIColor *staColor = [_imageView.image colorAtPixel:CGPointMake(_imageView.image.size.width/2, topInX+1)];//获取颜色
    NSLog(@"staColor = %lf",_iXViewH*[self getNumberWithChuShu:48.543479 ByChuShu:812] + 0.5);
    
    //截取tab位置图片
#warning 计算图片位置
    UIImage *tabNewImage2 = [UIImage imageFromImage:_imageView.image inRect:CGRectMake(0, _imageView.image.size.height - [self getNumberWithChuShu:49 ByChuShu:568] * _imageView.image.size.height, _imageView.image.size.width, [self getNumberWithChuShu:49 ByChuShu:568] * _imageView.image.size.height)];
    //    UIImage *tabNewImage2 = [UIImage imageFromImage:tabNewImage inRect:CGRectMake(0, 0, tabNewImage.size.width, tabNewImage.size.height - 5)];
    NSLog(@"_imageView.image.size.height = %lf",_imageView.image.size.height);
    UIColor *tabNewColor = [tabNewImage2 colorAtPixel:CGPointMake(tabNewImage2.size.width/2, 2)];//获取颜色
    
    /************/
    //scrollViewSS2
    CGFloat ss2Top = _scrollViewSS1.KW_height - [self getNumberWithChuShu:(812*[self getNumberWithChuShu:20 ByChuShu:736]) ByChuShu:812] * _iXViewH - [self getNumberWithChuShu:(812*[self getNumberWithChuShu:49 ByChuShu:736]) ByChuShu:812] * _iXViewH + _iXViewH*[self getNumberWithChuShu:48.543479 ByChuShu:812] - 5;
    
    self.scrollViewSS2 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, ss2Top , _iXViewW ,200)];
    self.scrollViewSS2.backgroundColor = [UIColor yellowColor];
    
    //scrollViewSS2内容
    self.iXView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH , SCREENHEIGHT)];
    self.iXView.backgroundColor = [UIColor whiteColor];
    
    //1.1 设置scrollViewSS2内容的尺寸，滚动范围
    self.scrollViewSS2.contentSize=CGSizeMake(0, SCREENHEIGHT);
    
    //1.3 设置弹簧效果
    self.scrollViewSS2.bounces = NO;
    
    //1.4 设置滚动不显示
    self.scrollViewSS2.showsHorizontalScrollIndicator=NO;
    self.scrollViewSS2.showsVerticalScrollIndicator=YES;
    
    //2 UIScrollView
    [self.iXFatView addSubview:self.scrollViewSS2];
    
    //3 设置代理
    self.scrollViewSS2.delegate = self;
    
    //截图2
    _imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _iXViewW, _scrollViewSS1.bounds.size.height)];
#warning 截图2
    _imageView2.image = screen2;
    [self.scrollViewSS2 addSubview:_imageView2];
    
    /************/
    //statusView
    self.statusView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _iXViewW, _iXViewH*[self getNumberWithChuShu:48.543479 ByChuShu:812])];
    [self.iXFatView addSubview:self.statusView];
    self.statusView.backgroundColor = staColor;//设置颜色
    
    //staB 36c6c1
    UIImage *staImage = [UIImage imageNamed:@"staW"];
    CGFloat staImageH = [self getNumberWithChuShu:staImage.size.height ByChuShu:staImage.size.width] * _iXViewH;
    NSLog(@"staImageH = %lf",staImage.size.width);
    self.staView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _iXViewW, staImageH/2.3)];
    self.staView.image = staImage;
    self.staView.backgroundColor = [UIColor clearColor];
    [self.statusView addSubview:_staView];
    
    /************/
    //navigationView
    CGFloat navViewY = _iXViewH - _iXViewH*[self getNumberWithChuShu:83 ByChuShu:812];
    self.navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, navViewY, _iXViewW, _iXViewH*[self getNumberWithChuShu:83 ByChuShu:812])];
    [self.iXFatView addSubview:self.navigationView];
    self.navigationView.backgroundColor = tabNewColor;
    
    UIImage *tabImage = [UIImage imageNamed:@"tabUnderb"];
    CGFloat tabImageH = [self getNumberWithChuShu:staImage.size.height ByChuShu:staImage.size.width] * _iXViewH;
    CGFloat tabImageTop = _iXViewH*[self getNumberWithChuShu:83 ByChuShu:812] - tabImageH;
    NSLog(@"tabImageH = %lf",staImage.size.width);
    
    //tabViewForTab
    self.tabViewForTab = [[UIImageView alloc]initWithFrame:CGRectMake(0, tabImageTop - 7, _iXViewW, 49)];
    self.tabViewForTab.image = tabNewImage2;
    [self.navigationView addSubview:_tabViewForTab];
    
    //tabW
    self.tabView = [[UIImageView alloc]initWithFrame:CGRectMake(0, tabImageH, _iXViewW, tabImageH/6)];
    self.tabView.image = tabImage;
    self.tabView.backgroundColor = [UIColor clearColor];
    [self.navigationView addSubview:_tabView];
}

#warning APP——不带底栏
//获取截图
- (void)makeXScreenshotsWithoutTabWithScreen:(UIImage *)screen1 and:(UIImage *)screen2 {
    
    _iXViewW = SCREENWIDTH;
    _iXViewH = _iXViewW * [self getNumberWithChuShu:812 ByChuShu:375];
    
    /*********/
    //iXView内容
    self.iXView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _iXViewW , SCREENHEIGHT)];
    self.iXView.backgroundColor = [UIColor whiteColor];
    
    //1.1 设置UIScrollView内容的尺寸，滚动范围
    self.iXView.contentSize=CGSizeMake(0, _iXViewH);
    
    //1.2 设置UIScrollView的4周增加额外的滚动区域
    CGFloat distance = 65.0f;
    self.iXView.contentInset = UIEdgeInsetsMake(0, 0, distance, 0);
    
    //1.3 设置弹簧效果
    self.iXView.bounces = NO;
    
    //1.4 设置滚动不显示
    self.iXView.showsHorizontalScrollIndicator=YES;
    self.iXView.showsVerticalScrollIndicator=YES;
    
    //2 UIScrollView
    [self.view addSubview:self.iXView];
    
    //3 设置代理
    self.iXView.delegate = self;
    
    //内容View
    self.iXFatView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _iXViewW, _iXViewH)];
    [self.iXView addSubview:self.iXFatView];
    self.iXFatView.backgroundColor = [UIColor greenColor];
    
    /************/
    //scrollViewSS1
    
    CGFloat topInX =  _iXViewH*[self getNumberWithChuShu:48.543479 ByChuShu:812] - [self getNumberWithChuShu:(812*[self getNumberWithChuShu:20 ByChuShu:736]) ByChuShu:812] * _iXViewH;
    self.scrollViewSS1 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topInX , _iXViewW , SCREENHEIGHT)];
    self.scrollViewSS1.backgroundColor = [UIColor redColor];
    
    //1.1 设置UIScrollView内容的尺寸，滚动范围
    self.scrollViewSS1.contentSize=CGSizeMake(0, SCREENHEIGHT);
    
    //1.3 设置弹簧效果
    self.scrollViewSS1.bounces = NO;
    
    //1.4 设置滚动不显示
    self.scrollViewSS1.showsHorizontalScrollIndicator=NO;
    self.scrollViewSS1.showsVerticalScrollIndicator=NO;
    
    //2 UIScrollView
    [self.iXFatView addSubview:self.scrollViewSS1];
    
    //3 设置代理
    self.scrollViewSS1.delegate = self;
    
    //截图1
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _iXViewW, _scrollViewSS1.bounds.size.height)];
#warning 截图1
    _imageView.image = screen1;
    [self.scrollViewSS1 addSubview:_imageView];
    UIColor *staColor = [_imageView.image colorAtPixel:CGPointMake(_imageView.image.size.width/2, topInX+2)];//获取颜色
    //    NSLog(@"staColor = %@",staColor);
    
    //截取tab位置图片
#warning 计算图片位置
    UIImage *tabNewImage = [UIImage imageFromImage:_imageView.image inRect:CGRectMake(0, _imageView.image.size.height - [self getNumberWithChuShu:49 ByChuShu:736] * _imageView.image.size.height, _imageView.image.size.width, [self getNumberWithChuShu:49 ByChuShu:736] * _imageView.image.size.height)];
    UIImage *tabNewImage2 = [UIImage imageFromImage:tabNewImage inRect:CGRectMake(0, 5, tabNewImage.size.width, tabNewImage.size.height - 5)];
    NSLog(@"_imageView.image.size.height = %lf",_imageView.image.size.height);
    UIColor *tabNewColor = [tabNewImage2 colorAtPixel:CGPointMake(tabNewImage2.size.width/2, 2)];//获取颜色
    
    /************/
    //scrollViewSS2
    CGFloat ss2Top = _scrollViewSS1.KW_height - [self getNumberWithChuShu:(812*[self getNumberWithChuShu:20 ByChuShu:736]) ByChuShu:812] * _iXViewH - [self getNumberWithChuShu:(812*[self getNumberWithChuShu:49 ByChuShu:736]) ByChuShu:812] * _iXViewH + _iXViewH*[self getNumberWithChuShu:48.543479 ByChuShu:812] - 5;
    
    self.scrollViewSS2 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, ss2Top , _iXViewW ,200)];
    self.scrollViewSS2.backgroundColor = [UIColor yellowColor];
    
    //scrollViewSS2内容
    self.iXView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH , SCREENHEIGHT)];
    self.iXView.backgroundColor = [UIColor whiteColor];
    
    //1.1 设置scrollViewSS2内容的尺寸，滚动范围
    self.scrollViewSS2.contentSize=CGSizeMake(0, SCREENHEIGHT);
    
    //1.3 设置弹簧效果
    self.scrollViewSS2.bounces = NO;
    
    //1.4 设置滚动不显示
    self.scrollViewSS2.showsHorizontalScrollIndicator=NO;
    self.scrollViewSS2.showsVerticalScrollIndicator=YES;
    
    //2 UIScrollView
    [self.iXFatView addSubview:self.scrollViewSS2];
    
    //3 设置代理
    self.scrollViewSS2.delegate = self;
    
    //截图2
    _imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _iXViewW, _scrollViewSS1.bounds.size.height)];
#warning 截图2
    _imageView2.image = screen2;;
    [self.scrollViewSS2 addSubview:_imageView2];
    
    /************/
    //statusView
    self.statusView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _iXViewW, _iXViewH*[self getNumberWithChuShu:48.543479 ByChuShu:812])];
    [self.iXFatView addSubview:self.statusView];
    self.statusView.backgroundColor = staColor;//设置颜色
    
    //staB
    UIImage *staImage = [UIImage imageNamed:@"staB"];
    CGFloat staImageH = [self getNumberWithChuShu:staImage.size.height ByChuShu:staImage.size.width] * _iXViewH;
    NSLog(@"staImageH = %lf",staImage.size.width);
    self.staView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _iXViewW, staImageH/2.3)];
    self.staView.image = staImage;
    self.staView.backgroundColor = [UIColor clearColor];
    [self.statusView addSubview:_staView];
    
    /************/
    //navigationView
    CGFloat navViewY = _iXViewH - _iXViewH*[self getNumberWithChuShu:83 ByChuShu:812];
    self.navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, navViewY, _iXViewW, _iXViewH*[self getNumberWithChuShu:83 ByChuShu:812])];
    [self.iXFatView addSubview:self.navigationView];
    self.navigationView.backgroundColor = [UIColor clearColor];
    
    UIImage *tabImage = [UIImage imageNamed:@"tabUnderb"];
    CGFloat tabImageH = [self getNumberWithChuShu:staImage.size.height ByChuShu:staImage.size.width] * _iXViewH;
    
    //tabW
    self.tabView = [[UIImageView alloc]initWithFrame:CGRectMake(0, tabImageH, _iXViewW, tabImageH/6)];
    self.tabView.image = tabImage;
    self.tabView.backgroundColor = [UIColor clearColor];
    [self.navigationView addSubview:_tabView];
}

@end
