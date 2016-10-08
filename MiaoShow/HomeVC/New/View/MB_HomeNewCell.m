//
//  MB_HomeNewCell.m
//  MiaoShow
//
//  Created by huhang on 16/9/9.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import "MB_HomeNewCell.h"
#import "MB_LiveUser.h"
#import "UIImageView+WebCache.h"

@interface MB_HomeNewCell ()

@property (weak, nonatomic) IBOutlet UIButton *addressBtn;
@property (weak, nonatomic) IBOutlet UILabel *contentLb;
@property (weak, nonatomic) IBOutlet UIImageView *bigImageView;
@property (weak, nonatomic) IBOutlet UIImageView *starImageView;

@end

@implementation MB_HomeNewCell

- (void)setHomeNew:(MB_LiveUser *)homeNew{
    _homeNew = homeNew;
    
    //地址
    [self.addressBtn setTitle:homeNew.position forState:UIControlStateNormal];
    
    //是否最新
    self.starImageView.hidden = ![homeNew.isNew boolValue];
 
    //名称
    self.contentLb.text = homeNew.nickname;

    //照片
    [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:homeNew.photo] placeholderImage:[UIImage imageNamed:@"placeholder_head"]];
}

@end
