//
//  MB_HomeHotCell.m
//  MiaoShow
//
//  Created by huhang on 16/9/8.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import "MB_HomeHotCell.h"
#import "UIImage+Extension.h"
#import "UIImageView+WebCache.h"
#import "MB_HomeHot.h"
#import "MB_HotNameBtn.h"

static NSString *hotCell = @"hotCell";

@interface MB_HomeHotCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet MB_HotNameBtn *myNameBtn;

@property (weak, nonatomic) IBOutlet UIButton *addressBtn;
@property (weak, nonatomic) IBOutlet UILabel *peopleNumberLb;
@property (weak, nonatomic) IBOutlet UIImageView *bigImageView;
@property (weak, nonatomic) IBOutlet UIView *bigBackgroundView;

@end

@implementation MB_HomeHotCell

+ (instancetype)homeHotCellWithTableView:(UITableView *)tableView{

    MB_HomeHotCell *cell = [tableView dequeueReusableCellWithIdentifier:hotCell];
    if (!cell) {
        cell = [[MB_HomeHotCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hotCell];
    }
    return cell;
}

- (void)setHot:(MB_HomeHot *)hot{
    _hot = hot;
    
    //头像
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:hot.smallpic] placeholderImage:[UIImage imageNamed:@"placeholder_head"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
       
        //给图片设置圆角
        image = [UIImage circleImage:image borderColor:[UIColor redColor] bordWidth:1];
        self.iconImageView.image = image;

    }];
    
    //昵称
    [self.myNameBtn setTitle:hot.myname forState:UIControlStateNormal];
    [self.myNameBtn setImage:hot.startImage forState:UIControlStateNormal];
    
    //地址
    if (hot.gps.length > 0) {
      [self.addressBtn setTitle:hot.gps forState:UIControlStateNormal];
    }else{
      [self.addressBtn setTitle:@"来自喵星" forState:UIControlStateNormal];
    }
    
    //观看人数
    if (hot.allnum.length > 0) {
        NSString *numStr = [NSString stringWithFormat:@"%@人在观看",hot.allnum];
        NSMutableAttributedString *attributStr = [[NSMutableAttributedString alloc]initWithString:numStr];
        [attributStr addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(0, numStr.length - 4)];
        [self.peopleNumberLb setAttributedText:attributStr];
    }
    
    //背景图
    [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:hot.bigpic] placeholderImage:[UIImage imageNamed:@"profile_user_375x375"]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
   
    self.bigBackgroundView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.2];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
