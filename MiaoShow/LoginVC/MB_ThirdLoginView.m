//
//  MB_ThirdLoginView.m
//  MiaoShow
//
//  Created by huhang on 16/9/4.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import "MB_ThirdLoginView.h"

@implementation MB_ThirdLoginView

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)setupView{

    UIImageView *sina = [self creatImageViewName:@"wbLoginicon_60x60" tag:ThirdLoginTypeSina];
    UIImageView *qq = [self creatImageViewName:@"qqloginicon_60x60" tag:ThirdLoginTypeQQ];
    UIImageView *wechat = [self creatImageViewName:@"wxloginicon_60x60" tag:ThirdLoginTypeWechat];
    
    [self addSubview:sina];
    [self addSubview:qq];
    [self addSubview:wechat];
    
    //新浪
    [sina mas_makeConstraints:^(MASConstraintMaker *make) {
        //确定了x,y
        make.center.equalTo(self);
        //确定宽,高
        make.height.and.width.mas_equalTo(60);
    }];
    
    //qq
    [qq mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sina);
        make.right.equalTo(sina.mas_left).with.offset(-20);
        make.size.equalTo(sina);
    }];
    
    [wechat mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sina);
        make.left.equalTo(sina.mas_right).with.offset(20);
        make.size.equalTo(sina);
    }];

}

- (UIImageView *)creatImageViewName:(NSString *)imageName tag:(NSInteger)tag{

    UIImageView *imageV = [[UIImageView alloc]init];
    imageV.image = [UIImage imageNamed:imageName];
    imageV.tag = tag;
    imageV.userInteractionEnabled = YES;
    [imageV addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click:)]];
    return imageV;
}

- (void)click:(UITapGestureRecognizer *)tapGes{

}

@end
