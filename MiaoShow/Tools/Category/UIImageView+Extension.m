//
//  UIImageView+Extension.m
//  MiaoShow
//
//  Created by huhang on 16/9/11.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import "UIImageView+Extension.h"

@implementation UIImageView (Extension)

- (void)startGifAnimation:(NSArray *)images{

    if (images.count == 0) return;
    
    //动画数组
    self.animationImages = images;

    //执行一次完整动画所需的时长
    self.animationDuration = 0.5;
    //动画重复次数,设置成0,就是无限循环
    self.animationRepeatCount = 0;
    //开始动画
    [self startAnimating];
}

- (void)stopGifAnimation{
    if (self.isAnimating) {
        [self stopAnimating];
    }
}

@end
