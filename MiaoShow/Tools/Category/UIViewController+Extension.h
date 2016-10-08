//
//  UIViewController+Extension.h
//  MiaoShow
//
//  Created by huhang on 16/9/7.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Extension)

/** Gif加载状态 */
@property (nonatomic,weak)UIImageView *gifView;

/**
 *  显示GIF加载动画
 *
 *  @param view 显示在哪个view上
 */
- (void)showGifInView:(UIView *)view;

/**
 *  隐藏GIF加载动画
 */
- (void)hideGifView;

/**
 *  判断数组是否为空
 *
 *  @param array 数组
 *
 *  @return yes or no
 */
- (BOOL)isNotEmpty:(NSArray *)array;


@end
