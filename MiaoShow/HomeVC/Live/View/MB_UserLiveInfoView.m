//
//  MB_UserLiveInfoView.m
//  MiaoShow
//
//  Created by huhang on 16/9/13.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import "MB_UserLiveInfoView.h"
#import "UIImage+Extension.h"
#import "UIImageView+WebCache.h"
#import <SDWebImageDownloader.h>
#import "MB_HomeHot.h"
#import "MB_LiveUser.h"

@interface MB_UserLiveInfoView ()

/** 用户信息背景视图 */
@property (weak, nonatomic) IBOutlet UIView *userBackgroundView;
/** 用户头像 */
@property (weak, nonatomic) IBOutlet UIImageView *userIconImageView;
/** 用户昵称 */
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
/** 观看人数 */
@property (weak, nonatomic) IBOutlet UILabel *seeNumberLabel;
/** 关注按钮 */
@property (weak, nonatomic) IBOutlet UIButton *careBtn;
/** 观看人数滑动视图 */
@property (weak, nonatomic) IBOutlet UIScrollView *seeScrollView;
/** 猫粮 */
@property (weak, nonatomic) IBOutlet UIButton *catFoodBtn;
/** 喵播号 */
@property (weak, nonatomic) IBOutlet UILabel *catIdLabel;

/* 猫粮数 */
@property (nonatomic,assign)NSInteger catInt;
/* 娃娃数 */
@property (nonatomic,assign)NSInteger girlInt;
/** 定时器 */
@property (nonatomic,strong)NSTimer *timer;
/** 朝阳群众数组 */
@property (nonatomic,strong)NSArray *chaoYangUsers;


@end

@implementation MB_UserLiveInfoView

#pragma mark - 朝阳群众
- (NSArray *)chaoYangUsers{

    if (!_chaoYangUsers) {
        NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"user.plist" ofType:nil]];
        _chaoYangUsers =  [MB_LiveUser mj_objectArrayWithKeyValuesArray:array];
    }
    return _chaoYangUsers;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self makeViewToBounds:self.userBackgroundView];
    [self makeViewToBounds:self.userIconImageView];
    [self makeViewToBounds:self.catFoodBtn];
    [self makeViewToBounds:self.careBtn];
    
    self.userIconImageView.layer.borderWidth = 1;
    self.userIconImageView.layer.borderColor = [UIColor redColor].CGColor;
    
    //设置关注按钮
    [self.careBtn setBackgroundImage:[UIImage imageWithColor:KeyColor size:self.careBtn.size] forState:UIControlStateNormal];
    [self.careBtn setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor] size:self.careBtn.size] forState:UIControlStateSelected];
    
    self.userIconImageView.userInteractionEnabled = YES;
    [self.userIconImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickUserIconImage:)]];
    
    //添加朝阳群众
    [self setupChangyangUsers];
}

- (void)makeViewToBounds:(UIView *)view{

    view.layer.cornerRadius = view.height * 0.5;
    view.layer.masksToBounds = YES;
    if (view == self.userBackgroundView || view == self.catFoodBtn) {
        view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    }
}

#pragma mark - 朝阳群众用户
- (void)setupChangyangUsers{

    self.seeScrollView.contentSize = CGSizeMake(self.seeScrollView.height * self.chaoYangUsers.count + 10, 0);
    CGFloat width = self.seeScrollView.height - DefaultMargin;
    CGFloat x = 0;
    for (int i = 0; i < self.chaoYangUsers.count; i ++) {
        
        x = 10 + (width + DefaultMargin) * i;
        UIImageView *userView = [[UIImageView alloc]initWithFrame:CGRectMake(x, 5, width, width)];
        userView.layer.cornerRadius = width * 0.5;
        userView.layer.masksToBounds = YES;
        MB_LiveUser *liveUser = self.chaoYangUsers[i];
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:liveUser.photo] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
           dispatch_async(dispatch_get_main_queue(), ^{
               userView.image = [UIImage circleImage:image borderColor:[UIColor whiteColor] bordWidth:1];
           });
            
        }];
        userView.userInteractionEnabled = YES;
        [userView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickUserIconImage:)]];
        userView.tag = i;
        [self.seeScrollView addSubview:userView];
    }
}

- (void)setUserLive:(MB_HomeHot *)userLive{

    _userLive = userLive;
    
    //头像
    [self.userIconImageView sd_setImageWithURL:[NSURL URLWithString:userLive.smallpic] placeholderImage:[UIImage imageNamed:@"placeholder_head"]];
    //昵称
    self.userNameLabel.text = userLive.myname;
    //观看人数
    self.seeNumberLabel.text = [NSString stringWithFormat:@"%@人",userLive.allnum];
    //猫粮
    self.catInt = arc4random_uniform(10000);
    self.girlInt = arc4random_uniform(10000);
    [self.catFoodBtn setTitle:[NSString stringWithFormat:@"猫粮:%ld  娃娃:%ld",_catInt,_girlInt] forState:UIControlStateNormal];
    
    //喵播号
    self.catIdLabel.text = [NSString stringWithFormat:@"喵播号:%@",userLive.roomid];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateNum) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

#pragma mark - 点击主播头像
- (void)clickUserIconImage:(UIGestureRecognizer *)tap{

    if (tap.view == self.userIconImageView) {
        MB_LiveUser *user = [[MB_LiveUser alloc]init];
        user.nickname = self.userLive.myname;
        user.photo = self.userLive.bigpic;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyClickUser object:nil userInfo:@{@"user":user}];
    }else{
        //点击了朝阳群众
     [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyClickUser object:nil userInfo:@{@"user":self.chaoYangUsers[tap.view.tag]}];
    }

}

- (void)updateNum{

    self.catInt += arc4random_uniform(5);
    self.girlInt += arc4random_uniform(5);
    NSInteger userInt = [self.userLive.allnum integerValue] + self.catInt;
    self.seeNumberLabel.text = [NSString stringWithFormat:@"%ld人",userInt];
    [self.catFoodBtn setTitle:[NSString stringWithFormat:@"猫粮:%ld  娃娃:%ld",_catInt,_girlInt] forState:UIControlStateNormal];
}

- (IBAction)careClickAction:(UIButton *)sender {
    sender.selected = !sender.selected;
}

@end
