//
//  MB_HomeLiveCell.m
//  MiaoShow
//
//  Created by huhang on 16/9/11.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import "MB_HomeLiveCell.h"
#import "UIImage+Extension.h"
#import <SDWebImageDownloader.h>
#import "MB_HomeHot.h"
#import "MB_EndLiveView.h"
#import "MB_UserLiveInfoView.h"
#import "MB_SmallUserPlayerView.h"
#import "MB_BottomToolView.h"
#import "NSSafeObject.h"
#import <BarrageRenderer.h>

@interface MB_HomeLiveCell ()

/** 直播前的占位图 */
@property (nonatomic,strong)UIImageView *placeHolderView;
/** 相关主播 */
@property (nonatomic,strong)UIButton *otherView;
/** 直播播放器 */
@property (nonatomic,strong)IJKFFMoviePlayerController *livePlayer;
/** 顶部主播信息视图 */
@property (nonatomic,strong)MB_UserLiveInfoView *userLiveInfoView;
/** 直播结束视图 */
@property (nonatomic,strong)MB_EndLiveView *endLiveView;
/** 小直播播放视图 */
@property (nonatomic,strong)MB_SmallUserPlayerView *smallPlayerView;
/** 粒子动画 */
@property (nonatomic,strong)CAEmitterLayer *emitterLayer;
/** 底部视图 */
@property (nonatomic,strong)MB_BottomToolView *bottomToolView;

/** 弹幕 */
@property (nonatomic,strong)BarrageRenderer *renderer;
/** 定时器 */
@property (nonatomic,strong)NSTimer *timer;

@end


@implementation MB_HomeLiveCell

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        self.bottomToolView.hidden = NO;
        //创建弹幕
        [self setupBarrageView];
    }
    return self;
}

#pragma mark - 弹幕
- (BarrageRenderer *)renderer{
    
    if (!_renderer) {
        BarrageRenderer *barrage = [[BarrageRenderer alloc]init];
        barrage.canvasMargin = UIEdgeInsetsMake(SCREEN_HEIGHT * 0.3 , 10, 10, 10);
        [self.contentView addSubview:barrage.view];
        _renderer = barrage;
    }
    return _renderer;
}

#pragma mark - 占位图
- (UIImageView *)placeHolderView{

    if (!_placeHolderView) {
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"profile_user_414x414"]];
        imageView.frame = self.contentView.bounds;
        [self.contentView addSubview:imageView];
        //展示动态图片
        [self.parentVC showGifInView:imageView];
        _placeHolderView = imageView;
        
        //强制布局
        [_placeHolderView layoutIfNeeded];
    }
    return _placeHolderView;
}

#pragma mark - 顶部用户信息视图
- (MB_UserLiveInfoView *)userLiveInfoView{

    if (!_userLiveInfoView) {
        MB_UserLiveInfoView *userLiveInfoView = [MB_UserLiveInfoView viewFromXib];
        [self.contentView insertSubview:userLiveInfoView aboveSubview:self.placeHolderView];
        [userLiveInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(120);
        }];
        _userLiveInfoView = userLiveInfoView;
    }
    return _userLiveInfoView;
}

#pragma mark - 展示相关主播
- (UIButton *)otherView{

    if (!_otherView) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"private_icon_70x70"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickOtherView) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView insertSubview:button aboveSubview:self.placeHolderView];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(-20);
            make.top.mas_equalTo(180);
            make.width.and.height.mas_offset(70);
        }];
        _otherView = button;
    }
    return _otherView;
}

- (void)clickOtherView{
    //相关主播模块
    NSLog(@"相关主播模块");
}

#pragma mark - 设置相关主播
- (void)setRelateLive:(MB_HomeHot *)relateLive{

    _relateLive = relateLive;
    if (relateLive) {
        self.smallPlayerView.smallLive = relateLive;
    }else{
        self.smallPlayerView.hidden = YES;
    }
}

#pragma mark - 小直播播放视图
- (MB_SmallUserPlayerView *)smallPlayerView{

    if (!_smallPlayerView) {
        MB_SmallUserPlayerView *smallPlayerView = [MB_SmallUserPlayerView viewFromXib];
        [self.contentView insertSubview:smallPlayerView aboveSubview:self.placeHolderView];
        [smallPlayerView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickSmallPlayerView)]];
        [smallPlayerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20);
            make.centerY.equalTo(self.livePlayer.view);
            make.width.height.mas_equalTo(98);
        }];
        _smallPlayerView = smallPlayerView;
    }
    return _smallPlayerView;
}
//点击了小直播视图
- (void)clickSmallPlayerView{

    if (self.clickSmallPlayerBlock) {
        self.clickSmallPlayerBlock();
    }
}

