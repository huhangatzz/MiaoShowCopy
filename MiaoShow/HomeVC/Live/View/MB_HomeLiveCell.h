//
//  MB_HomeLiveCell.h
//  MiaoShow
//
//  Created by huhang on 16/9/11.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MB_HomeHot;
@interface MB_HomeLiveCell : UICollectionViewCell

/** 直播模型 */
@property (nonatomic,strong)MB_HomeHot *homeLive;
/** 相关模块 */
@property (nonatomic,strong)MB_HomeHot *relateLive;
/** 当前控制器 */
@property (nonatomic,strong)UIViewController *parentVC;
/** 点击小直播视图 */
@property (nonatomic,copy)void (^clickSmallPlayerBlock)();

@end
