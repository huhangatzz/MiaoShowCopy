//
//  MB_SmallUserPlayerView.m
//  MiaoShow
//
//  Created by huhang on 16/9/14.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import "MB_SmallUserPlayerView.h"
#import "MB_HomeHot.h"
@interface MB_SmallUserPlayerView ()

/** 播放视图 */
@property (weak, nonatomic) IBOutlet UIView *playerView;
/** 直播播放器 */
@property (nonatomic,strong)IJKFFMoviePlayerController *moviePlayerVC;

@end

@implementation MB_SmallUserPlayerView

- (void)awakeFromNib{

    [super awakeFromNib];
    
    self.playerView.layer.cornerRadius = self.playerView.height * 0.5;
    self.playerView.layer.masksToBounds = YES;
}

- (void)setSmallLive:(MB_HomeHot *)smallLive{
    _smallLive = smallLive;
    //设置只播放视频,不播放声音
    IJKFFOptions *option = [IJKFFOptions optionsByDefault];
    [option setPlayerOptionValue:@"1" forKey:@"an"];
    //开启硬解码
    [option setPlayerOptionValue:@"1" forKey:@"videotoolbox"];
    IJKFFMoviePlayerController *moviePlayerVC = [[IJKFFMoviePlayerController alloc]initWithContentURLString:smallLive.flv withOptions:option];
    //设置大小
    moviePlayerVC.view.frame = self.playerView.bounds;
    //填充fill
    moviePlayerVC.scalingMode = IJKMPMovieScalingModeAspectFill;
    //设置自动播放
    moviePlayerVC.shouldAutoplay = YES;
    [moviePlayerVC prepareToPlay];
    [self.playerView addSubview:moviePlayerVC.view];
    self.moviePlayerVC = moviePlayerVC;
}

- (void)removeFromSuperview{

    if (_moviePlayerVC) {
        [_moviePlayerVC shutdown];
        [_moviePlayerVC.view removeFromSuperview];
        _moviePlayerVC = nil;
    }
    [super removeFromSuperview];
}

@end
