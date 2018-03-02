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
#import "KWSaveViewController.h"
#import "KWVisitViewController.h"
#import "KWGetColorViewController.h"
#import <TZImagePickerController/TZImageManager.h>
#import "UIBarButtonItem+KWBarButtonItem.h"
#import "KWGetColorTabViewController.h"
#import "KWHelpViewController.h"

@import GoogleMobileAds;

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

@property (nonatomic,strong) UIImageView *beginView;//初始界面

//结构View
@property (nonatomic,strong) UIScrollView *iXView;
@property (nonatomic,strong) UIView *iXFatView;
@property (nonatomic,strong) UIImage *iXImage;
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
@property (nonatomic,strong) UIButton *moreButton;
@property (nonatomic,strong) UIButton *moveButton;
@property (nonatomic,strong) UIView *backgroundButton;

@property (nonatomic,assign) float iXImageScale;//比例

@property(nonatomic,strong)UIScrollView *scrollViewSS1;
@property(nonatomic,strong)UIScrollView *scrollViewSS2;

//AD
@property(nonatomic, strong) GADInterstitial*interstitial;

//奖励次数
@property(nonatomic, assign) NSInteger numReward;

@end

@implementation KWHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //Interstitial Ads
//    self.interstitial = [self createAndLoadInterstitial];
    
    [self setupNav];
    [self beginiXShotView];
    [self addASaveButton];
}

- (void)viewDidAppear:(BOOL)animated {
    if (self.iXNavColor) {
        self.statusView.backgroundColor = self.iXNavColor;
    }
    if (self.iXTabColor) {
        self.navigationView.backgroundColor = self.iXTabColor;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - interstitialLoad
- (GADInterstitial *)createAndLoadInterstitial {
    GADInterstitial *interstitial =
    [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-3589264864117411/6297061022"];
//    interstitial.delegate = self;
    [interstitial loadRequest:[GADRequest request]];
    return interstitial;
}

- (void)setupNav {
    self.navigationItem.title = @"iXShot";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"Screenshot"] hightImage:[UIImage imageNamed:@"Screenshot_click"] target:self action:@selector(imagePickerVc)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"setting"] hightImage:[UIImage imageNamed:@"setting_click"] target:self action:@selector(toSettingVc)];
}

- (void)beginiXShotView {
    NSString *phoneType = [Utils deviceModelName];
    UIImage *beginImage = [UIImage imageNamed:@"begin"];
    if ([phoneType isEqualToString:@"iPhone X"]) {
        beginImage = [UIImage imageNamed:@"beginX"];
    }
    self.beginView = [[UIImageView alloc]initWithImage:beginImage];
    [self.view addSubview:self.beginView];
    [self.beginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    [self addASaveButton];
}

- (void)imagePickerVc {
    NSString *phoneType = [Utils deviceModelName];
    NSLog(@"phoneType = %@",phoneType);
    if([phoneType isEqualToString:@"iPhone X"]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [SVProgressHUD show];
            sleep(1);
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:@"抱歉,iPhone X用户请使用系统截图吧～"];
            sleep(1);
            [SVProgressHUD dismiss];
        });
    } else {
        // preview photos / 预览照片
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:2 delegate:self];
        imagePickerVc.allowPickingImage = YES;
        imagePickerVc.allowPickingOriginalPhoto = YES;
        imagePickerVc.allowTakePicture = NO;
        imagePickerVc.allowPickingVideo = NO;
        imagePickerVc.minPhotoWidthSelectable = 1000;
        imagePickerVc.minPhotoHeightSelectable = SCREENHEIGHT;
        imagePickerVc.navLeftBarButtonSettingBlock = ^(UIButton *leftButton) {
            [leftButton setTitle:@"      " forState:UIControlStateNormal];
            [leftButton setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
            [leftButton setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
        };
        imagePickerVc.naviTitleFont = [UIFont boldSystemFontOfSize:19];
        imagePickerVc.selectedAssets = _selectedAssets;
        imagePickerVc.oKButtonTitleColorNormal = [Utils colorWithHexString:@"1296db"];
        imagePickerVc.oKButtonTitleColorDisabled = [Utils colorWithHexString:@"1296db"];
        
        // You can get the photos by block, the same as by delegate.
        // 你可以通过block或者代理，来得到用户选择的照片.
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            NSLog(@"photo = %@",photos);
            [_selectedPhotos removeAllObjects];
            [_selectedAssets removeAllObjects];
            _selectedAssets = [NSMutableArray arrayWithArray:assets];
            _selectedPhotos = [NSMutableArray arrayWithArray:photos];
            if(_selectedPhotos.count == 2) {
                //刷新图片展示
                [self makeXScreenshotsWitTab:_selectedPhotos[0] and:_selectedPhotos[1]];
                [self addASaveButton];
            } else {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    [SVProgressHUD show];
                    sleep(1);
                    [SVProgressHUD dismiss];
                    [SVProgressHUD showErrorWithStatus:@"请选择两张截图"];
                    sleep(1);
                    [SVProgressHUD dismiss];
                });
            }
        }];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
}

