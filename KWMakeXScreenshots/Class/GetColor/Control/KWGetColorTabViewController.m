//
//  KWGetColorTabViewController.m
//  KWMakeXScreenshots
//
//  Created by korwin on 2018/2/28.
//  Copyright © 2018年 korwin. All rights reserved.
//

#import "KWGetColorTabViewController.h"
#import "Utils.h"
#import "KWHomeViewController.h"

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

@interface KWGetColorTabViewController ()<UINavigationControllerDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>{
    CGFloat _iXViewH;
    CGFloat _iXViewW;
}
//结构View
@property (nonatomic,strong) UIScrollView *iXView;
@property (nonatomic,strong) UIView *iXFatView;

@property (nonatomic,assign) CGFloat scale;

@property (nonatomic,strong) UIScrollView *scrollViewSS1;
@property (nonatomic,strong) UIImageView *imageView;//截图1

@end

@implementation KWGetColorTabViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"底栏背景色";
    [self setupIxView];
}

- (void)setupIxView {
    _iXViewW = SCREENWIDTH;
    _iXViewH = _iXViewW * [self getNumberWithChuShu:812 ByChuShu:375];
    
    /*********/
    //iXView内容
    self.iXView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _iXViewW , SCREENHEIGHT)];
    self.iXView.backgroundColor = [UIColor whiteColor];
    self.iXView.userInteractionEnabled = YES;
    
    //1.1 设置UIScrollView内容的尺寸，滚动范围
    self.iXView.contentSize=CGSizeMake(0, _iXViewH);
    
    //1.2 设置UIScrollView的4周增加额外的滚动区域
    //    self.iXView.contentInset = UIEdgeInsetsMake(0, 0, distance, 0);
    
    //1.3 设置弹簧效果
    self.iXView.bounces = YES;
    
    //1.4 设置滚动不显示
    self.iXView.showsHorizontalScrollIndicator=YES;
    self.iXView.showsVerticalScrollIndicator=YES;
    
    //2 UIScrollView
    [self.view addSubview:self.iXView];
    //
    //    //3 设置代理
    self.iXView.delegate = self;
    
    self.iXView.minimumZoomScale=0.88f;
    self.iXView.maximumZoomScale=2.0f;
    //
    //内容View
    self.iXFatView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _iXViewW, SCREENHEIGHT)];
    [self.iXView addSubview:self.iXFatView];
    self.iXFatView.backgroundColor = [UIColor clearColor];
    self.iXFatView.userInteractionEnabled = YES;
    
    /************/
    //scrollViewSS1
    self.scrollViewSS1 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0 , _iXViewW , SCREENHEIGHT)];
    self.scrollViewSS1.backgroundColor = [UIColor redColor];
    self.scrollViewSS1.userInteractionEnabled = YES;
    
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
    _imageView.image = self.iXImage;
    _imageView.userInteractionEnabled = YES;
    [self.iXFatView addSubview:_imageView];
    self.scale = [self getNumberWithChuShu:_imageView.image.size.height ByChuShu:SCREENHEIGHT];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sigleTappedPickerView:)];
    [singleTap setNumberOfTapsRequired:YES];
    singleTap.delegate =self;
    [self.imageView addGestureRecognizer:singleTap];
}

- (void)sigleTappedPickerView:(UIGestureRecognizer *)sender {
    NSLog(@"11111");
    //取得所点击的点的坐标
    CGPoint point = [sender locationInView:self.imageView];
    self.theColor = [self getPixelColorAtLocation:point];
    self.iXView.backgroundColor = self.theColor;
    //此页面已经存在于self.navigationController.viewControllers中,并且是当前页面的前一页面
    
    KWHomeViewController *power= [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    
    //初始化其属性
    power.iXTabColor = nil;
    
    //传递参数过去
    power.iXTabColor = self.theColor;
    
    //使用popToViewController返回并传值到上一页面
    [self.navigationController popToViewController:power animated:YES];
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
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height/3 : ycenter-30;
    self.iXFatView.center = CGPointMake(xcenter, ycenter);
}



/**
 *  缩放结束时调用
 */
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    NSLog(@"缩放结束");
}