#pragma mark - 粒子动画
- (CAEmitterLayer *)emitterLayer{

    if (!_emitterLayer) {
        CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];
        //设置发射器在xy平面的中心位置
        emitterLayer.emitterPosition = CGPointMake(SCREEN_WIDTH - 50, SCREEN_HEIGHT - 50);
        //发射器尺寸大小
        emitterLayer.emitterSize = CGSizeMake(20, 30);
        //渲染模式
        emitterLayer.renderMode = kCAEmitterLayerUnordered;
        //是否开启三维效果
        //emitterLayer.preservesDepth = YES;
        
        NSMutableArray *array = [NSMutableArray array];
        //创建粒子
        for (int i = 0; i < 10; i++) {
            //发射单元
            CAEmitterCell *stepCell = [CAEmitterCell emitterCell];
            //粒子的创建速率,默认为1/s
            stepCell.birthRate = 1;
            //粒子存活时间
            stepCell.lifetime = arc4random_uniform(4) + 1;
            //粒子的生存时间容差
            stepCell.lifetimeRange = 1.5;
            //颜色
            //stepCell.color = [UIColor colorWithRed:0.8 green:0.4 blue:0.2 alpha:0.1].CGColor;
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"good%d_30x30", i]];
            //粒子显示的内容
            stepCell.contents = (__bridge id _Nullable)([image CGImage]);
            //粒子的名字
            NSString *name = [NSString stringWithFormat:@"step%d",i];
            [stepCell setName:name];
            //粒子运动速度
            stepCell.velocity = arc4random_uniform(100) + 100;
            //粒子速度的容差
            stepCell.velocityRange = 80;
            //粒子在xy平面的发射角度
            stepCell.emissionLongitude = M_PI + M_PI_2;
            //粒子发射角度的容差
            stepCell.emissionRange = M_PI_2 / 6;
            //缩放比例
            stepCell.scale = 0.3;
            [array addObject:stepCell];
        }
        emitterLayer.emitterCells = array;
        [self.livePlayer.view.layer insertSublayer:emitterLayer below:self.smallPlayerView.layer];
        _emitterLayer = emitterLayer;
    }
    return _emitterLayer;
}

#pragma mark - 底部视图
bool _isSelected = NO;
- (MB_BottomToolView *)bottomToolView{

    if (!_bottomToolView) {
        MB_BottomToolView *bottomToolView = [[MB_BottomToolView alloc]init];
        [bottomToolView setClickToolBlock:^(LiveToolType type) {
            switch (type) {
                case LiveToolTypePublicTalk:
                    _isSelected = !_isSelected;
                    _isSelected ? [self.renderer start] : [self.renderer stop];
                    break;
                    break;
                case LiveToolTypePrivateTalk:
                    
                    break;
                case LiveToolTypeGift:
                    
                    break;
                case LiveToolTypeRank:
                    
                    break;
                case LiveToolTypeShare:
                    
                    break;
                case LiveToolTypeClose:
                    [self quitLive];
                    break;
                default:
                    break;
            }
        }];
        [self.contentView insertSubview:bottomToolView aboveSubview:self.placeHolderView];
        [bottomToolView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-10);
            make.height.mas_equalTo(40);
        }];
        _bottomToolView = bottomToolView;
    }
    return _bottomToolView;
}

#pragma mark - 播放结束后展示的视图
- (MB_EndLiveView *)endLiveView{

    if (!_endLiveView) {
        MB_EndLiveView *endLiveView = [MB_EndLiveView viewFromXib];
        [self.contentView addSubview:endLiveView];
        [endLiveView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_offset(0);
        }];
        //点击其他房间
        [endLiveView setOtherHouseBlock:^{
            
        }];
        //点击关闭直播间
        [endLiveView setQuitHouseBlock:^{
            [self quitLive];
        }];
        _endLiveView = endLiveView;
    }

    return _endLiveView;
}

#pragma mark - 退出直播间
- (void)quitLive{

    //退出小直播间
    if (_smallPlayerView) {
        [self stopSmallLivePlayer];
    }
    
    //退出直播间
    if (self.livePlayer) {
        [self stopLivePlayer];
    }
    
    //退出弹幕
    if (_renderer) {
        [self stopBarrageView];
    }
    
    //关闭控制器
    [self.parentVC dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 直播模块
- (void)setHomeLive:(MB_HomeHot *)homeLive{
    
    _homeLive = homeLive;
    self.userLiveInfoView.userLive = homeLive;
    [self playFLV:homeLive.flv placeHolderUrl:homeLive.bigpic];

}

- (void)playFLV:(NSString *)flv placeHolderUrl:(NSString *)placeHolderUrl{

    if (_livePlayer) {
        if (_livePlayer) {
            //让占位视图显示到直播控制器上
            [self.contentView insertSubview:self.placeHolderView aboveSubview:_livePlayer.view];
        }
        //移除小直播播放器
        if (_smallPlayerView) {
            [self stopSmallLivePlayer];
        }
        //停止直播控制器
        [self stopLivePlayer];
    }
    
    //如果切换主播,取消之前的动画
    if (_emitterLayer) {
        //停止粒子动画
        [self stopEmitterLayer];
    }
    
   //加载占位图片
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:placeHolderUrl] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        //需要添加到主线程中去更新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            self.placeHolderView.image = [UIImage blurImage:image blur:0.8];
        });
    }];
    
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    [options setPlayerOptionIntValue:1 forKey:@"videotoolbolx"];
    
    //帧速率(fps) (可以改,确认非标准帧率会导致音画不同步,所以只能设定为15或者29.97)
    [options setPlayerOptionIntValue:29.97 forKey:@"r"];
    //vol - 设置音量大小,256为标准音量 (要设置成两倍音量时输入512,依次类推)
    [options setPlayerOptionIntValue:512 forKey:@"vol"];
    
    IJKFFMoviePlayerController *livePlayer = [[IJKFFMoviePlayerController alloc]initWithContentURL:[NSURL URLWithString:flv] withOptions:options];
    //直播控制器视图
    livePlayer.view.frame = self.contentView.bounds;
    //填充fill
    livePlayer.scalingMode = IJKMPMovieScalingModeAspectFill;
    //设置自动播放(必须设置为NO,防止自动播放,才能控制好播放状态)
    livePlayer.shouldAutoplay = NO;
    //默认不显示
    livePlayer.shouldShowHudView = NO;
    
    [self.contentView insertSubview:livePlayer.view atIndex:0];
    
    //准备播放
    [livePlayer prepareToPlay];
    self.livePlayer = livePlayer;
    
    //显示相关主播
    [livePlayer.view bringSubviewToFront:self.otherView];
    
   //设置监听
    [self initObserver];
    
    //开始来访动画
    [self.emitterLayer setHidden:NO];
}

