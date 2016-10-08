//
//  MB_LiveUser.h
//  MiaoShow
//
//  Created by huhang on 16/9/13.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MB_LiveUser : NSObject
/** 直播流 */
@property (nonatomic,copy)NSString *flv;
/** 是否新人 */
@property (nonatomic,copy)NSString *isNew;
/** <#name#> */
@property (nonatomic,copy)NSString *nickname;
/** name */
@property (nonatomic,copy)NSString *photo;
/** name */
@property (nonatomic,copy)NSString *position;
/** <#name#> */
@property (nonatomic,copy)NSString *roomid;
/** name */
@property (nonatomic,copy)NSString *serverid;
/** name */
@property (nonatomic,copy)NSString *sex;
/** name */
@property (nonatomic,copy)NSString *starlevel;
/** name */
@property (nonatomic,copy)NSString *useridx;



@end
