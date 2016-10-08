//
//  MB_HomeLiveViewController.m
//  MiaoShow
//
//  Created by huhang on 16/9/11.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import "MB_HomeLiveViewController.h"
#import "MB_RefreshGifHeader.h"
#import "MB_HomeLiveCell.h"
#import "MB_LiveFlowLayout.h"
#import "MB_UserView.h"
#import "MB_LiveUser.h"

@interface MB_HomeLiveViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)UICollectionView *collectionView;

/** 用户视图 */
@property (nonatomic,strong)MB_UserView *userView;


@end

@implementation MB_HomeLiveViewController

static NSString * const reuseIdentifier = @"Cell";

- (MB_UserView *)userView{

    if (!_userView) {
        MB_UserView *userView = [MB_UserView viewFromXib];
        [self.collectionView addSubview:userView];
        _userView = userView;
        
        [userView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.center.mas_equalTo(0);
            make.width.mas_equalTo(SCREEN_WIDTH);
            make.height.mas_equalTo(SCREEN_HEIGHT);
        }];
        
        userView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        
        [userView setCloseBlock:^{
            [UIView animateWithDuration:0.5 animations:^{
                _userView.transform = CGAffineTransformMakeScale(0.01, 0.01);
            } completion:^(BOOL finished) {
                [_userView removeFromSuperview];
                _userView = nil;
            }];
        }];
        
    }
    return _userView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MB_LiveFlowLayout *flowLayout = [[MB_LiveFlowLayout alloc]init];
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    
    [collectionView registerClass:[MB_HomeLiveCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView = collectionView;
    
    MB_RefreshGifHeader *header = [MB_RefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHeader)];
    header.stateLabel.hidden = NO;
    [header setTitle:@"下拉切换另一个主播" forState:MJRefreshStatePulling];
    [header setTitle:@"下拉切换另一个主播" forState:MJRefreshStateIdle];
    collectionView.mj_header = header;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickUser:) name:kNotifyClickUser object:nil];
    
}

- (void)clickUser:(NSNotification *)notf{

    if (notf.userInfo[@"user"] != nil) {
        MB_LiveUser *user = notf.userInfo[@"user"];
        self.userView.user = user;
        [UIView animateWithDuration:0.5 animations:^{
            self.userView.transform = CGAffineTransformIdentity;
        }];
    }
}

- (void)refreshHeader{

    self.currentIndex ++;
    
    if (self.currentIndex == self.homeLives.count) {
        self.currentIndex = 0;
    }
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MB_HomeLiveCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.parentVC = self;
    cell.homeLive = self.homeLives[self.currentIndex];
    
    NSInteger relateIndex = self.currentIndex;
    if (self.currentIndex == self.homeLives.count - 1) {
        relateIndex = 0;
    }else{
        relateIndex += 1;
    }
    
    cell.relateLive = self.homeLives[relateIndex];
    [cell setClickSmallPlayerBlock:^{
        self.currentIndex +=1;
        [self.collectionView reloadData];
    }];
    return cell;
}

#pragma mark <UICollectionViewDelegate>


@end
