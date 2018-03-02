//
//  KWVisitViewController.m
//  KWMakeXScreenshots
//
//  Created by korwin on 2018/2/21.
//  Copyright © 2018年 korwin. All rights reserved.
//

#import "KWVisitViewController.h"
#import <Masonry/Masonry.h>

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

@interface KWVisitViewController ()<UINavigationControllerDelegate,UIScrollViewDelegate>{
    CGFloat _iXViewH;
    CGFloat _iXViewW;
}

@property (nonatomic,strong) UIScrollView *iXView;
@property (nonatomic,strong) UIView *iXFatView;
@property (nonatomic,strong) UIImageView *iXImageView;

@end

@implementation KWVisitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"浏览";
    [self setupiXView];
    
}

- (void)setupiXView {
    _iXViewW = SCREENWIDTH;
    _iXViewH = _iXViewW * [self getNumberWithChuShu:812 ByChuShu:375];
//    NSLog(@"[self getNumberWithChuShu:812 ByChuShu:375] = %f",[self getNumberWithChuShu:812 ByChuShu:375]);
    
    /*********/
    //iXView内容
    self.iXView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _iXViewW , SCREENHEIGHT)];
    self.iXView.backgroundColor = [UIColor whiteColor];
    
    //1.1 设置UIScrollView内容的尺寸，滚动范围
    self.iXView.contentSize=CGSizeMake(0, _iXViewH);
    
    //1.2 设置UIScrollView的4周增加额外的滚动区域
    CGFloat distance = 65.0;
    self.iXView.contentInset = UIEdgeInsetsMake(0, 0, distance, 0);
    
    //1.3 设置弹簧效果
    self.iXView.bounces = YES;
    
    //1.4 设置滚动不显示
    self.iXView.showsHorizontalScrollIndicator=YES;
    self.iXView.showsVerticalScrollIndicator=YES;
    
    //2 UIScrollView
    [self.view addSubview:self.iXView];
    
    //3 设置代理
    self.iXView.delegate = self;
    
    self.iXView.minimumZoomScale=0.72f;
    self.iXView.maximumZoomScale=2.0f;
    
    //内容View
    self.iXFatView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _iXViewW, _iXViewH)];
    [self.iXView addSubview:self.iXFatView];
    self.iXFatView.backgroundColor = [UIColor clearColor];
    
    self.iXImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _iXViewW, _iXViewH)];
    self.iXImageView.image = self.iXImage;
    [self.iXFatView addSubview:self.iXImageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)getNumberWithChuShu:(CGFloat)x ByChuShu:(CGFloat)y {
    NSString *xString = [NSString stringWithFormat:@"%lf",x];
    NSString *yString = [NSString stringWithFormat:@"%lf",y];
    NSDecimalNumber *decNumX = [NSDecimalNumber decimalNumberWithString:xString];
    NSDecimalNumber *decNumY = [NSDecimalNumber decimalNumberWithString:yString];
    NSDecimalNumber *result = [decNumX decimalNumberByDividingBy:decNumY];
    return [result doubleValue];
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

#pragma mark 缩放
/**
 *  缩放结束时调用
 */
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    NSLog(@"开始缩放");
    return self.iXFatView;
}

/**
 *  缩放过程中调用
 */
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    NSLog(@"正在缩放");
    CGFloat xcenter = scrollView.center.x , ycenter = scrollView.center.y;
    xcenter = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width/2 : xcenter;
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height/2 : ycenter-25;
    self.iXFatView.center = CGPointMake(xcenter, ycenter);
}



/**
 *  缩放结束时调用
 */
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    NSLog(@"缩放结束");
}

@end
