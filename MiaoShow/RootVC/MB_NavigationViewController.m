//
//  NavigationViewController.m
//  tabBar
//
//  Created by makepolo-ios on 15/7/10.
//  Copyright (c) 2015年 huhang. All rights reserved.
//

#import "MB_NavigationViewController.h"

@interface MB_NavigationViewController ()

@end

@implementation MB_NavigationViewController

+ (void)initialize{

    NSDictionary *titles = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    UINavigationBar * bar = [UINavigationBar appearance];
    [bar setBackgroundImage:[UIImage imageNamed:@"navBar_bg_414x70"] forBarMetrics:UIBarMetricsDefault];
    
    [bar setTitleTextAttributes:titles];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{

    if (self.childViewControllers.count) {
        
        viewController.hidesBottomBarWhenPushed = YES;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"back_9x16"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [btn sizeToFit];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
        
        //如果自定义返回按钮后,滑动返回会消失,需要添加代码
        __weak typeof (viewController) weakSelf = self;
        self.interactivePopGestureRecognizer.delegate = (id)weakSelf;
    }

    [super pushViewController:viewController animated:animated];
}

- (void)back{

    //判断两种情况:push和present
    if ((self.presentedViewController || self.presentingViewController) && self.childViewControllers.count == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self popViewControllerAnimated:YES];
    }
}

@end
