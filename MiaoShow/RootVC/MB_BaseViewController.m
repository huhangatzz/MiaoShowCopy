//
//  MP_BaseViewController.m
//  mp_business
//
//  Created by pengkaichang on 14-10-8.
//  Copyright (c) 2014年 com.soudoushi.makepolo. All rights reserved.
//

#import "MB_BaseViewController.h"
#import "AppDelegate.h"

@interface MB_BaseViewController ()

@end

@implementation MB_BaseViewController

- (MBProgressHUD *)progressHud {
    
    if (!_progressHud) {
       
        _progressHud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_progressHud];
        [self.view bringSubviewToFront:_progressHud];
        _progressHud.delegate = self;
        _progressHud.labelText = HUD_LOADING_TIPS;
    }
    return _progressHud;
}

#pragma mark - View LifeCycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithHexString:DEFAULT_BACKGROUND_COLOR];
}

- (void)setTask:(NSURLSessionDataTask *)task{

    if (_task) {
        [_task cancel];
        _task = nil;
    }
    _task = task;
}

- (void)viewWillDisappear:(BOOL)animated{
    if (self.task) {
        [self.task cancel];
    }
}

#pragma mark - Rotoate
- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud {
    
    [self.progressHud removeFromSuperview];
    self.progressHud = nil;
}

@end


