//
//  SYAppStart.m
//  FEShareLib
//
//  Created by yushuyi on 13-5-25.
//  Copyright (c) 2013年 DoudouApp. All rights reserved.
//

#import "SYAppStart.h"



BOOL const SYAppStartMonitorRelease = true;


@interface SYAppStartViewController : UIViewController

@property (nonatomic,strong) UIImage *customImage;
@property (nonatomic,strong) AVPlayerItem *videoPlayerItem;
@property (nonatomic,strong) AVPlayer *videoPlayer;
@property (nonatomic,strong) AVPlayerLayer *videoPlayerLayer;

@end

@interface SYWindow : UIWindow
@end

@implementation SYAppStart


#define Tag_appStartImageView 1314521

static UIWindow *appStartWindow = nil;
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

+ (void)showWithImage:(UIImage *)image
{
    [self showWithImage:image hideAfterDelay:0];
}

+ (void)showWithImage:(UIImage *)image hideAfterDelay:(NSTimeInterval)delay {
    SYAppStartViewController *appStartViewController = [[SYAppStartViewController alloc] init];
    appStartViewController.customImage = image;
    [self showWithStartController:appStartViewController];
    if (delay > 0) {
        [self hide:YES afterDelay:delay];
    }
}

+ (void)showWithVideo:(AVPlayerItem *)playerItem {
    SYAppStartViewController *appStartViewController = [[SYAppStartViewController alloc] init];
    appStartViewController.videoPlayerItem = playerItem;
    [self showWithStartController:appStartViewController];
}

+ (void)showWithStartController:(SYAppStartViewController *)viewController {
    if (appStartWindow == nil) {
        appStartWindow = [[SYWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        appStartWindow.backgroundColor = [UIColor clearColor];
        appStartWindow.userInteractionEnabled = YES;
        appStartWindow.windowLevel = UIWindowLevelAlert + 1;
        
        appStartWindow.rootViewController = viewController;
    }
    
    [appStartWindow setHidden:NO];
}

+ (void)hide:(BOOL)animated {
    [self hide:animated afterDelay:0.0];
}

+ (void)hide:(BOOL)animated afterDelay:(NSTimeInterval)delay {
    [self hide:animated afterDelay:delay customBlock:nil];
}

+ (void)hide:(BOOL)animated afterDelay:(NSTimeInterval)delay customBlock:(SYAppStartHideCustomBlock)block {
    if (animated) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (block) {
                [self hideWithCustomBlock:block];
            }else {
                [self hideWithCustomBlock:^(UIView *containerView) {
                    [containerView setTransform:CGAffineTransformMakeScale(1.5, 1.5)];
                    [containerView setAlpha:0];
                }];
            }
        });
    }else
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SYAppStart clear];
        });
    }
}

+ (void)hideWithCustomBlock:(SYAppStartHideCustomBlock)block {
    UIView *containerView = [appStartWindow viewWithTag:Tag_appStartImageView];
    if (containerView) {
        if (block) {
            [UIView animateWithDuration:0.65 delay:0.0 options:0 animations:^{
                block(containerView);
            } completion:^(BOOL finished) {
                [SYAppStart clear];
            }];
        }
    }
}

+ (void)clear
{
    appStartWindow.userInteractionEnabled = NO; // iOS 7 才需要这行代码， iOS 7的 UIAlertView 在 show 以后 会持有 显示在最上层的Window。 在这种情况下，只能等UIAlertView释放。 这里才会自动释放
    appStartWindow.rootViewController = nil;
    [appStartWindow removeFromSuperview];
    appStartWindow = nil;
    appStartConfig.viewCustomBlock = nil;
    appStartConfig = nil;
}

+ (UIView *)getDefaultLaunchView
{
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *path = [mainBundle pathForResource:[self config].launchScreenName ofType:@"nib"];
    if (!path){
        NSString *errorDescription = [NSString stringWithFormat:@"没有找到名称为%@.xib的文件，请检查工程中是否启用了LaunchScreen",[self config].launchScreenName];
        NSAssert(NO, errorDescription);
        return nil;
    }
    
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:[self config].launchScreenName owner:self options:nil];
    if (nibs.count > 0) {
        UIView *launchView = nibs[0];
        return launchView;
    }
    return nil;
}

