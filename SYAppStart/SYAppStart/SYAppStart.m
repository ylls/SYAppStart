//
//  SYAppStart.m
//  FEShareLib
//
//  Created by 余书懿 on 13-5-25.
//  Copyright (c) 2013年 DoudouApp. All rights reserved.
//

#import "SYAppStart.h"

/**
 *	@brief	通过SYAppStartViewController 来确保SYAppStart始终保持竖屏状态启动
 */
@interface SYAppStartViewController : UIViewController
@property (nonatomic,strong) UIImage *customImage;
@end

@interface SYWindow : UIWindow
@end


@implementation SYAppStartConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.launchImageName = @"LaunchImage";
        self.launchScreenName = @"LaunchScreen";
        self.useLaunchScreen = YES;
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"%@ release",NSStringFromClass([self class]));
}

@end


@implementation SYAppStart


#define Tag_appStartImageView 1314521

static UIWindow *startImageWindow = nil;
static SYAppStartConfig *appStartConfig = nil;

+ (SYAppStartConfig *)config {
    if (appStartConfig == nil) {
        appStartConfig = [SYAppStartConfig new];
    }
    return appStartConfig;
}


+ (void)show {
    [self showWithImage:nil];
}

+ (void)showWithImage:(UIImage *)image hideAfterDelay:(NSTimeInterval)delay {
    [self showWithImage:image];
    [self hide:YES afterDelay:delay];
}

+ (void)showWithImage:(UIImage *)image
{
    if (startImageWindow == nil) {
        startImageWindow = [[SYWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        startImageWindow.backgroundColor = [UIColor clearColor];
        startImageWindow.userInteractionEnabled = YES;
        startImageWindow.windowLevel = UIWindowLevelAlert + 1;

        SYAppStartViewController *appStartViewController = [[SYAppStartViewController alloc] init];
        appStartViewController.customImage = image;
        startImageWindow.rootViewController = appStartViewController;
    }

    [startImageWindow setHidden:NO];
}

+ (void)hide:(BOOL)animated {
    [self hide:animated afterDelay:0.0];
}

+ (void)hide:(BOOL)animated afterDelay:(NSTimeInterval)delay
{
    UIImageView *imageView = (UIImageView *)[startImageWindow viewWithTag:Tag_appStartImageView];
    if (imageView) {
        if (animated) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.75 delay:0.0 options:0 animations:^{
                    [imageView setTransform:CGAffineTransformMakeScale(2, 2)];
                    [imageView setAlpha:0];
                } completion:^(BOOL finished) {
                    [SYAppStart clear];
                }];
            });
        }else
        {
            [SYAppStart clear];
        }
    }
}

+ (void)hideWithCustomBlock:(void (^)(UIImageView *))block
{
    UIImageView *imageView = (UIImageView *)[startImageWindow viewWithTag:Tag_appStartImageView]; 
    if (imageView) {
        if (block) {
            block(imageView);
        }
    }
}

+ (void)clear
{
    UIImageView *imageView = (UIImageView *)[startImageWindow viewWithTag:Tag_appStartImageView];
    [imageView removeFromSuperview];
    startImageWindow.rootViewController = nil;
    [startImageWindow removeFromSuperview];
    startImageWindow = nil;
    appStartConfig.viewCustomBlock = nil;
    appStartConfig = nil;
}

+ (UIView *)getDefaultLaunchView
{
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:[SYAppStart config].launchScreenName owner:self options:nil];
    if (nibs.count > 0) {
        UIView *launchView = nibs[0];
        return launchView;
    }
    return nil;
}

+ (UIImage *)getDefaultLaunchImage:(UIInterfaceOrientation)orientation
{
    NSString *imageName = nil;
    CGSize screenSize = [[UIScreen mainScreen] currentMode].size;
    //判断是否是iPhone5
    if (CGSizeEqualToSize(CGSizeMake(640, 1136), screenSize)) {
        imageName = @"-700-568h@2x.png";
    }else if (CGSizeEqualToSize(CGSizeMake(750, 1334), screenSize))
    {
        imageName = @"-800-667h@2x.png";
    }else if (CGSizeEqualToSize(CGSizeMake(1242, 2208), screenSize))
    {
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            imageName = @"-800-Landscape-736h@3x.png";
        }
        else
        {
            imageName = @"-800-Portrait-736h@3x.png";
        }
    }
    else if (CGSizeEqualToSize(CGSizeMake(640, 960), screenSize))
    {
        imageName = @"-700@2x.png";
    }
    
    imageName = [[SYAppStart config].launchImageName stringByAppendingString:imageName];
    
    //使用 imageWithContentsOfFile 加载图片使用完以后及时释放资源
    NSString *imageFilePath = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] bundlePath],imageName];
    UIImage *image = [UIImage imageWithContentsOfFile:imageFilePath];
    if (image == nil) {
        NSAssert(NO, @"两个原因导致没有获取到默认背景图片 1:名字没有使用 Default.png? 2: 使用了iOS7 的新特性 Images Assets?");
    }
    return image;
}


@end



@implementation SYAppStartViewController
////App Start 在显示的时候不需要状态, 在iOS 7隐藏状态栏 需要重写以下方法
//- (BOOL)prefersStatusBarHidden
//{
//    return NO;
//}
//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}


- (BOOL)shouldAutorotate {
    return NO;
}


- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0f && [SYAppStart config].useLaunchScreen) {
        UIView *launchView = [SYAppStart getDefaultLaunchView];
        [self.view addSubview:launchView];
        [launchView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight)];
        [launchView setFrame:self.view.bounds];
    }else if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f) {
        UIImageView *imageView = nil;
        imageView = [[UIImageView alloc] initWithImage:[SYAppStart getDefaultLaunchImage:self.interfaceOrientation]];
        [self.view addSubview:imageView];
        [imageView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight)];
        [imageView setFrame:self.view.bounds];
    }
    self.view.tag = Tag_appStartImageView;
    
    if (self.customImage != nil) {
        
        UIView *imageContainerView = [[UIView alloc] initWithFrame:self.view.bounds];
        [imageContainerView setBackgroundColor:[UIColor clearColor]];
        imageContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imageContainerView.alpha = 0.0f;
        [self.view addSubview:imageContainerView];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:self.customImage];
        [imageView setFrame:imageContainerView.bounds];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [imageView setBackgroundColor:[UIColor clearColor]];
        [imageContainerView addSubview:imageView];
        
        if ([SYAppStart config].viewCustomBlock != nil) {
            [SYAppStart config].viewCustomBlock(self.view,imageContainerView);
        }
        
        [UIView animateWithDuration:0.25 animations:^{
            imageContainerView.alpha = 1.0f;
        }];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}

- (void)dealloc
{
    self.customImage = nil;
    NSLog(@"%@ release",NSStringFromClass([self class]));
}

@end



@implementation SYWindow : UIWindow


- (void)dealloc
{
    NSLog(@"%@ release",NSStringFromClass([self class]));
}

@end
