//
//  MB_HomeHotViewController.m
//  MiaoShow
//
//  Created by huhang on 16/9/7.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import "MB_HomeHotViewController.h"
#import "MB_HomeWebViewController.h"
#import "MB_HomeLiveViewController.h"
#import "MB_HomeSelectedView.h"
#import "MB_ScycleScrollView.h"
#import "MB_RefreshGifHeader.h"
#import "MB_HomeHotCell.h"
#import "MB_HomeHot.h"

@interface MB_HomeHotViewController ()<ScyleScrollViewDelegate>

//轮播图
@property (nonatomic,strong)NSMutableArray *scycles;
//热门数据
@property (nonatomic,strong)NSMutableArray *hotDatas;

@property (nonatomic,strong)UITableView *hotTableView;

@property (nonatomic,assign)NSInteger currentPage;

@property (nonatomic,copy)NSString *totalCount;

@property (nonatomic,strong)MB_ScycleScrollView *scycleScrollView;

@property (nonatomic,assign)CGFloat lastPosition;

@end

@implementation MB_HomeHotViewController

- (MB_ScycleScrollView *)scycleScrollView{

    if (!_scycleScrollView) {
        MB_ScycleScrollView *scycleView = [[MB_ScycleScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        scycleView.placeHolderImg = [UIImage imageNamed:@"placeHolder_ad_414x100"];
        scycleView.pageIndicatorTintColor = [[UIColor whiteColor]colorWithAlphaComponent:0.2];
        scycleView.currentPageIndicatorTintColor = [UIColor whiteColor];
        scycleView.delegate = self;
        
        self.hotTableView.tableHeaderView = scycleView;
        _scycleScrollView = scycleView;
    }
    return _scycleScrollView;
}

- (NSMutableArray *)scycles{

    if (!_scycles) {
        _scycles = [NSMutableArray array];
    }
    return _scycles;
}

- (NSMutableArray *)hotDatas{

    if (!_hotDatas) {
        _hotDatas = [NSMutableArray array];
    }
    return _hotDatas;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UITableView *hotTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    hotTableView.dataSource = self;
    hotTableView.delegate = self;
    hotTableView.tableFooterView = [[UIView alloc] init];
    hotTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:hotTableView];
    self.hotTableView = hotTableView;
    
    //注册cell
    [hotTableView registerNib:[UINib nibWithNibName:NSStringFromClass([MB_HomeHotCell class]) bundle:nil] forCellReuseIdentifier:@"hotCell"];
   
   //刷新
    self.hotTableView.mj_header = [MB_RefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHeader)];
    self.hotTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshFooter)];
    [self.hotTableView.mj_header beginRefreshing];
    
    //监听当热门视图的导航栏和tabbar都隐藏时,然后滑动下一个视图时重新添加导航栏和tabbar
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollHot) name:@"scrollHot" object:nil];
}

- (void)scrollHot{
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self setTabBarHidden:NO];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 刷新头部
- (void)refreshHeader{
 
    [self.hotDatas removeAllObjects];
    [self.scycles removeAllObjects];
    self.currentPage = 1;
    [self setupTopView];
    [self getHotLiveList];
}

#pragma mark - 刷新尾部
- (void)refreshFooter{

    self.currentPage ++;
    [self getHotLiveList];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //如果数组中没有数据,就把尾部隐藏
    [self checkFootState];
    return self.hotDatas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 450;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    MB_HomeHotCell *cell = [MB_HomeHotCell homeHotCellWithTableView:tableView];
    
    cell.hot = self.hotDatas[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    MB_HomeLiveViewController *homeLiveVC = [[MB_HomeLiveViewController alloc]init];
    homeLiveVC.homeLives = self.hotDatas;
    homeLiveVC.currentIndex = indexPath.row;
    [self presentViewController:homeLiveVC animated:YES completion:nil];
}

#pragma mark 检测tableview尾部状态
- (void)checkFootState{

    self.hotTableView.mj_footer.hidden = !(self.hotDatas.count > 0);

    if (self.hotDatas.count == [self.totalCount integerValue]) {
        [self.hotTableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.hotTableView.mj_footer endRefreshing];
    }
}

#pragma mark 创建顶部视图
- (void)setupTopView{
    
    [HttpTool getHomeTopScycleImage:^(id responseObject) {
        
        NSArray *result = responseObject[@"data"];
        NSArray *scycles = [MB_HomeHot mj_objectArrayWithKeyValuesArray:result];
        if ([self isNotEmpty:scycles]) {
            
            for (MB_HomeHot *hot in scycles) {
                [self.scycles addObject:hot.imageUrl];
            }
            [self performSelectorOnMainThread:@selector(setupViewUpdateUI:) withObject:self.scycles waitUntilDone:YES];
            //[self setupViewUpdateUI:images];
        }
        
    } failure:^(NSError *error) {
        [self showHint:NET_NETWORK_CONTECTION];
    }];
}

#pragma mark 创建轮播图
- (void)setupViewUpdateUI:(NSArray *)images{
    
    self.scycleScrollView.images = images;
    self.scycleScrollView.pageAligment = pageControlAligmentCenter;

}

#pragma mark - ScyleScrollViewDelegate
- (void)scyleScrollView:(MB_ScycleScrollView *)scyleView index:(NSInteger)index{
  
    MB_HomeHot *hot = self.scycles[index];
    MB_HomeWebViewController *homeWebVC = [[MB_HomeWebViewController alloc]initWithUrlStr:hot.link];
    homeWebVC.title = hot.title;
    //找到标题栏
    for (UIView *view in self.navigationController.navigationBar.subviews) {
        if ([view isKindOfClass:[MB_HomeSelectedView class]]) {
            view.hidden = YES;
        }
    }
    [self.navigationController pushViewController:homeWebVC animated:YES];
}

- (void)getHotLiveList{
    
    [HttpTool getHomeHotDataPage:self.currentPage success:^(id responseObject) {
        //结束刷新
        [self.hotTableView.mj_header endRefreshing];
        [self.hotTableView.mj_footer endRefreshing];
        
        //获取总数
        self.totalCount = responseObject[@"code"];
        NSArray *hots = [MB_HomeHot mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
        if ([self isNotEmpty:hots]) {
            //这里必须是添加到数组中,不能直接赋值,否则前面的数据会被覆盖
            [self.hotDatas addObjectsFromArray:hots];
            [self.hotTableView reloadData];
        }else{
            //恢复当前页
            self.currentPage --;
        }
        //检测尾部状态
        [self checkFootState];
        
    } failure:^(NSError *error) {
        [self showHint:NET_NETWORK_CONTECTION];
        //恢复当前页
        self.currentPage --;
        //结束刷新
        [self.hotTableView.mj_header endRefreshing];
        [self.hotTableView.mj_footer endRefreshing];
    }];
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
        self.hotTableView.height = SCREEN_HEIGHT;
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
