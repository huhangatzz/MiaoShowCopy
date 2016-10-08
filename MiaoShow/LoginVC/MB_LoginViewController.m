//
//  MB_LoginViewController.m
//  MiaoShow
//
//  Created by huhang on 16/9/3.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import "MB_LoginViewController.h"
#import "MB_TabBarViewController.h"
#import "MB_ThirdLoginView.h"

@interface MB_LoginViewController ()

//播放器
@property (nonatomic,strong)IJKFFMoviePlayerController *player;
//第三方登录
@property (nonatomic,strong)MB_ThirdLoginView *thirdLoginView;
//快速通道
@property (nonatomic,strong)UIButton *quickBtn;
//封面图片
@property (nonatomic,strong)UIImageView *coverView;

@end

@implementation MB_LoginViewController

- (IJKFFMoviePlayerController *)player{

    if (!_player) {
       
        //随机选择视频
        NSString *path = arc4random_uniform(10) % 2 ? @"login_video" : @"loginmovie";
        //初始化播放器
        IJKFFMoviePlayerController *player = [[IJKFFMoviePlayerController alloc]initWithContentURLString:[[NSBundle mainBundle] pathForResource:path ofType:@"mp4"] withOptions:[IJKFFOptions optionsByDefault]];
        //设置frame
        player.view.frame = self.view.bounds;
        //设置填充方式
        player.scalingMode = IJKMPMovieScalingModeAspectFill;
        [self.view addSubview:player.view];
        //是否自动播放
        player.shouldAutoplay = NO;
        //准备播放
        [player prepareToPlay];
        _player = player;
    }
    return _player;
}

- (MB_ThirdLoginView *)thirdLoginView{
   
    if (!_thirdLoginView) {
        
        MB_ThirdLoginView *thirdLoginView = [[MB_ThirdLoginView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
        [thirdLoginView setClickBlock:^(ThirdLoginType type) {
            [self loginSuccess];
        }];
        
        thirdLoginView.hidden = YES;
        [self.view addSubview:thirdLoginView];
        _thirdLoginView = thirdLoginView;
    }
    return _thirdLoginView;
}

- (UIButton *)quickBtn{

    if (!_quickBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor clearColor];
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [UIColor yellowColor].CGColor;
        [btn setTitle:@"快速通道" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(loginSuccess) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        btn.hidden = YES;
        _quickBtn = btn;
    }
    return _quickBtn;
}

- (UIImageView *)coverView{

    if (!_coverView) {
        UIImageView *coverView = [[UIImageView alloc]initWithFrame:self.view.bounds];
        coverView.image = [UIImage imageNamed:@"LaunchImage"];
        [self.player.view addSubview:coverView];
        _coverView = coverView;
    }
    return _coverView;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.coverView.hidden = NO;
    
    //快速登录布局
    [self.quickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
        make.bottom.mas_equalTo(-60);
        make.height.mas_equalTo(40);
    }];
   
    //第三方登录
    [self.thirdLoginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.equalTo(self.quickBtn.mas_top).with.offset(-60);
    }];
    
    // 监听视频是否播放完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinish) name:IJKMPMoviePlayerPlaybackDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stateDidChange) name:IJKMPMoviePlayerLoadStateDidChangeNotification object:nil];
}

- (void)didFinish{

    //播放完成,继续重播
    [self.player play];
}

- (void)stateDidChange{

    if ((self.player.loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        if (!self.player.isPlaying) {
            [self.view insertSubview:self.coverView atIndex:0];
            [self.player play];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.quickBtn.hidden = NO;
                self.thirdLoginView.hidden = NO;
            });
        }
    }
}

- (void)loginSuccess{

    //提示带图片
    [self showGifInView:self.view];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //模态进入主页
        [self presentViewController:[[MB_TabBarViewController alloc]init] animated:NO completion:nil];
        [self.player stop];
        [self.player.view removeFromSuperview];
        self.player = nil;
    });
}

#pragma mark 视图将要消失
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //关机
    [self.player shutdown];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark 视图已经消失
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear: animated];
    
    //移除播放器视图
    [self.player.view removeFromSuperview];
    self.player = nil;
}

@end
