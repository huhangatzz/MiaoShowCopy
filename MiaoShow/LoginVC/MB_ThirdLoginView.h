//
//  MB_ThirdLoginView.h
//  MiaoShow
//
//  Created by huhang on 16/9/4.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ThirdLoginType){

    ThirdLoginTypeSina,//新浪
    ThirdLoginTypeQQ,//QQ
    ThirdLoginTypeWechat//微信
};

@interface MB_ThirdLoginView : UIView

@property (nonatomic,copy)void(^clickBlock)(ThirdLoginType type);

@end
