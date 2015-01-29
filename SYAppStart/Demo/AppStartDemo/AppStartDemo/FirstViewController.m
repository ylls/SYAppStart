//
//  FirstViewController.m
//  AppStartDemo
//
//  Created by 余书懿 on 13-5-25.
//  Copyright (c) 2013年 余书懿. All rights reserved.
//

#import "FirstViewController.h"
#import "SYAppStart.h"





@implementation FirstViewController
{
    BOOL _isFirstWillAppear;
    BOOL _isFirstDidAppear;

}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    if (!_isFirstWillAppear) {
        _isFirstWillAppear = YES;
        [SYAppStart setUseLaunchScreen:NO];
        [SYAppStart show];
    }
}
- (void)viewDidAppear:(BOOL)animated
{
    if (!_isFirstDidAppear) {
        _isFirstDidAppear = YES;
        [SYAppStart hide:YES];
    }
}


@end