+ (UIViewController *)getDefaultLaunchStoryboardViewController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[self config].launchScreenStoryboardName bundle:nil];
    return [storyboard instantiateInitialViewController];
}


+ (UIImage *)getDefaultLaunchImage:(UIInterfaceOrientation)orientation
{
    NSString *imageName = @"-700@2x.png";
    CGSize screenSize = [[UIScreen mainScreen] currentMode].size;
    //判断是否是iPhone5
    if (CGSizeEqualToSize(CGSizeMake(640, 1136), screenSize)) {
        imageName = @"-700-568h@2x.png";
    }else if (CGSizeEqualToSize(CGSizeMake(750, 1334), screenSize))
    {
        imageName = @"-800-667h@2x.png";
    }else if (CGSizeEqualToSize(CGSizeMake(1242, 2208), screenSize) || CGSizeEqualToSize(CGSizeMake(1125, 2001), screenSize))
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

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (BOOL)shouldAutorotate {
    return NO;
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    UIView *launchView = nil;
    SYAppStartResourceType resourceType = [SYAppStart config].resourceType;
    if (resourceType == SYAppStartResourceTypeXib) {
        launchView = [SYAppStart getDefaultLaunchView];
    }else if (resourceType == SYAppStartResourceTypeStoryboard) {
        UIViewController *launchViewController = [SYAppStart getDefaultLaunchStoryboardViewController];
        [self addChildViewController:launchViewController];
        launchView = launchViewController.view;
    }else if (resourceType == SYAppStartResourceTypeImage) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[SYAppStart getDefaultLaunchImage:[UIApplication sharedApplication].statusBarOrientation]];
        launchView = imageView;
    }
    [self.view addSubview:launchView];
    [launchView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight)];
    [launchView setFrame:self.view.bounds];
    
    self.view.tag = Tag_appStartImageView;
    
    UIView *containerView = [[UIView alloc] initWithFrame:self.view.bounds];
    [containerView setBackgroundColor:[UIColor clearColor]];
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    containerView.alpha = 0.0f;
    [self.view addSubview:containerView];
    
    if (self.customImage != nil) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:self.customImage];
        [imageView setFrame:containerView.bounds];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [imageView setBackgroundColor:[UIColor clearColor]];
        [containerView addSubview:imageView];
        
        if ([SYAppStart config].viewCustomBlock != nil) {
            [SYAppStart config].viewCustomBlock(self.view,containerView);
        }
    }else if (self.videoPlayerItem != nil){
        AVPlayer *player = [AVPlayer playerWithPlayerItem:self.videoPlayerItem];
        player.volume = 1.0f;
        
        AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        playerLayer.frame = containerView.layer.bounds;
        [containerView.layer addSublayer:playerLayer];
        self.videoPlayerLayer = playerLayer;
        self.videoPlayer = player;
        [player play];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playToEndTimeNotification:) name:AVPlayerItemDidPlayToEndTimeNotification object:player.currentItem];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        containerView.alpha = 1.0f;
    }];
    
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.customImage = nil;
    self.videoPlayerItem = nil;
    self.videoPlayerLayer = nil;
    self.videoPlayer = nil;
    
    if (SYAppStartMonitorRelease) {
        NSLog(@"%@ release",NSStringFromClass([self class]));
    }
}


- (void)playToEndTimeNotification:(NSNotification *)notification {
    [self.videoPlayerLayer removeFromSuperlayer];
    [SYAppStart hide:true];
}


@end



@implementation SYWindow : UIWindow

- (void)dealloc
{
    if (SYAppStartMonitorRelease) {
        NSLog(@"%@ release",NSStringFromClass([self class]));
    }
}

@end


@implementation SYAppStartConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.launchImageName = @"LaunchImage";
        self.launchScreenName = @"LaunchScreen";
        self.launchScreenStoryboardName = @"LaunchScreen";
        self.resourceType = SYAppStartResourceTypeXib;
    }
    return self;
}

- (void)dealloc
{
    if (SYAppStartMonitorRelease) {
        NSLog(@"%@ release",NSStringFromClass([self class]));
    }
}

@end
