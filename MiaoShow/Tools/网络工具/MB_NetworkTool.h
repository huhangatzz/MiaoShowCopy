//
//  MB_NetworkTool.h
//  MiaoShow
//
//  Created by huhang on 16/9/3.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,NetworkStates){

    NetworkStatesNone,//没有网络
    NetworkStates2G,//2G
    NetworkStates3G,//3G
    NetworkStates4G,//4G
    NetworkStatesWIFI //WIFI
};

@interface MB_NetworkTool : NSObject

+ (instancetype)defaultNetworkTool;
- (void)checkNeworkStates;
+ (NetworkStates)getNetworkStates;

@end