- (void)addASaveButton {
    UIImage *saveImage = [UIImage imageNamed:@"sta"];
    self.backgroundButton = [[UIView alloc] init];
    [self.view addSubview:self.backgroundButton];
    [self.backgroundButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.bottom.equalTo(self.view.mas_bottom).offset(-30);
        make.height.mas_equalTo(saveImage.size.height + 6);
    }];
    
    //设置阴影和圆角
    self.backgroundButton.layer.cornerRadius = 10;
    self.backgroundButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.backgroundButton.layer.shadowOffset = CGSizeMake(2, 5);
    self.backgroundButton.layer.shadowOpacity = 0.5;
    self.backgroundButton.layer.shadowRadius = 5;
    self.backgroundButton.alpha = 0.8;
    self.backgroundButton.backgroundColor = [Utils colorWithHexString:@"1296db"];
    
    self.saveButton = [[UIButton alloc]init];
    self.saveButton = [UIButton buttonWithImage:[UIImage imageNamed:@"saveButton"] hightImage:[UIImage imageNamed:@"saveButton_click"] target:self action:@selector(savePhoto)];
    [self.backgroundButton addSubview:self.saveButton];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backgroundButton);
//        make.bottom.equalTo(self.view.mas_bottom).offset(-30);
        make.centerY.equalTo(self.backgroundButton);
    }];
    
    //设置间隔
    CGFloat sickWidth = (SCREENWIDTH - 30)/6 - (saveImage.size.width - 2)/2;
    NSLog(@"sickWidth = %lf",sickWidth);
    
    self.staButton = [[UIButton alloc]init];
    self.staButton = [UIButton buttonWithImage:[UIImage imageNamed:@"sta"] hightImage:[UIImage imageNamed:@"sta_click"] target:self action:@selector(selectStaColor)];
    [self.backgroundButton addSubview:self.staButton];
    [self.staButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.backgroundButton.mas_left).offset(SCREENWIDTH/3 - staImage.size.width/2);
        make.right.equalTo(self.saveButton.mas_left).with.offset(-sickWidth);
        make.centerY.equalTo(self.backgroundButton);

    }];
    
    self.tabButton = [[UIButton alloc]init];
    self.tabButton = [UIButton buttonWithImage:[UIImage imageNamed:@"tab"] hightImage:[UIImage imageNamed:@"tab_click"] target:self action:@selector(selectTabColor)];
    [self.backgroundButton addSubview:self.tabButton];
    [self.tabButton mas_makeConstraints:^(MASConstraintMaker *make) {
//         make.right.equalTo(self.backgroundButton.mas_right).offset(-(SCREENWIDTH/3 - staImage.size.width/2));
//        make.bottom.equalTo(self.view.mas_bottom).offset(-30);
        make.left.equalTo(self.saveButton.mas_right).with.offset(sickWidth);
        make.centerY.equalTo(self.backgroundButton);
    }];
    
    self.moreButton = [[UIButton alloc]init];
    self.moreButton = [UIButton buttonWithImage:[UIImage imageNamed:@"list"] hightImage:[UIImage imageNamed:@"list_click"] target:self action:@selector(selectType)];
    [self.backgroundButton addSubview:self.moreButton];
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.backgroundButton.mas_right).offset(-((SCREENWIDTH/3 - staImage.size.width/2) / 3));
        make.left.equalTo(self.tabButton.mas_right).with.offset(sickWidth);

//        make.bottom.equalTo(self.view.mas_bottom).offset(-30);
        make.centerY.equalTo(self.backgroundButton);

    }];
        
    CGFloat typeH = -30;
    if ([[Utils deviceModelName] isEqualToString:@"iPhone 8"]) {
        typeH = -27;
    }
    
    self.moveButton = [[UIButton alloc]init];
    self.moveButton = [UIButton buttonWithImage:[UIImage imageNamed:@"color"] hightImage:[UIImage imageNamed:@"color_click"] target:self action:@selector(showColorMassage)];
    [self.backgroundButton addSubview:self.moveButton];
    [self.moveButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.backgroundButton.mas_left).offset(((SCREENWIDTH/3 - staImage.size.width/2) / 3));
        make.right.equalTo(self.staButton.mas_left).with.offset(-sickWidth);

