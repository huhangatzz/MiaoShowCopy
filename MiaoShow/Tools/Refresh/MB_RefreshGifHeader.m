//
//  MB_RefreshGifHeader.m
//  MiaoShow
//
//  Created by huhang on 16/9/7.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import "MB_RefreshGifHeader.h"

@implementation MB_RefreshGifHeader

- (instancetype)init{

    if (self = [super init]) {
        self.lastUpdatedTimeLabel.hidden = YES;
        self.stateLabel.hidden = YES;
        
        //普通闲置状态
        [self setImages:@[[UIImage imageNamed:@"reflesh1_60x55"], [UIImage imageNamed:@"reflesh2_60x55"], [UIImage imageNamed:@"reflesh3_60x55"]] forState:MJRefreshStateIdle];
        
        //松开就可以进行刷新的状态
        [self setImages:@[[UIImage imageNamed:@"reflesh1_60x55"], [UIImage imageNamed:@"reflesh2_60x55"], [UIImage imageNamed:@"reflesh3_60x55"]] forState:MJRefreshStatePulling];
        
        //正在刷新中...
        [self setImages:@[[UIImage imageNamed:@"reflesh1_60x55"], [UIImage imageNamed:@"reflesh2_60x55"], [UIImage imageNamed:@"reflesh3_60x55"]] forState:MJRefreshStateRefreshing];
    }
    return self;
}

@end
