//
//  SYAppStart.h version 2.0
//  FEShareLib
//
//  Created by yushuyi on 13-5-25.
//  Copyright (c) 2013年 DoudouApp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


typedef void(^SYAppStartViewCustomBlock)(UIView *rootView,UIView *imageContainerView,UIImageView *imageView);
typedef void(^SYAppStartHideCustomBlock)(UIView *containerView);

typedef NS_ENUM(NSInteger, SYAppStartResourceType) {
    SYAppStartResourceTypeImage NS_ENUM_AVAILABLE_IOS(7.0) = 0,
    SYAppStartResourceTypeXib NS_ENUM_AVAILABLE_IOS(8.0),
    SYAppStartResourceTypeStoryboard NS_ENUM_AVAILABLE_IOS(8.0)
};

@interface SYAppStartConfig : NSObject

/**
 *  Asset Catalog LaunchImage 的 名字 Default LaunchImage
 */
@property (nonatomic,copy) NSString *launchImageName;

/**
 *  iOS 8 Launch Screen.xib 的 名字 Default LaunchScreen
 */
@property (nonatomic,copy) NSString *launchScreenName;

/**
 *  iOS 8 Launch Screen.storyboard 的 名字 Default LaunchScreen
 */
@property (nonatomic,copy) NSString *launchScreenStoryboardName;

/**
 *  SYAppStart加载的资源类型 Defualt 是以加载Asset Catalog 的 Launch 图片的方式 在iOS8以后可以使用 Xib 或者 Storyboard
 */
@property (nonatomic,assign) SYAppStartResourceType resourceType;

/**
 *  在呈现视图上面 进行 自定义代码和样式的添加
 */
@property (nonatomic,copy) SYAppStartViewCustomBlock viewCustomBlock;

/**
 *  设置闪屏消失时候的动画
 */
@property (nonatomic,copy) SYAppStartHideCustomBlock hideAnimationBlock;

@end



@interface SYAppStart : NSObject

/**
 *	只显示一次的键值
 *
 *	@param	keyString	键值名称
 *
 *	@return	YES 第一次用到这个键值  NO 不是首次加载了
 */
+ (BOOL)startForKey:(NSString *)keyString;

/**
 *  SYAppStart 配置信息 调用此函数进行修改配置信息
 *
 *  @return 返回配置实例
 */
+ (SYAppStartConfig *)config;

/**
 *	显示App启动插画 保持与启动时效果的一致
 *  在首个Controller 的 viewWillAppear 里面执行
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

//Show Video
+ (void)showWithVideo:(AVPlayerItem *)playerItem;

/**
 *		以默认动画效果隐藏App启动图片 
            请在首个Controller 的 viewWillAppear 里面执行 viewDidAppear 里面执行
 */
+ (void)hide:(BOOL)animated;
+ (void)hide:(BOOL)animated afterDelay:(NSTimeInterval)delay;
+ (void)hide:(BOOL)animated afterDelay:(NSTimeInterval)delay customBlock:(SYAppStartHideCustomBlock)block;
/**
 *		以自定义隐藏动画的方式隐藏App启动图片
            请在首个Controller 的 viewWillAppear 里面执行 viewDidAppear 里面执行
        Block 在动画中执行
 */
+ (void)hideWithCustomBlock:(SYAppStartHideCustomBlock)block;


/**
 *  清理
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


+ (UIViewController *)getDefaultLaunchStoryboardViewController;


@end