//        make.bottom.equalTo(self.view.mas_bottom).offset(typeH);
        make.centerY.equalTo(self.backgroundButton);

    }];
}

- (void)addASaveButtonWithOutTab {
    UIImage *saveImage = [UIImage imageNamed:@"sta"];
    self.backgroundButton = [[UIView alloc] init];
    [self.view addSubview:self.backgroundButton];
    [self.backgroundButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.bottom.equalTo(self.view.mas_bottom).offset(-30);
        make.height.mas_equalTo(saveImage.size.height + 6);
    }];
    
    //设置阴影和圆角
    self.backgroundButton.layer.cornerRadius = 10;
    self.backgroundButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.backgroundButton.layer.shadowOffset = CGSizeMake(2, 5);
    self.backgroundButton.layer.shadowOpacity = 0.5;
    self.backgroundButton.layer.shadowRadius = 5;
    self.backgroundButton.alpha = 0.8;
    self.backgroundButton.backgroundColor = [Utils colorWithHexString:@"1296db"];
    
    self.saveButton = [[UIButton alloc]init];
    self.saveButton = [UIButton buttonWithImage:[UIImage imageNamed:@"saveButton"] hightImage:[UIImage imageNamed:@"saveButton_click"] target:self action:@selector(savePhoto)];
    [self.backgroundButton addSubview:self.saveButton];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backgroundButton);
        //        make.bottom.equalTo(self.view.mas_bottom).offset(-30);
        make.centerY.equalTo(self.backgroundButton);
    }];
    
    //设置间隔
    CGFloat sickWidth = (SCREENWIDTH - 30)/6 - (saveImage.size.width - 2)/2;
    NSLog(@"sickWidth = %lf",sickWidth);
    
    self.staButton = [[UIButton alloc]init];
    self.staButton = [UIButton buttonWithImage:[UIImage imageNamed:@"sta"] hightImage:[UIImage imageNamed:@"sta_click"] target:self action:@selector(selectStaColor)];
    [self.backgroundButton addSubview:self.staButton];
    [self.staButton mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.left.equalTo(self.backgroundButton.mas_left).offset(SCREENWIDTH/3 - staImage.size.width/2);
        make.right.equalTo(self.saveButton.mas_left).with.offset(-sickWidth);
        make.centerY.equalTo(self.backgroundButton);
        
    }];
    
    self.tabButton = [[UIButton alloc]init];
    self.tabButton = [UIButton buttonWithImage:[UIImage imageNamed:@"tab"] hightImage:[UIImage imageNamed:@"tab_click"] target:self action:@selector(selectTabColor)];
    [self.backgroundButton addSubview:self.tabButton];
    [self.tabButton mas_makeConstraints:^(MASConstraintMaker *make) {
        //         make.right.equalTo(self.backgroundButton.mas_right).offset(-(SCREENWIDTH/3 - staImage.size.width/2));
        //        make.bottom.equalTo(self.view.mas_bottom).offset(-30);
        make.left.equalTo(self.saveButton.mas_right).with.offset(sickWidth);
        make.centerY.equalTo(self.backgroundButton);
    }];
    
    self.moreButton = [[UIButton alloc]init];
    self.moreButton = [UIButton buttonWithImage:[UIImage imageNamed:@"list"] hightImage:[UIImage imageNamed:@"list_click"] target:self action:@selector(selectType)];
    [self.backgroundButton addSubview:self.moreButton];
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.right.equalTo(self.backgroundButton.mas_right).offset(-((SCREENWIDTH/3 - staImage.size.width/2) / 3));
        make.left.equalTo(self.tabButton.mas_right).with.offset(sickWidth);
        
        //        make.bottom.equalTo(self.view.mas_bottom).offset(-30);
        make.centerY.equalTo(self.backgroundButton);
        
    }];
    
    CGFloat typeH = -30;
    if ([[Utils deviceModelName] isEqualToString:@"iPhone 8"]) {
        typeH = -27;
    }
    
    self.moveButton = [[UIButton alloc]init];
    self.moveButton = [UIButton buttonWithImage:[UIImage imageNamed:@"color"] hightImage:[UIImage imageNamed:@"color_click"] target:self action:@selector(showWithOutTabColorMassage)];
    [self.backgroundButton addSubview:self.moveButton];
    [self.moveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.left.equalTo(self.backgroundButton.mas_left).offset(((SCREENWIDTH/3 - staImage.size.width/2) / 3));
        make.right.equalTo(self.staButton.mas_left).with.offset(-sickWidth);
        
        //        make.bottom.equalTo(self.view.mas_bottom).offset(typeH);
        make.centerY.equalTo(self.backgroundButton);
        
    }];
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
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height/2 : ycenter;
//    ycenter = scrollView.frame.size.height * 1.2;
    self.iXFatView.center = CGPointMake(xcenter, ycenter-30);
}



