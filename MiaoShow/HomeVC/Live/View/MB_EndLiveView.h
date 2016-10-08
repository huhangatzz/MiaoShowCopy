//
//  MB_EndLiveView.h
//  MiaoShow
//
//  Created by huhang on 16/9/12.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MB_EndLiveView : UIView

/** 点击其他房间 */
@property (nonatomic,copy)void (^otherHouseBlock)();

/** 退出直播间 */
@property (nonatomic,copy)void (^quitHouseBlock)();

@end
