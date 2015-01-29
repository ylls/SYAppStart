//
//  SYAppStart.m
//  FEShareLib
//
//  Created by 余书懿 on 13-5-25.
//  Copyright (c) 2013年 豆豆集团. All rights reserved.
//

#import "SYAppStart.h"

@interface SYWindow : UIWindow

@end

@implementation SYWindow : UIWindow


- (void)dealloc
{
    NSLog(@"%@ release",NSStringFromClass([self class]));
}

@end

@implementation SYAppStart


#define Tag_appStartImageView 1314521

static UIWindow *startImageWindow = nil;
static NSString *SYLaunchImageName = @"LaunchImage";
static BOOL SYLaunchImageUseLaunchScreen = YES;

+ (void)setLaunchImageName:(NSString *)launchImage
{
    SYLaunchImageName = launchImage;
}

+ (void)setUseLaunchScreen:(BOOL)use
{
    SYLaunchImageUseLaunchScreen = use;
}

+ (void)show
{
    if (startImageWindow == nil) {
        startImageWindow = [[SYWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        startImageWindow.backgroundColor = [UIColor clearColor];
        startImageWindow.userInteractionEnabled = NO;
        startImageWindow.windowLevel = UIWindowLevelStatusBar + 1; //必须加1
        startImageWindow.rootViewController = [[SYAppStartViewController alloc] init];
    }

    [startImageWindow setHidden:NO];
}
+ (void)hide:(BOOL)animated
{
    UIImageView *imageView = (UIImageView *)[startImageWindow viewWithTag:Tag_appStartImageView];
    if (imageView) {
        if (animated) {
            [UIView animateWithDuration:1.5 delay:0 options:0 animations:^{
                [imageView setTransform:CGAffineTransformMakeScale(2, 2)];
                [imageView setAlpha:0];
            } completion:^(BOOL finished) {
                [SYAppStart clear];
            }];
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
}

+ (UIView *)getDefaultLaunchView
{
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"LaunchScreen" owner:self options:nil];
    if (nibs.count > 0) {
        UIView *launchView = nibs[0];
        return launchView;
    }
    return nil;
}

+ (UIImage *)getDefaultImage:(UIInterfaceOrientation)orientation
{
    NSString *imageName = nil;
    CGSize screenSize = [[UIScreen mainScreen] currentMode].size;
    //判断是否是iPhone5
    if (CGSizeEqualToSize(CGSizeMake(640, 1136), screenSize)) {
        imageName = @"-700-568h@2x.png";
    }else if (CGSizeEqualToSize(CGSizeMake(640, 1136), screenSize))
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
    
    imageName = [SYLaunchImageName stringByAppendingString:imageName];
    
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
//- (BOOL)shouldAutorotate {
//    return NO;
//}


//- (NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskPortrait;
//}


- (void)viewDidLoad
{
    [super viewDidLoad];

    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0f && SYLaunchImageUseLaunchScreen) {
        UIView *launchView = [SYAppStart getDefaultLaunchView];
        [self.view addSubview:launchView];
        [launchView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight)];
        [launchView setFrame:self.view.bounds];
        launchView.tag = Tag_appStartImageView;
    }else if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f) {
        UIImageView *imageView = nil;
        imageView = [[UIImageView alloc] initWithImage:[SYAppStart getDefaultImage:self.interfaceOrientation]];
        imageView.tag = Tag_appStartImageView;
        [self.view addSubview:imageView];
        [imageView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight)];
        [imageView setFrame:self.view.bounds];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}




- (void)dealloc
{
    NSLog(@"%@ release",NSStringFromClass([self class]));
}

@end