- (void)initObserver{

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stateDidChange) name:IJKMPMoviePlayerLoadStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinish) name:IJKMPMoviePlayerPlaybackDidFinishNotification object:nil];
}

- (void)stateDidChange{
    
    if ((self.livePlayer.loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        
        if (!self.livePlayer.isPlaying) {
            [self.livePlayer play];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
                if (self.placeHolderView) {
                    [self.placeHolderView removeFromSuperview];
                    self.placeHolderView = nil;
                    //将弹幕添加直播上
                    [self.livePlayer.view addSubview:self.renderer.view];
                }
                [self.parentVC hideGifView];
            });
            
        }else{
        
            //如果是网络状态不好,断开后恢复,也需要去掉加载
            if (self.parentVC.gifView.isAnimating) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.parentVC hideGifView];
                });
            }
        }
        
    }else if (self.livePlayer.loadState & IJKMPMovieLoadStateStalled){
    //网速不佳,自动暂停状态
        [self.parentVC hideGifView];
    }
}

- (void)didFinish{

    //因为网速或者其他原因导致直播stop了,也要显示gif
    if (self.livePlayer.loadState & IJKMPMovieLoadStateStalled & !self.parentVC.gifView) {
        [self.parentVC showGifInView:self.livePlayer.view];
    }
    
    //1、重新获取直播地址，服务端控制是否有地址返回。2、用户http请求该地址，若请求成功表示直播未结束，否则结束
    [HttpTool getUserLiveUrl:self.homeLive.flv success:nil failure:^(NSError *error) {
        //如果请求失败,关闭直播播放器
        [self stopLivePlayer];
         self.endLiveView.hidden = NO;
    }];
}

#pragma mark - 弹幕
- (void)setupBarrageView{
    
    self.renderer.view.hidden = NO;
    NSSafeObject *safeObj = [[NSSafeObject alloc]initWithObjct:self withSelector:@selector(autoSendBarrage)];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:safeObj selector:@selector(excute) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)autoSendBarrage{
    
    NSInteger spriteNumber = [self.renderer spritesNumberWithName:nil];
    if (spriteNumber <= 50) {
        //从左到右
        [self.renderer receive:[self walkTextSpriteDescriptorWithDirection:BarrageWalkDirectionR2L]];
    }
    
}
#pragma mark - 弹幕描述符生产方法

long _index = 0;
/// 生成精灵描述 - 过场文字弹幕
- (BarrageDescriptor *)walkTextSpriteDescriptorWithDirection:(NSInteger)direction
{
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    descriptor.spriteName = NSStringFromClass([BarrageWalkTextSprite class]);
    descriptor.params[@"text"] = self.danMuText[arc4random_uniform((uint32_t)self.danMuText.count)];
    descriptor.params[@"textColor"] = Color(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256));
    descriptor.params[@"speed"] = @(100 * (double)random()/RAND_MAX+50);
    descriptor.params[@"direction"] = @(direction);
    descriptor.params[@"clickAction"] = ^{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"弹幕被点击" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alertView show];
    };
    return descriptor;
}

- (NSArray *)danMuText
{
    return [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"danmu.plist" ofType:nil]];
}

- (void)stopLivePlayer{
    [self.livePlayer shutdown];
    [self.livePlayer.view removeFromSuperview];
    self.livePlayer = nil;
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)stopSmallLivePlayer{
    [self.smallPlayerView removeFromSuperview];
    self.smallPlayerView = nil;
}

- (void)stopEmitterLayer{
    [self.emitterLayer removeFromSuperlayer];
    self.emitterLayer = nil;
}

- (void)stopBarrageView{

    [self.renderer stop];
    [self.renderer.view removeFromSuperview];
    self.renderer = nil;
}

@end
