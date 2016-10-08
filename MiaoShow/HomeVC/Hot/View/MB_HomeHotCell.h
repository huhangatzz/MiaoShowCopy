//
//  MB_HomeHotCell.h
//  MiaoShow
//
//  Created by huhang on 16/9/8.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MB_HomeHot;
@interface MB_HomeHotCell : UITableViewCell

+ (instancetype)homeHotCellWithTableView:(UITableView *)tableView;

/** 热门数据模型 */
@property (nonatomic,strong)MB_HomeHot *hot;

@end
