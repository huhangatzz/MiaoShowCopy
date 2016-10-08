//
//  TabBarViewController.m
//  tabBar
//
//  Created by makepolo-ios on 15/7/9.
//  Copyright (c) 2015年 huhang. All rights reserved.
//

#import "MB_TabBarViewController.h"
#import "MB_NavigationViewController.h"
#import "MB_HomePageViewController.h"
#import "MB_ShowTimeViewController.h"
#import "UIDevice+SLExtension.h"
#import <AVFoundation/AVFoundation.h>

@interface MB_TabBarViewController ()<UITabBarControllerDelegate>

@end

@implementation MB_TabBarViewController

+ (void)initialize{

    NSDictionary *titles = @{NSForegroundColorAttributeName:[UIColor grayColor],NSFontAttributeName:[UIFont systemFontOfSize:10]};
    NSDictionary *selectTitles = @{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:[UIFont systemFontOfSize:10]};
    
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:titles forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectTitles forState:UIControlStateSelected];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    
    [self setupViewControlller];
}

- (void)setupViewControlller{

    [self addChildViewController:[[MB_HomePageViewController alloc]init] imageName:@"toolbar_home" titleName:@"主页"];
    UIViewController *showTimeVC = [[UIViewController alloc]init];
    [self addChildViewController:showTimeVC imageName:@"toolbar_live" titleName:@"直播"];

    UIViewController *profileVC = [[UIViewController alloc]init];
    profileVC.title = @"个人中心";
    [self addChildViewController:profileVC imageName:@"toolbar_me" titleName:@"我的"];
}

- (void)addChildViewController:(UIViewController *)vc imageName:(NSString *)imageName titleName:(NSString *)titleName{
    
    vc.tabBarItem.title = titleName;
    vc.tabBarItem.image = [UIImage imageNamed:imageName];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_sel",imageName]];
    
    MB_NavigationViewController *nav = [[MB_NavigationViewController alloc]initWithRootViewController:vc];
    [self addChildViewController:nav];
}

#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{

    //如果点击了直播
    if ([tabBarController.childViewControllers indexOfObject:viewController] == 1) {
        
        //判断是否是模拟器
        if ([[UIDevice deviceVersion] isEqualToString:@"iPhone Simulator"]) {
            [self showInfo:@"请使用真机进行测试,此模块模拟器不支持"];
            return NO;
        }
        
        //判断是否有摄像头
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [self showInfo:@"您的设备没有摄像头"];
            return NO;
        }
        
        //判断是否有摄像头权限
        AVAuthorizationStatus authorStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authorStatus == AVAuthorizationStatusRestricted || authorStatus == AVAuthorizationStatusDenied) {
            [self showInfo:@"app需要访问您的摄像头.\n请启用摄像头-设置-隐私-摄像头"];
            return NO;
        }
        
        //判断麦克风权限
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted){
            
                if (granted) {
                    return YES;
                }else{
                    [self showInfo:@"app需要访问您的麦克风,\n请启用麦克风-设置-隐私-麦克风"];
                    return NO;
                }
            }];
        }
        
        MB_ShowTimeViewController *showTimeVC = [[MB_ShowTimeViewController alloc]init];
        [self presentViewController:showTimeVC animated:YES completion:nil];
        return NO;

    }
    
       return YES;
}

#pragma mark 提示信息
- (void)showInfo:(NSString *)info{

    if ([self isKindOfClass:[UIViewController class]] || [self isKindOfClass:[UIView class]]) {
        [[[UIAlertView alloc]initWithTitle:@"喵播" message:info delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil] show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
