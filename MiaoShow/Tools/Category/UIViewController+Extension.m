//
//  UIViewController+Extension.m
//  MiaoShow
//
//  Created by huhang on 16/9/7.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import "UIViewController+Extension.h"
#import "UIImageView+Extension.h"

static const void *gifKey = &gifKey;

@implementation UIViewController (Extension)

- (UIImageView *)gifView{
    return objc_getAssociatedObject(self, gifKey);
}

- (void)setGifView:(UIImageView *)gifView{
    objc_setAssociatedObject(self, gifKey, gifView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//显示GIF加载动画
- (void)showGifInView:(UIView *)view{

    NSArray *images = @[[UIImage imageNamed:@"hold1_60x72"], [UIImage imageNamed:@"hold2_60x72"], [UIImage imageNamed:@"hold3_60x72"]];
    UIImageView *gifView = [[UIImageView alloc]init];
    if (!view) {
        view = self.view;
    }
    [view addSubview:gifView];
    [gifView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.center.mas_offset (0);
        make.width.mas_offset(60);
        make.height.mas_offset(70);
    }];
    self.gifView = gifView;
    [gifView startGifAnimation:images];
}

//隐藏gif动画
- (void)hideGifView{

    [self.gifView stopGifAnimation];
    self.gifView = nil;
}

- (BOOL)isNotEmpty:(NSArray *)array{

    if ([array isKindOfClass:[NSArray class]] && array.count > 0) {
        return YES;
    }else{
        return NO;
    }
}

@end