/**
 *  缩放结束时调用
 */
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    NSLog(@"缩放结束");
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
#warning 激励广告
//    _numReward = [[Utils getCache:@"AdMob" andID:@"Reward"] doubleValue];
//    NSLog(@"_numReward_savebegin = %ld",_numReward);
//    if (viewImage && _numReward > 0) {
//        self.iXImage = [self scaleImage:viewImage];
//        //保存到相册
//        UIGraphicsEndImageContext();
//        UIImageWriteToSavedPhotosAlbum(viewImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//    } else if(_numReward == 0) {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
//            [SVProgressHUD show];
//            sleep(1);
//            [SVProgressHUD dismiss];
//            [self showLoginMassage];
//        });
//    }
    if (viewImage) {
        self.iXImage = [self scaleImage:viewImage];
        //保存到相册
        UIGraphicsEndImageContext();
        UIImageWriteToSavedPhotosAlbum(viewImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [SVProgressHUD show];
            sleep(1);
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:@"请选择截图"];
            sleep(1);
            [SVProgressHUD dismiss];
        });
    }

}

#pragma mark - 提示观看
- (void)showLoginMassage {
    //UIAlertController风格：UIAlertControllerStyleAlert
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"没有制作次数"
                                                                             message:@"观看Ad，增加制作次数吧！"
                                                                      preferredStyle:UIAlertControllerStyleAlert ];
    
    //添加取消到UIAlertController中
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"不看,滚" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        
    }];
    [alertController addAction:cancelAction];
    
    //添加确定到UIAlertController中
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"观看" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        if ([[GADRewardBasedVideoAd sharedInstance] isReady]) {
            [[GADRewardBasedVideoAd sharedInstance] presentFromRootViewController:self];
        } else {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                [SVProgressHUD show];
                sleep(0.5);
                [SVProgressHUD showErrorWithStatus:@"广告尚未准备好,请稍等"];
                sleep(1);
                [SVProgressHUD dismiss];
            });
        }
    }];
    [alertController addAction:OKAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - 选择颜色
- (void)showColorMassage {
    //UIAlertController风格：UIAlertControllerStyleAlert
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择颜色"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet ];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        
    }];
    [alertController addAction:cancelAction];
    
    UIAlertAction *navAction = [UIAlertAction actionWithTitle:@"状态栏背景颜色" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self toGetColorVc];
    }];
    [alertController addAction:navAction];

    UIAlertAction *tabAction = [UIAlertAction actionWithTitle:@"底栏背景颜色" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self toGetColorOfTabVc];
    }];
    [alertController addAction:tabAction];
    
    UIAlertAction *helpAction = [UIAlertAction actionWithTitle:@"帮助" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self toHelpVc];
    }];
    [alertController addAction:helpAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - 选择颜色2
- (void)showWithOutTabColorMassage {
    //UIAlertController风格：UIAlertControllerStyleAlert
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择颜色"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet ];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        
    }];
    [alertController addAction:cancelAction];
    
    UIAlertAction *navAction = [UIAlertAction actionWithTitle:@"状态栏背景颜色" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self toGetColorVc];
    }];
    [alertController addAction:navAction];
    
    UIAlertAction *helpAction = [UIAlertAction actionWithTitle:@"帮助" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self toHelpVc];
    }];
    [alertController addAction:helpAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

//等比例放大
- (UIImage *)scaleImage:(UIImage *)image{
    UIImage *imageX = [UIImage imageNamed:@"iphoneXS"];
    self.iXImageScale = [self getNumberWithChuShu:imageX.size.height  ByChuShu:image.size.height];
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * _iXImageScale, image.size.height * _iXImageScale));
    [image drawInRect:CGRectMake(0, 0, image.size.width * _iXImageScale, image.size.height * _iXImageScale)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
                                
/**
 *  写入图片后执行的操作
 *
 *  @param image       写入的图片
 *  @param error       错误信息
 *  @param contextInfo UIImageWriteToSavedPhotosAlbum第三个参数
 */
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [SVProgressHUD show];
            sleep(1);
            [SVProgressHUD showErrorWithStatus:@"保存失败"];
            sleep(1);
            [SVProgressHUD dismiss];
        });
    }
    else  {
//        if (self.interstitial.isReady) {
//            [self.interstitial presentFromRootViewController:self];
//        } else {
//            NSLog(@"Ad wasn't ready");
//        }
        NSLog(@"保存成功");
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [SVProgressHUD show];
            sleep(0.5);
            [SVProgressHUD dismiss];
           
#warning 激励广告
//            _numReward--;
//            [Utils updateCache:@"AdMob" andID:@"Reward" andValue:[NSString stringWithFormat:@"%ld", _numReward]];//保持次数
//            NSLog(@"_numReward_saveafter = %ld",_numReward);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                KWSaveViewController *saveVc = [[KWSaveViewController alloc]init];
                saveVc.iXImage = self.iXImage;
                [self.navigationController pushViewController:saveVc animated:YES];
            });
        });
    }
}

