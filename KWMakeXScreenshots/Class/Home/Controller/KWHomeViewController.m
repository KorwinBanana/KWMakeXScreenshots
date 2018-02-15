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

@property (nonatomic,strong) UIScrollView *iXView;
@property (nonatomic,strong) UIView *iXFatView;
@property (nonatomic,strong) UIView *statusView;
@property (nonatomic,strong) UIView *navigationView;
@property (nonatomic,strong) UIImageView *screenshots1;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIImageView *imageView2;
@property (nonatomic,strong) UIImageView *screenshots2;


@property(nonatomic,strong)UIScrollView *scrollViewSS1;
@property(nonatomic,strong)UIScrollView *scrollViewSS2;

@end

@implementation KWHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"MakeXS";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithString:@"image" target:self action:@selector(imagePickerVc)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithString:@"save" target:self action:@selector(savePhoto)];
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _iXViewW, _scrollViewSS1.bounds.size.height)];
    _imageView.image = [UIImage imageNamed:@"8PlusS"];
    [self.scrollViewSS1 addSubview:_imageView];
    
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
    
    _imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _iXViewW, _scrollViewSS1.bounds.size.height)];
    _imageView2.image = [UIImage imageNamed:@"8PlusS"];
    [self.scrollViewSS2 addSubview:_imageView2];
    
    /************/
    //statusView
    self.statusView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _iXViewW, _iXViewH*[self getNumberWithChuShu:48.543479 ByChuShu:812])];
    [self.iXFatView addSubview:self.statusView];
    self.statusView.backgroundColor = [UIColor blueColor];
    
    /************/
    //navigationView
    CGFloat navViewY = _iXViewH - _iXViewH*[self getNumberWithChuShu:83 ByChuShu:812];
    self.navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, navViewY, _iXViewW, _iXViewH*[self getNumberWithChuShu:83 ByChuShu:812])];
    [self.iXFatView addSubview:self.navigationView];
    self.navigationView.backgroundColor = [UIColor redColor];
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
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
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

@end
