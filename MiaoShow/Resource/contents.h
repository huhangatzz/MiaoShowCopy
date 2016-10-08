//
//  contents.h
//  MiaoShow
//
//  Created by huhang on 16/9/3.
//  Copyright © 2016年 huhang. All rights reserved.
//

#ifndef contents_h
#define contents_h

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define Font(fontSize) [UIFont systemFontOfSize:fontSize]

//防止图片变形
#define SCREEN_WIDTH_SCALE [UIScreen mainScreen].bounds.size.width/320.0
#define SCREEN_HEIGHT_SCALE ([UIScreen mainScreen].bounds.size.height-64)/(568.0-64)

//提示词
#define NET_NETWORK_CONTECTION         @"网络中断,请连接网络"
#define HUD_LOADING_TIPS               @"加载中..."

// 首页的选择器的宽度
#define Home_Seleted_Item_W 60
#define DefaultMargin       10

#pragma mark - 颜色
// 颜色相关
#define Color(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define KeyColor Color(216, 41, 116)
//背景色
#define DEFAULT_BACKGROUND_COLOR       @"#f8f8f8"

#pragma mark - 通知
//当前没有关注的主播,去热门主播
#define kNotifyToSeeHotWorld @"kNotifyToSeeHotWorld"

//点击了用户
#define kNotifyClickUser @"kNotifyClickUser"



#endif /* contents_h */
