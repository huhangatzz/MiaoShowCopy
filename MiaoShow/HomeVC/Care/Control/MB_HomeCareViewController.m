//
//  MB_HomeCareViewController.m
//  MiaoShow
//
//  Created by huhang on 16/9/7.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import "MB_HomeCareViewController.h"

@interface MB_HomeCareViewController ()

@property (weak, nonatomic) IBOutlet UIButton *toSeeBtn;

@end

@implementation MB_HomeCareViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.toSeeBtn.layer.borderWidth = 1;
    self.toSeeBtn.layer.borderColor = KeyColor.CGColor;
    self.toSeeBtn.layer.cornerRadius = self.toSeeBtn.height * 0.5;
    self.toSeeBtn.layer.masksToBounds = YES;
    [self.toSeeBtn setTitleColor:KeyColor forState:UIControlStateNormal];
    
    //监听当热门视图的导航栏和tabbar都隐藏时,然后滑动下一个视图时重新添加导航栏和tabbar
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollCare) name:@"scrollCare" object:nil];
}


- (void)scrollCare{
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self setTabBarHidden:NO];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)clickBtn:(UIButton *)sender {
    //发送通知去看热门主播
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyToSeeHotWorld object:nil];
}

#pragma mark 实现滑动视图让导航栏和tabbar消失
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

//隐藏显示tabbar
- (void)setTabBarHidden:(BOOL)hidden
{
    UIView *tab = self.tabBarController.view;
    CGRect  tabRect = self.tabBarController.tabBar.frame;
    if ([tab.subviews count] < 2) {
        return;
    }
    
    UIView *view;
    if ([tab.subviews[0] isKindOfClass:[UITabBar class]]) {
        view = tab.subviews[1];
    } else {
        view = tab.subviews[0];
    }
    
    if (hidden) {
        view.frame = tab.bounds;
        tabRect.origin.y = SCREEN_HEIGHT + self.tabBarController.tabBar.height;
    } else {
        view.frame = CGRectMake(tab.bounds.origin.x, tab.bounds.origin.y, tab.bounds.size.width, tab.bounds.size.height);
        tabRect.origin.y = SCREEN_HEIGHT - self.tabBarController.tabBar.height;
    }
    
    [UIView animateWithDuration:0.5f animations:^{
        self.tabBarController.tabBar.y = tabRect.origin.y;
    }];
}

@end