#pragma mark - getColor
- (UIColor *)getPixelColorAtLocation:(CGPoint)point
{
    UIColor* color = [UIColor whiteColor];
    if (point.x < self.imageView.frame.size.width && point.x > 0 && point.y < self.imageView.frame.size.height && point.y > 0) {
        UIImageView *colorImageView=self.imageView;
        CGImageRef inImage = colorImageView.image.CGImage;
        
        // Create off screen bitmap context to draw the image into. Format ARGB is 4 bytes for each pixel: Alpa, Red, Green, Blue
        CGContextRef cgctx = [self createARGBBitmapContextFromImage:inImage];
        if (cgctx == NULL) {
            return nil;
        }
        
        size_t w = CGImageGetWidth(inImage);
        size_t h = CGImageGetHeight(inImage);
        CGRect rect = {{0,0},{w,h}};
        
        // Draw the image to the bitmap context. Once we draw, the memory
        // allocated for the context for rendering will then contain the
        // raw image data in the specified color space.
        CGContextDrawImage(cgctx, rect, inImage);
        
        // Now we can get a pointer to the image data associated with the bitmap
        // context.
        unsigned char* data = CGBitmapContextGetData(cgctx);
        
        if (data != NULL)  {
            //offset locates the pixel in the data from x,y.
            //4 for 4 bytes of data per pixel, w is width of one row of data.
            @try
            {
                int offset = 4*((w*round(point.y * self.scale))+round(point.x * self.scale));
                //NSLog(@"offset: %d", offset);
                int alpha =  data[offset];
                int red = data[offset+1];
                int green = data[offset+2];
                int blue = data[offset+3];
                //            NSLog(@"offset: %i colors: RGB A %i %i %i  %i",offset,red,green,blue,alpha);
                //                NSLog(@"%d%d%d",red,green,blue);
                color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
            }
            @catch (NSException * e) {
                NSLog(@"%@",[e reason]);
            }
            @finally {
                
            }
        }
        
        // When finished, release the context
        CGContextRelease(cgctx);
        
        // Free image data memory for the context
        if (data) {
            free(data);
        }
    }
    self.iXView.backgroundColor = color;
    return color;
}

- (CGContextRef) createARGBBitmapContextFromImage:(CGImageRef) inImage {
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    void *bitmapData;
    int  bitmapByteCount;
    int  bitmapBytesPerRow;
    
    // Get image width, height. We'll use the entire image.
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);
    
    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    bitmapBytesPerRow = (int)(pixelsWide * 4);
    bitmapByteCount = (int)(bitmapBytesPerRow * pixelsHigh);
    
    // Use the generic RGB color space.
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    if (colorSpace == NULL) {
        fprintf(stderr, "Error allocating color space\n");
        return NULL;
    }
    
    // Allocate memory for image data. This is the destination in memory
    // where any drawing to the bitmap context will be rendered.
    bitmapData = malloc( bitmapByteCount );
    
    if (bitmapData == NULL) {
        fprintf (stderr, "Memory not allocated!");
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }
    
    // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
    // per component. Regardless of what the source image format is
    // (CMYK, Grayscale, and so on) it will be converted over to the format
    // specified here by CGBitmapContextCreate.
    context = CGBitmapContextCreate (bitmapData,pixelsWide, pixelsHigh,8,bitmapBytesPerRow, colorSpace,kCGImageAlphaPremultipliedFirst);
    if (context == NULL) {
        free (bitmapData);
        fprintf (stderr, "Context not created!");
    }
    
    // Make sure and release colorspace before returning
    CGColorSpaceRelease( colorSpace );
    return context;
}

@end
