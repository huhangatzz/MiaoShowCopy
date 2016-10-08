//
//  MB_HotNameBtn.m
//  MiaoShow
//
//  Created by huhang on 16/9/9.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import "MB_HotNameBtn.h"

@implementation MB_HotNameBtn

- (void)layoutSubviews{

    [super layoutSubviews];

    if (!self.currentImage) {//没有图片
        self.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }else{
        CGFloat labelW = self.titleLabel.frame.size.width;
        CGFloat imageW = self.imageView.frame.size.width;
        self.imageEdgeInsets = UIEdgeInsetsMake(0, labelW + 5, 0, -labelW);
        self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageW, 0, imageW);
    }
}

@end
