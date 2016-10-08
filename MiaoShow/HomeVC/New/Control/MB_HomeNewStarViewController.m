//
//  MB_NewStarViewController.m
//  MiaoShow
//
//  Created by huhang on 16/9/9.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import "MB_HomeNewStarViewController.h"
#import "MB_HomeNewFlowLayout.h"
#import "MB_HomeLiveViewController.h"
#import "MB_RefreshGifHeader.h"
#import "MB_HomeNewCell.h"
#import "MB_HomeHot.h"
#import "MB_LiveUser.h"

@interface MB_HomeNewStarViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)UICollectionView *collectionView;

@property (nonatomic,strong)NSMutableArray *homenews;

@property (nonatomic,assign)NSInteger currentPage;

@property (nonatomic,copy)NSString *msg;

@property (nonatomic,strong)NSTimer *timer;

@property (nonatomic,assign)CGFloat lastPosition;

/** 直播控制器 */
@property (nonatomic,strong)MB_HomeLiveViewController *homeLiveVC;

@end

@implementation MB_HomeNewStarViewController

- (MB_HomeLiveViewController *)homeLiveVC{

    if (!_homeLiveVC) {
        MB_HomeLiveViewController *homeLiveVC = [[MB_HomeLiveViewController alloc]init];
        _homeLiveVC = homeLiveVC;
    }
    return _homeLiveVC;
}

- (NSMutableArray *)homenews{

    if (!_homenews) {
        _homenews = [NSMutableArray array];
    }
    return _homenews;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MB_HomeNewFlowLayout *layout = [[MB_HomeNewFlowLayout alloc]init];
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MB_HomeNewCell class]) bundle:nil] forCellWithReuseIdentifier:@"cell"];
    self.collectionView = collectionView;
    [self getHomeNewData];
    
    collectionView.mj_header = [MB_RefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHeader)];
    collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshFooter)];
    
    [collectionView.mj_header beginRefreshing];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:10 * 60 * 60 target:self selector:@selector(autoRefresh) userInfo:nil repeats:YES];
    
    //监听当热门视图的导航栏和tabbar都隐藏时,然后滑动下一个视图时重新添加导航栏和tabbar
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollNew) name:@"scrollNew" object:nil];
    
}

- (void)scrollNew{

    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self setTabBarHidden:NO];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)autoRefresh{
 [self.collectionView.mj_header beginRefreshing];
}

#pragma mark - 刷新头部
- (void)refreshHeader{

    self.currentPage = 1;
    [self.homenews removeAllObjects];
    [self getHomeNewData];
}

#pragma mark - 刷新尾部
- (void)refreshFooter{

    self.currentPage ++;
    [self getHomeNewData];
}

- (void)getHomeNewData{

    [HttpTool getHomeNewDataPage:self.currentPage success:^(id responseObject) {
        
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        
        self.msg = responseObject[@"msg"];
    
        if ([self.msg isEqualToString:@"success"]) {
            NSArray *news = [MB_LiveUser mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            if ([self isNotEmpty:news]) {
                [self.homenews addObjectsFromArray:news];
                [self.collectionView reloadData];
            }
        }else{
            self.currentPage --;
        }
        [self checkFootState];
    } failure:^(NSError *error) {
        self.currentPage --;
        [self showHint:NET_NETWORK_CONTECTION];
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    [self checkFootState];
    return self.homenews.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    MB_HomeNewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.homeNew = self.homenews[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    NSMutableArray *array = [NSMutableArray array];
    for (MB_LiveUser *user in self.homenews) {
        
        MB_HomeHot *live = [[MB_HomeHot alloc]init];
        live.bigpic = user.photo;
        live.myname = user.nickname;
        live.smallpic = user.photo;
        live.gps = user.position;
        live.useridx = user.useridx;
        live.allnum = [NSString stringWithFormat:@"%u",arc4random_uniform(2000)];
        live.flv = user.flv;
        [array addObject:live];
    }
    self.homeLiveVC.homeLives = array;
    self.homeLiveVC.currentIndex = indexPath.row;
    [self presentViewController:_homeLiveVC animated:YES completion:nil];
}

- (void)checkFootState{

    self.collectionView.mj_footer.hidden = !(self.homenews.count > 0);
   
    if ([self.msg isEqualToString:@"fail"]) {
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.collectionView.mj_footer endRefreshing];
    }
}

#pragma mark 实现滑动视图让导航栏和tabbar消失
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    int currentPostion = scrollView.contentOffset.y;
    
    //向下滑动
    if (currentPostion - _lastPosition > 20  && currentPostion > 0) {
        //这个地方加上 currentPostion > 0 即可）
        _lastPosition = currentPostion;
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [self setTabBarHidden:YES];
        self.collectionView.height = SCREEN_HEIGHT;
    }else if ((_lastPosition - currentPostion > 20) && (currentPostion  <= scrollView.contentSize.height-scrollView.bounds.size.height-20)){//这个地方加上后边那个即可，也不知道为什么，再减20才行
        
        _lastPosition = currentPostion;
        [self setTabBarHidden:NO];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        
    }
}

//隐藏显示tabbar
- (void)setTabBarHidden:(BOOL)hidden
{
    UIView *tab = self.tabBarController.view;
    CGRect  tabRect = self.tabBarController.tabBar.frame;
    if ([tab.subviews count] < 2) {
        return;
    }
    
    UIView *view;
    if ([tab.subviews[0] isKindOfClass:[UITabBar class]]) {
        view = tab.subviews[1];
    } else {
        view = tab.subviews[0];
    }
    
    if (hidden) {
        view.frame = tab.bounds;
        tabRect.origin.y = SCREEN_HEIGHT + self.tabBarController.tabBar.height;
    } else {
        view.frame = CGRectMake(tab.bounds.origin.x, tab.bounds.origin.y, tab.bounds.size.width, tab.bounds.size.height);
        tabRect.origin.y = SCREEN_HEIGHT - self.tabBarController.tabBar.height;
    }
    
    [UIView animateWithDuration:0.5f animations:^{
        self.tabBarController.tabBar.y = tabRect.origin.y;
    }];
}

@end
