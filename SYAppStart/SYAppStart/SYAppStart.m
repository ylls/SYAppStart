//
//  SYAppStart.m
//  FEShareLib
//
//  Created by 余书懿 on 13-5-25.
//  Copyright (c) 2013年 珠海飞企. All rights reserved.
//

#import "SYAppStart.h"

@implementation SYAppStart


#define Tag_appStartImageView 1314521

static UIWindow *startImageWindow = nil;

+ (void)show
{
    if (startImageWindow == nil) {
        startImageWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        startImageWindow.backgroundColor = [UIColor clearColor];
        startImageWindow.userInteractionEnabled = NO;
        startImageWindow.windowLevel = UIWindowLevelStatusBar + 1; //必须加1
    }
    UIImageView *imageView = nil;
    NSString *imageName = nil;
    //判断是否是iPhone5
    if (CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size)) {
        imageName = @"Default-568h.png";
    }else
    {
         imageName = @"Default.png";
    }
    //使用 imageWithContentsOfFile 加载图片使用完以后及时释放资源
    NSString *imageFilePath = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] bundlePath],imageName];
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:imageFilePath]];
    
    
    imageView.tag = Tag_appStartImageView;
    [startImageWindow addSubview:imageView];
    [startImageWindow setHidden:NO];
}
+ (void)hide
{
    UIImageView *imageView = (UIImageView *)[startImageWindow viewWithTag:Tag_appStartImageView];
    if (imageView) {
        
        [UIView animateWithDuration:1.5 delay:0 options:0 animations:^{
            [imageView setTransform:CGAffineTransformMakeScale(2, 2)];
            [imageView setAlpha:0];
        } completion:^(BOOL finished) {
            [SYAppStart clear];
        }];
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
    [startImageWindow removeFromSuperview];
    startImageWindow = nil;
}

@end
