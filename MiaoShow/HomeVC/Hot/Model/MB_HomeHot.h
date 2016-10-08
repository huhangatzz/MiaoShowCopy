//
//  MB_HomeHot.h
//  MiaoShow
//
//  Created by huhang on 16/9/7.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MB_HomeHot : NSObject

#pragma mark - 轮播图
/** 轮播图url */
@property (nonatomic,copy)NSString *imageUrl;
/** 点击轮播图地址url */
@property (nonatomic,copy)NSString *link;
/** 标题 */
@property (nonatomic,copy)NSString *title;

#pragma mark - 热门数据
/** 群众数目 */
@property (nonatomic,copy)NSString *allnum;
/** 主播头像 */
@property (nonatomic,copy)NSString *smallpic;
/** 名称 */
@property (nonatomic,copy)NSString *myname;
/** 星级 */
@property (nonatomic,copy)NSString *starlevel;
/** 地址 */
@property (nonatomic,copy)NSString *gps;
/** 直播图 */
@property (nonatomic,copy)NSString *bigpic;
/** 直播流地址 */
@property (nonatomic,copy)NSString *flv;
/** 个性签名 */
@property (nonatomic,copy)NSString *signatures;
/** 用户id */
@property (nonatomic,copy)NSString *userId;
/** 直播房间号 */
@property (nonatomic,copy)NSString *roomid;
/** 所处服务器 */
@property (nonatomic,copy)NSString *serverid;
/** 用户id */
@property (nonatomic,copy)NSString *useridx;
/** 排名 */
@property (nonatomic,copy)NSString *pos;
/** 辅助视图(星星视图) */
@property (nonatomic,strong)UIImage *startImage;

@end