#pragma mark - 跳转设置页面
- (void)toSettingVc {
    KWSettingViewController *settingVc = [[KWSettingViewController alloc]init];
    [self.navigationController pushViewController:settingVc animated:YES];
}

#pragma mark - 跳转浏览页面
- (void)toVisitVc {
    _iXImage = [self convertViewToImage:_iXFatView];
    KWVisitViewController *visitVc = [[KWVisitViewController alloc]init];
    visitVc.iXImage = _iXImage;
    [self.navigationController pushViewController:visitVc animated:YES];
}

#pragma mark - 跳转帮助页面
- (void)toHelpVc {
    KWHelpViewController *helpVc = [[KWHelpViewController alloc]init];
    [self.navigationController pushViewController:helpVc animated:YES];
}

#pragma mark - 跳转获取颜色页面
- (void)toGetColorVc {
    _iXImage = [self convertViewToImage:_iXFatView];
    if (_iXImage) {
        KWGetColorViewController *getColorVc = [[KWGetColorViewController alloc]init];
        getColorVc.iXImage = _selectedPhotos[0];
        [self.navigationController pushViewController:getColorVc animated:YES];
    } else {
        NSLog(@"没有选择截图");
    }
}

#pragma mark - 跳转获取颜色页面
- (void)toGetColorOfTabVc {
    _iXImage = [self convertViewToImage:_iXFatView];
    if (_iXImage) {
        KWGetColorTabViewController *getColorVc = [[KWGetColorTabViewController alloc]init];
        getColorVc.iXImage = _selectedPhotos[0];
        [self.navigationController pushViewController:getColorVc animated:YES];
    } else {
        NSLog(@"没有选择截图");
    }
}

#pragma mark - GADInterstitialDelegate
///// Tells the delegate an ad request succeeded.
//- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
//    NSLog(@"interstitialDidReceiveAd");
//}
//
///// Tells the delegate an ad request failed.
//- (void)interstitial:(GADInterstitial *)ad
//didFailToReceiveAdWithError:(GADRequestError *)error {
//    NSLog(@"interstitial:didFailToReceiveAdWithError: %@", [error localizedDescription]);
//}
//
///// Tells the delegate that an interstitial will be presented.
//- (void)interstitialWillPresentScreen:(GADInterstitial *)ad {
//    NSLog(@"interstitialWillPresentScreen");
//}
//
///// Tells the delegate the interstitial is to be animated off the screen.
//- (void)interstitialWillDismissScreen:(GADInterstitial *)ad {
//    NSLog(@"interstitialWillDismissScreen");
//}
//
///// Tells the delegate the interstitial had been animated off the screen.
//- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
//    NSLog(@"interstitialDidDismissScreen");
//}
//
///// Tells the delegate that a user click will open another app
///// (such as the App Store), backgrounding the current app.
//- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad {
//    self.interstitial = [self createAndLoadInterstitial];
//    NSLog(@"interstitialWillLeaveApplication");
//}

- (CGFloat)getNumberWithChuShu:(CGFloat)x ByChuShu:(CGFloat)y {
    NSString *xString = [NSString stringWithFormat:@"%lf",x];
    NSString *yString = [NSString stringWithFormat:@"%lf",y];
    NSDecimalNumber *decNumX = [NSDecimalNumber decimalNumberWithString:xString];
    NSDecimalNumber *decNumY = [NSDecimalNumber decimalNumberWithString:yString];
    NSDecimalNumber *result = [decNumX decimalNumberByDividingBy:decNumY];
    return [result doubleValue];
}

