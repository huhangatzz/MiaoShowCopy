//
//  MB_NetworkTool.m
//  MiaoShow
//
//  Created by huhang on 16/9/3.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import "MB_NetworkTool.h"
#import "Reachability.h"

@implementation MB_NetworkTool
{
    NetworkStates _preStatus;
    Reachability *_reachity;
}

+ (instancetype)defaultNetworkTool{

    static MB_NetworkTool *networkTool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networkTool = [[MB_NetworkTool alloc]init];
    });
    return networkTool;
}


#pragma mark - 实时监控网络
- (void)checkNeworkStates{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNetworkStates) name:kReachabilityChangedNotification object:nil];
    _reachity =[Reachability reachabilityWithHostName:@"http://www.baidu.com"];
    [_reachity startNotifier];
}

- (void)showNetworkStates{
    
    NSString *tips;
    NetworkStates currentStates = [MB_NetworkTool getNetworkStates];
    if (currentStates == _preStatus) return;
    _preStatus = currentStates;
    switch (currentStates) {
        case NetworkStatesNone:
            tips = @"当前无网络,请检测您的网络状态";
            break;
        case NetworkStates2G:
            tips = @"切换到了2G网络";
            break;
        case NetworkStates3G:
            tips = @"切换到了3G网络";
            break;
        case NetworkStates4G:
            tips = @"切换到了4G网络";
            break;
        case NetworkStatesWIFI:
            tips = nil;
            break;
            
        default:
            break;
    }
    
    if (tips.length > 0 ) {
        [[[UIAlertView alloc] initWithTitle:@"喵播" message:tips delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil] show];
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (NetworkStates)getNetworkStates{
 
    NSArray *subviews = [[[[UIApplication sharedApplication] valueForKey:@"statusBar"]valueForKey:@"foregroundView"] subviews];
    NetworkStates states = NetworkStatesNone;
    for (id child in subviews) {
       
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            
            //获取到状态码
            int networkType = [[child valueForKey:@"dataNetworkType"] intValue];
            
            switch (networkType) {
                case 0:
                    states = NetworkStatesNone;
                    break;
                case 1:
                    states = NetworkStates2G;
                    break;
                case 2:
                    states = NetworkStates3G;
                    break;
                case 3:
                    states = NetworkStates4G;
                    break;
                case 5:
                    states = NetworkStatesWIFI;
                    break;
                    
                default:
                    break;
            }
            
        }
        
        
    }
    return states;
}

@end
