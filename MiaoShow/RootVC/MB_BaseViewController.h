//
//  MP_BaseViewController.h
//  mp_business
//
//  Created by pengkaichang on 14-10-8.
//  Copyright (c) 2014年 com.soudoushi.makepolo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import <AFNetworking.h>

@interface MB_BaseViewController : UIViewController <MBProgressHUDDelegate>

@property (nonatomic, strong) MBProgressHUD *progressHud;
@property (nonatomic,strong)NSURLSessionDataTask *task;


@end
