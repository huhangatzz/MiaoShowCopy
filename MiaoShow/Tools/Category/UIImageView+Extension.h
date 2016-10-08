//
//  UIImageView+Extension.h
//  MiaoShow
//
//  Created by huhang on 16/9/11.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Extension)

//播放gif
- (void)startGifAnimation:(NSArray *)images;
//停止动画
- (void)stopGifAnimation;

@end