- (void)setiXFatViewMove:(id)sender {
    self.moveButton.selected = !self.moveButton.selected;
    if (self.moveButton.selected) {
        _iXView.minimumZoomScale=0.2f;
        _iXView.maximumZoomScale=2.0f;
        NSLog(@"1");
    } else {
        _iXView.minimumZoomScale=0.0f;
        _iXView.maximumZoomScale=0.0f;
        NSLog(@"2");
    }
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
    ActionSheetStringPicker *picker = [[ActionSheetStringPicker alloc]initWithTitle:@"选择截图样式" rows:tabColor initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        if (selectedIndex == 0) {
            [self makeXScreenshotsWitTab:_selectedPhotos[0] and:_selectedPhotos[1]];
            [self addASaveButton];
        } else if (selectedIndex == 1) {
            [self makeXScreenshotsWithOutTab:_selectedPhotos[0] and:_selectedPhotos[1]];
            [self addASaveButtonWithOutTab];
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

#pragma mark - 制作样式Type
- (void)makeXScreenshotsWitTab:(UIImage *)screen1 and:(UIImage *)screen2 {
    if(_selectedPhotos.count == 2) {
        NSString *phoneType = [Utils deviceModelName];
        if ([phoneType isEqualToString:@"iPhone SE"]) {
            [self makeXScreenshotsWithScreenForSE:screen1 and:screen2];
        } else if ([phoneType isEqualToString:@"iPhone 8Plus"]) {
            [self makeXScreenshotsWithScreenFor8Plus:screen1 and:screen2];
        } else if ([phoneType isEqualToString:@"iPhone 8"]) {
            [self makeXScreenshotsWithScreenFor8:screen1 and:screen2];
        }
    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [SVProgressHUD show];
            sleep(1);
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:@"请选择两张截图"];
            sleep(1);
            [SVProgressHUD dismiss];
        });
    }
}

- (void)makeXScreenshotsWithOutTab:(UIImage *)screen1 and:(UIImage *)screen2 {
    if(_selectedPhotos.count == 2) {
        [self makeXScreenshotsWithoutTabWithScreen:screen1 and:screen2];
    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [SVProgressHUD show];
            sleep(1);
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:@"请选择两张截图"];
            sleep(1);
            [SVProgressHUD dismiss];
        });
    }
}

#pragma mark - 制作截图
//获取APP\带底栏截图
- (void)makeXScreenshotsWithScreenFor8Plus:(UIImage *)screen1 and:(UIImage *)screen2 {
    
    _iXViewW = SCREENWIDTH;
    _iXViewH = _iXViewW * [self getNumberWithChuShu:812 ByChuShu:375];
    
    /*********/
    //iXView内容
    self.iXView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _iXViewW , SCREENHEIGHT)];
    self.iXView.backgroundColor = [UIColor clearColor];
    
    //1.1 设置UIScrollView内容的尺寸，滚动范围
    self.iXView.contentSize=CGSizeMake(0, _iXViewH);
    
    //1.2 设置UIScrollView的4周增加额外的滚动区域
    CGFloat distance = 140.0f;
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
    
//    self.iXView.minimumZoomScale=1.0f;
//    self.iXView.maximumZoomScale=2.0f;
//
    //内容View
    self.iXFatView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _iXViewW, _iXViewH)];
    [self.iXView addSubview:self.iXFatView];
    self.iXFatView.backgroundColor = [UIColor clearColor];
    
    /************/
    //scrollViewSS1
    
    CGFloat topInX =  _iXViewH*[self getNumberWithChuShu:48.543479 ByChuShu:812] - [self getNumberWithChuShu:(812*[self getNumberWithChuShu:20 ByChuShu:736]) ByChuShu:812] * _iXViewH;
    self.scrollViewSS1 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topInX , _iXViewW , SCREENHEIGHT)];
    self.scrollViewSS1.backgroundColor = [UIColor clearColor];
    
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
    UIColor *staColor = [_imageView.image colorAtPixel:CGPointMake(_imageView.image.size.width/2, topInX/2+0.1)];//获取颜色
    NSLog(@"staColor = %lf",_iXViewH*[self getNumberWithChuShu:48.543479 ByChuShu:812] + 0.5);
    
    //截取tab位置图片
