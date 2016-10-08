//
//  UIViewController+ProgressHUD.h
//  MiaoShow
//
//  Created by huhang on 16/9/5.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>

@interface UIViewController (ProgressHUD)

/** HUD */
@property (nonatomic,weak,readonly)MBProgressHUD *HUD;

/**
 *  提示信息
 *
 *  @param view 显示在哪个view上
 *  @param hint 提示信息
 *  @param yoffset 提示框位置
 */
- (void)showHUDInView:(UIView *)view hint:(NSString *)hint;
- (void)showHUDInView:(UIView *)view hint:(NSString *)hint yoffset:(float)yoffset;
- (void)hideHUD;

/**
 *  提示信息
 *
 *  @param hint 提示词
 */
- (void)showHint:(NSString *)hint;
- (void)showHint:(NSString *)hint inView:(UIView *)view;
- (void)showHint:(NSString *)hint yoffset:(float)yoffset;

//添加图片+文字
- (void)showHint:(NSString *)hint inView:(UIView *)view iconName:(NSString *)iconName;
//添加图片
- (void)showInView:(UIView *)view iconName:(NSString *)iconName;

@end
