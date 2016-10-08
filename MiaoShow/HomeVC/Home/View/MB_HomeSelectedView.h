//
//  MB_HomeSelectedView.h
//  MiaoShow
//
//  Created by huhang on 16/9/5.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,HomeSelectedType){
    HomeSelectedTypeHot,//热门
    HomeSelectedTypeNew,//最新
    HomeSelectedTypeCare//关注
};

@interface MB_HomeSelectedView : UIView

@property (nonatomic,strong)NSArray *viewcontrolls;

/** 选中了 */
@property (nonatomic,copy)void (^selectedBlock)(HomeSelectedType type);

/** 下划线 */
@property (nonatomic,strong)UIView *underLine;

/** 设置滑动选中按钮 */
@property (nonatomic,assign)HomeSelectedType selectedType;

@end
