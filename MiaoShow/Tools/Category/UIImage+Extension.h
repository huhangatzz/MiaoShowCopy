//
//  UIImageView+Extension.h
//  MiaoShow
//
//  Created by huhang on 16/9/8.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

/**
 *  给图片添加蒙版
 *
 *  @param image 图片
 *  @param blur  模糊度
 *
 *  @return 返回image
 */
+ (UIImage *)blurImage:(UIImage *)image blur:(CGFloat)blur;

/**
 *  根据颜色生成一张图片
 *
 *  @param color 颜色
 *  @param size  图片大小
 *
 *  @return 返回图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 *  生成圆角图片
 *
 *  @param originImage 原始图片
 *  @param borderColor 边框颜色
 *  @param borderWidth 边框宽度
 *
 *  @return 圆形图片
 */
+ (UIImage *)circleImage:(UIImage *)originImage borderColor:(UIColor *)borderColor bordWidth:(CGFloat)borderWidth;


@end