#warning 计算图片位置
    UIImage *tabNewImage = [UIImage imageFromImage:_imageView.image inRect:CGRectMake(0, _imageView.image.size.height - [self getNumberWithChuShu:49 ByChuShu:736] * _imageView.image.size.height + 2, _imageView.image.size.width, [self getNumberWithChuShu:49 ByChuShu:736] * _imageView.image.size.height)];
    UIImage *tabNewImage2 = [UIImage imageFromImage:tabNewImage inRect:CGRectMake(0, 5, tabNewImage.size.width, tabNewImage.size.height - 5)];
    NSLog(@"_imageView.image.size.height = %lf",_imageView.image.size.height);
    UIColor *tabNewColor = [tabNewImage2 colorAtPixel:CGPointMake(tabNewImage2.size.width/2, 2)];//获取颜色
    
    /************/
    //scrollViewSS2
    CGFloat ss2Top = _scrollViewSS1.KW_height - [self getNumberWithChuShu:(812*[self getNumberWithChuShu:20 ByChuShu:736]) ByChuShu:812] * _iXViewH - [self getNumberWithChuShu:(812*[self getNumberWithChuShu:49 ByChuShu:736]) ByChuShu:812] * _iXViewH + _iXViewH*[self getNumberWithChuShu:48.543479 ByChuShu:812] - 5;
    
    self.scrollViewSS2 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, ss2Top , _iXViewW ,190)];
    self.scrollViewSS2.backgroundColor = [UIColor clearColor];
    
    //scrollViewSS2内容
    self.iXView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH , SCREENHEIGHT)];
    self.iXView.backgroundColor = [UIColor clearColor];
    
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
    self.tabViewForTab = [[UIImageView alloc]initWithFrame:CGRectMake(0, tabImageTop + 1, _iXViewW, 44)];
    self.tabViewForTab.image = tabNewImage2;
    [self.navigationView addSubview:_tabViewForTab];
    
    //tabW
    self.tabView = [[UIImageView alloc]initWithFrame:CGRectMake(0, tabImageH, _iXViewW, tabImageH/6)];
    self.tabView.image = tabImage;
    self.tabView.backgroundColor = [UIColor clearColor];
    [self.navigationView addSubview:_tabView];
}

#pragma mark - 制作截图
//获取APP\带底栏截图 8
- (void)makeXScreenshotsWithScreenFor8:(UIImage *)screen1 and:(UIImage *)screen2 {
    
    _iXViewW = SCREENWIDTH;
    _iXViewH = _iXViewW * [self getNumberWithChuShu:812 ByChuShu:375];
    
    /*********/
    //iXView内容
    self.iXView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _iXViewW , SCREENHEIGHT)];
    self.iXView.backgroundColor = [UIColor clearColor];
    
    //1.1 设置UIScrollView内容的尺寸，滚动范围
    self.iXView.contentSize=CGSizeMake(0, _iXViewH);
    
    //1.2 设置UIScrollView的4周增加额外的滚动区域
    CGFloat distance = 140.0f;
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
    
    //    self.iXView.minimumZoomScale=1.0f;
    //    self.iXView.maximumZoomScale=2.0f;
    //
    //内容View
    self.iXFatView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _iXViewW, _iXViewH)];
    [self.iXView addSubview:self.iXFatView];
    self.iXFatView.backgroundColor = [UIColor clearColor];
    
    /************/
    //scrollViewSS1
    
    CGFloat topInX =  _iXViewH*[self getNumberWithChuShu:48.543479 ByChuShu:812] - [self getNumberWithChuShu:(812*[self getNumberWithChuShu:20 ByChuShu:736]) ByChuShu:812] * _iXViewH;
    self.scrollViewSS1 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topInX , _iXViewW , SCREENHEIGHT)];
    self.scrollViewSS1.backgroundColor = [UIColor clearColor];
    
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
    UIColor *staColor = [_imageView.image colorAtPixel:CGPointMake(_imageView.image.size.width/2, topInX/2+0.1)];//获取颜色
    NSLog(@"staColor = %lf",_iXViewH*[self getNumberWithChuShu:48.543479 ByChuShu:812] + 0.5);
    
    //截取tab位置图片
