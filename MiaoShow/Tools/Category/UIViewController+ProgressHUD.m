//
//  UIViewController+ProgressHUD.m
//  MiaoShow
//
//  Created by huhang on 16/9/5.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import "UIViewController+ProgressHUD.h"

static const void *HUDKey = &HUDKey;

@implementation UIViewController (ProgressHUD)

#pragma mark - 动态绑定HUD属性
- (void)setHUD:(MBProgressHUD *)HUD{
    objc_setAssociatedObject(self, HUDKey, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (MBProgressHUD *)HUD{
    return objc_getAssociatedObject(self, HUDKey);
}

#pragma mark - 方法实现
- (void)showHUDInView:(UIView *)view hint:(NSString *)hint{

    MBProgressHUD *HUD = [[MBProgressHUD alloc]initWithView:view];
    HUD.labelText = hint;
    [view addSubview:HUD];
    [HUD show:YES];
    [self setHUD:HUD];
}

- (void)showHUDInView:(UIView *)view hint:(NSString *)hint yoffset:(float)yoffset{

    MBProgressHUD *HUD = [[MBProgressHUD alloc]initWithView:view];
    HUD.labelText = hint;
    HUD.margin = 10.f;
    HUD.yOffset += yoffset;
    [view addSubview:HUD];
    [HUD show:YES];
    [self setHUD:HUD];
}

- (void)showHint:(NSString *)hint{

    //显示在window上
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeText;
    hud.labelText = hint;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}

- (void)showHint:(NSString *)hint inView:(UIView *)view{

    //指定显示在哪个view上
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    [view addSubview:hud];
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeText;
    hud.labelText = hint;
    hud.margin = 10.f;
    //隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    [hud show:YES];
    //2秒之后再消失
    [hud hide:YES afterDelay:2];
}

- (void)showHint:(NSString *)hint yoffset:(float)yoffset{

    //显示在window上
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeText;
    hud.labelText = hint;
    hud.margin = 10.f;
    hud.yOffset += yoffset;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}

- (void)showHint:(NSString *)hint inView:(UIView *)view iconName:(NSString *)iconName{

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = hint;
    hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:iconName]];
    //设置模式
    hud.mode = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}

- (void)showInView:(UIView *)view iconName:(NSString *)iconName{

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:iconName]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}

- (void)hideHUD{
    [[self HUD] hide:YES];
}

@end
