//
//  SYAppStart.h version 1.1
//  FEShareLib
//
//  Created by yushuyi on 13-5-25.
//  Copyright (c) 2013年 DoudouApp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



typedef void(^SYAppStartViewCustomBlock)(UIView *rootView,UIView *imageContainerView);

@interface SYAppStartConfig : NSObject

/**
 *  Asset Catalog LaunchImage 的 名字 Default LaunchImage
 */
@property (nonatomic,copy) NSString *launchImageName;

/**
 *  iOS 8 Launch Screen 的 名字 Default LaunchScreen
 */
@property (nonatomic,copy) NSString *launchScreenName;

/**
 *  在iOS8环境是否使用LaunchScreen 作为启动画面 Default YES
 */
@property (nonatomic,assign) BOOL useLaunchScreen;


@property (nonatomic,copy) SYAppStartViewCustomBlock viewCustomBlock;


@end



@interface SYAppStart : NSObject

/**
 *  SYAppStart 配置信息
 *
 *  @return 返回配置实例
 */
+ (SYAppStartConfig *)config;

/**
 *		显示App启动插画 保持与启动时效果的一致 自动匹配iPhone 5尺寸的启动图片 
            请在首个Controller 的 viewWillAppear 里面执行
 *
 */
+ (void)show;
/**
 *  如果有首次启动的广告闪屏需求 请通过此方法传入需要显示图片 并 调用 hide 设定 afterDelay
 *
 *  @param image image
 */
+ (void)showWithImage:(UIImage *)image;
+ (void)showWithImage:(UIImage *)image hideAfterDelay:(NSTimeInterval)delay;


/**
 *		以默认动画效果隐藏App启动图片 
            请在首个Controller 的 viewWillAppear 里面执行 viewDidAppear 里面执行
 */
+ (void)hide:(BOOL)animated;
+ (void)hide:(BOOL)animated afterDelay:(NSTimeInterval)delay;
/**
 *		以自定义隐藏动画的方式隐藏App启动图片
            请在首个Controller 的 viewWillAppear 里面执行 viewDidAppear 里面执行
 */
+ (void)hideWithCustomBlock:(void(^)(UIImageView *imageView))block;


/**
 *		清理,只在自定义动画时才需要调用
 */
+ (void)clear;






/**
 *		获取Default.png 自动判断iPhone 5
 *
 *	@return	image
 */
+ (UIImage *)getDefaultLaunchImage:(UIInterfaceOrientation)orientation;


/**
 *  获取默认启动Xib文件,iOS8开始支持Xib启动页
 *
 *  @return UIView
 */
+ (UIView *)getDefaultLaunchView;


@end