#warning 计算图片位置
    UIImage *tabNewImage = [UIImage imageFromImage:_imageView.image inRect:CGRectMake(0, _imageView.image.size.height - [self getNumberWithChuShu:49 ByChuShu:667] * _imageView.image.size.height+1, _imageView.image.size.width, [self getNumberWithChuShu:49 ByChuShu:667] * _imageView.image.size.height)];
    UIImage *tabNewImage2 = [UIImage imageFromImage:tabNewImage inRect:CGRectMake(0, 5, tabNewImage.size.width, tabNewImage.size.height - 5)];
    NSLog(@"_imageView.image.size.height = %lf",_imageView.image.size.height);
    UIColor *tabNewColor = [tabNewImage2 colorAtPixel:CGPointMake(tabNewImage2.size.width/2, 2)];//获取颜色
    
    /************/
    //scrollViewSS2
    CGFloat ss2Top = _scrollViewSS1.KW_height - [self getNumberWithChuShu:(812*[self getNumberWithChuShu:20 ByChuShu:736]) ByChuShu:812] * _iXViewH - [self getNumberWithChuShu:(812*[self getNumberWithChuShu:49 ByChuShu:736]) ByChuShu:812] * _iXViewH + _iXViewH*[self getNumberWithChuShu:48.543479 ByChuShu:812] - 5;
    
    self.scrollViewSS2 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, ss2Top , _iXViewW ,190)];
    self.scrollViewSS2.backgroundColor = [UIColor clearColor];
    
    //scrollViewSS2内容
    self.iXView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH , SCREENHEIGHT)];
    self.iXView.backgroundColor = [UIColor clearColor];
    
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
    self.tabViewForTab = [[UIImageView alloc]initWithFrame:CGRectMake(0, tabImageTop + 1, _iXViewW, 44)];
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
    CGFloat distance = 140.0f;
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
    
//    self.iXView.minimumZoomScale=1.0f;
//    self.iXView.maximumZoomScale=2.0f;
    
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
    UIColor *staColor = [_imageView.image colorAtPixel:CGPointMake(_imageView.image.size.width/2, topInX/2+0.1)];//获取颜色
    NSLog(@"staColor = %lf",_iXViewH*[self getNumberWithChuShu:48.543479 ByChuShu:812] + 0.5);
    
    //截取tab位置图片
#warning 计算图片位置
    UIImage *tabNewImage2 = [UIImage imageFromImage:_imageView.image inRect:CGRectMake(0, _imageView.image.size.height - [self getNumberWithChuShu:49 ByChuShu:568] * _imageView.image.size.height + 11, _imageView.image.size.width, [self getNumberWithChuShu:49 ByChuShu:568] * _imageView.image.size.height)];
    //    UIImage *tabNewImage2 = [UIImage imageFromImage:tabNewImage inRect:CGRectMake(0, 0, tabNewImage.size.width, tabNewImage.size.height - 5)];
    NSLog(@"_imageView.image.size.height = %lf",_imageView.image.size.height);
    UIColor *tabNewColor = [tabNewImage2 colorAtPixel:CGPointMake(tabNewImage2.size.width/2, 2)];//获取颜色
    
    /************/
    //scrollViewSS2
    CGFloat ss2Top = _scrollViewSS1.KW_height - [self getNumberWithChuShu:(812*[self getNumberWithChuShu:20 ByChuShu:736]) ByChuShu:812] * _iXViewH - [self getNumberWithChuShu:(812*[self getNumberWithChuShu:49 ByChuShu:736]) ByChuShu:812] * _iXViewH + _iXViewH*[self getNumberWithChuShu:48.543479 ByChuShu:812] - 5;
    
    self.scrollViewSS2 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, ss2Top , _iXViewW ,160)];
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
    self.tabViewForTab = [[UIImageView alloc]initWithFrame:CGRectMake(0, tabImageTop - 1, _iXViewW, 42)];
    self.tabViewForTab.image = tabNewImage2;
//    self.tabViewForTab.backgroundColor = [UIColor redColor];
//    self.tabViewForTab.image = nil;
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
    
    //1.2 设置UIScrollView的4周增加额外的滚动区域 65.0f则刚好在屏幕底部
    CGFloat distance = 140.0f;
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
    
//    self.iXView.minimumZoomScale=0.5f;
//    self.iXView.maximumZoomScale=2.0f;
    
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
    UIColor *staColor = [_imageView.image colorAtPixel:CGPointMake(_imageView.image.size.width/2, topInX/2+0.1)];//获取颜色
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
    
    NSString *phoneType = [Utils deviceModelName];
    CGFloat ss2H = 200;
    if ([phoneType isEqualToString:@"iPhone SE"]) {
        ss2H = 160;
    } else if ([phoneType isEqualToString:@"iPhone 8"]) {
        ss2H = 200;
    }
    
    self.scrollViewSS2 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, ss2Top , _iXViewW ,ss2H)];
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
