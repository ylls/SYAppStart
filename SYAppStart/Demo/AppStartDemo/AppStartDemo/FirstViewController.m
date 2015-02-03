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
    [[[UIAlertView alloc] initWithTitle:@"sssss" message:@"sssss" delegate:nil cancelButtonTitle:@"Message" otherButtonTitles: nil] show];
    
    
    
    if (!_isFirstWillAppear) {
        _isFirstWillAppear = YES;
        [[SYAppStart config] setUseLaunchScreen:NO];
        [[SYAppStart config] setViewCustomBlock:^(UIView *containerView){
        
            UIView *view11 = [[UIView alloc] initWithFrame:(CGRect){{0,0  },{50,50}}];
            [view11 setBackgroundColor:[UIColor redColor]];
            [containerView addSubview:view11];
        }];
        [SYAppStart showWithImage:[UIImage imageNamed:@"Secrren"]];
    }
}
- (void)viewDidAppear:(BOOL)animated
{
    if (!_isFirstDidAppear) {
        _isFirstDidAppear = YES;
        [SYAppStart hide:YES afterDelay:3.0];
    }
}


@end
