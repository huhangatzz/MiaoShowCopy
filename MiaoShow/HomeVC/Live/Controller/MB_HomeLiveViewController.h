//
//  MB_HomeLiveViewController.h
//  MiaoShow
//
//  Created by huhang on 16/9/11.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MB_HomeLiveViewController : MB_BaseViewController

/** 数组 */
@property (nonatomic,strong)NSArray *homeLives;
/* 当前的index */
@property (nonatomic,assign)NSInteger currentIndex;

@end
