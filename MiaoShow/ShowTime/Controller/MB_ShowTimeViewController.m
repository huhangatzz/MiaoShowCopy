//
//  MB_ShowTimeViewController.m
//  MiaoShow
//
//  Created by huhang on 16/9/4.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import "MB_ShowTimeViewController.h"
#import <LFLiveKit.h>

@interface MB_ShowTimeViewController ()<LFLiveSessionDelegate>

//美颜
@property (weak, nonatomic) IBOutlet UIButton *beautifulBtn;
//连接状态
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
//直播按钮
@property (weak, nonatomic) IBOutlet UIButton *liveBtn;

/** RTMP地址 **/
@property (nonatomic,copy)NSString *rtmpUrl;
@property (nonatomic,strong)LFLiveSession *session;
@property (nonatomic,weak)UIView *livingPreView;

@end

@implementation MB_ShowTimeViewController

- (UIView *)livingPreView{

    if (!_livingPreView) {
        UIView *livingPreView = [[UIView alloc]initWithFrame:self.view.bounds];
//        livingPreView.frame = CGRectMake(0, 0, 200, 200);
        livingPreView.backgroundColor = [UIColor clearColor];
        livingPreView.clipsToBounds = YES;
        //自动调整子控件与父控件中间的位置，宽高。
//         livingPreView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view insertSubview:livingPreView atIndex:0];
//        [self.view bringSubviewToFront:livingPreView];
        _livingPreView = livingPreView;
    }
    return _livingPreView;
}

- (LFLiveSession *)session{

    if (!_session) {
        //初始化session要传入音频配置和视频配置
        //音频的默认配置为:采样率44.1,双声道
        //视频默认分辨率为360*640
        
        
        
        
//      _session = [[LFLiveSession alloc] initWithAudioConfiguration:[LFLiveAudioConfiguration defaultConfiguration] videoConfiguration:[LFLiveVideoConfiguration defaultConfigurationForQuality:LFLiveVideoQuality_Default]];
        
        
        //自己定制高质量音频128k,分辨率设置为720 * 1280 ,方向竖屏
        //直播音频配置
        LFLiveAudioConfiguration *audioConfig = [[LFLiveAudioConfiguration alloc] init];
        audioConfig.numberOfChannels = 2;
        audioConfig.audioBitrate = LFLiveAudioBitRate_128Kbps;
        audioConfig.audioSampleRate = LFLiveAudioSampleRate_44100Hz;
        
        //直播视频配置
        LFLiveVideoConfiguration *videoConfig = [[LFLiveVideoConfiguration alloc]init];
        videoConfig.videoSize = CGSizeMake(720, 1280);
        videoConfig.videoBitRate = 800*1024;
        videoConfig.videoMaxBitRate = 1000*1024;
        videoConfig.videoMinBitRate = 500*1024;
        videoConfig.videoFrameRate = 15;
        videoConfig.videoMaxKeyframeInterval = 30;
        //videoConfig.landscape = YES;
        videoConfig.sessionPreset = LFCaptureSessionPreset720x1280;
        
        _session = [[LFLiveSession alloc]initWithAudioConfiguration:audioConfig videoConfiguration:videoConfig];
        
        //设置返回的视频显示在指定的view上
        _session.preView = self.livingPreView;
        _session.delegate = self;
        _session.running = YES;
        _session.showDebugInfo = NO;
        NSLog(@"------------%@-----------", [NSValue valueWithCGRect:self.view.frame]);
    }
    return _session;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.beautifulBtn.layer.cornerRadius = self.beautifulBtn.height * 0.5;
    self.beautifulBtn.layer.masksToBounds = YES;
    
    self.liveBtn.backgroundColor = KeyColor;
    self.liveBtn.layer.cornerRadius = self.liveBtn.height * 0.5;
    self.liveBtn.layer.masksToBounds = YES;
    
    self.statusLabel.numberOfLines = 0;
    
    //默认开启后置摄像头
    self.session.captureDevicePosition = AVCaptureDevicePositionBack;
    
}

//关闭直播
- (IBAction)close:(UIButton *)sender {
    
    if (self.session.state == LFLivePending || self.session.state == LFLiveStart) {
        [self.session stopLive];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

//开启/关闭美颜相机
- (IBAction)beautifulCamera:(UIButton *)sender {
    
    //默认开启美颜功能的
    self.session.beautyFace = !self.session.beautyFace;
}

//切换前置/后置摄像头
- (IBAction)switchCamare:(UIButton *)sender {
    
    AVCaptureDevicePosition devicePositon = self.session.captureDevicePosition;
    self.session.captureDevicePosition = devicePositon == AVCaptureDevicePositionBack ? AVCaptureDevicePositionFront : AVCaptureDevicePositionBack;
    NSLog(@"切换前置/后置");
}

#pragma mark 开始直播
- (IBAction)startLiving:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    if (sender.selected) {//开始直播
       
        LFLiveStreamInfo *stream = [[LFLiveStreamInfo alloc] init];
        stream.url = @"";
        self.rtmpUrl = stream.url;
        [self.session startLive:stream];
    }else{//结束直播
        [self.session stopLive];
        self.statusLabel.text = [NSString stringWithFormat:@"状态:直播被关闭\nRTMP:%@",self.rtmpUrl];
    }
}

#pragma mark - LFLiveSessionDelegate
- (void)liveSession:(LFLiveSession *)session liveStateDidChange:(LFLiveState)state{

    NSString *tempStatus;
    switch (state) {
        case LFLiveReady:
            tempStatus = @"准备中...";
            break;
        case LFLivePending:
            tempStatus = @"连接中...";
            break;
        case LFLiveStart:
            tempStatus = @"已连接";
            break;
        case LFLiveStop:
            tempStatus = @"已断开";
            break;
        case LFLiveError:
            tempStatus = @"连接出错";
            break;
            
        default:
            break;
    }
    self.statusLabel.text = [NSString stringWithFormat:@"状态:%@\nRTMP:%@",tempStatus,self.rtmpUrl];
}

- (void)liveSession:(LFLiveSession *)session debugInfo:(LFLiveDebug *)debugInfo{
//现场调试信息回调
}

- (void)liveSession:(LFLiveSession *)session errorCode:(LFLiveSocketErrorCode)errorCode{
//回调的套接字错误代码
}

@end
