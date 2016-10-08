//
//  MB_EndLiveView.m
//  MiaoShow
//
//  Created by huhang on 16/9/12.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import "MB_EndLiveView.h"

@interface MB_EndLiveView ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *peopleNumLabel;

@property (weak, nonatomic) IBOutlet UIButton *careBtn;
@property (weak, nonatomic) IBOutlet UIButton *otherHouseBtn;

@property (weak, nonatomic) IBOutlet UIButton *quitBtn;
@end

@implementation MB_EndLiveView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self makeRadius:self.careBtn];
    [self makeRadius:self.otherHouseBtn];
    [self makeRadius:self.quitBtn];
}

- (void)makeRadius:(UIButton *)btn{

    btn.layer.cornerRadius = btn.height * 0.5;
    btn.layer.masksToBounds = YES;
    if (btn != self.careBtn) {
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = KeyColor.CGColor;
    }
}

//关注
- (IBAction)clickCareBtnAction:(UIButton *)sender {
    [sender setTitle:@"关注成功" forState:UIControlStateNormal];
}

//查看其他主播
- (IBAction)otherHouseLive:(UIButton *)sender {
    [self removeFromSuperview];
    if (self.otherHouseBlock) {
        self.otherHouseBlock();
    }
}

//退出直播间
- (IBAction)quitHouse:(UIButton *)sender {
    if (self.quitHouseBlock) {
        self.quitHouseBlock();
    }
}

@end
