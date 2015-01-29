//
//  SYAppStart.h version 0.9
//  FEShareLib
//
//  Created by yushuyi on 13-5-25.
//  Copyright (c) 2013年 DoudouApp. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SYAppStart : NSObject


+ (void)setLaunchImageName:(NSString *)launchImage;
+ (void)setUseLaunchScreen:(BOOL)use;

/**
 *		显示App启动插画 保持与启动时效果的一致 自动匹配iPhone 5尺寸的启动图片 
            请在首个Controller 的 viewWillAppear 里面执行
 *
 */
+ (void)show;

/**
 *		以默认动画效果隐藏App启动图片 
            请在首个Controller 的 viewWillAppear 里面执行 viewDidAppear 里面执行
 */
+ (void)hide:(BOOL)animated;

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
+ (UIImage *)getDefaultImage:(UIInterfaceOrientation)orientation;


/**
 *  获取默认启动Xib文件,iOS8开始支持Xib启动页
 *
 *  @return UIView
 */
+ (UIView *)getDefaultLaunchView;


@end

/**
 *	@brief	通过SYAppStartViewController 来确保SYAppStart始终保持竖屏状态启动
 */
@interface SYAppStartViewController : UIViewController


@end

