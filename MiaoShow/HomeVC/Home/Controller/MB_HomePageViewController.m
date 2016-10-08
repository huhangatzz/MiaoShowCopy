//
//  MB_HomePageViewController.m
//  MiaoShow
//
//  Created by huhang on 16/9/4.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import "MB_HomePageViewController.h"
#import "MB_HomeWebViewController.h"
#import "MB_HomeCareViewController.h"
#import "MB_HomeHotViewController.h"
#import "MB_HomeNewStarViewController.h"
#import "MB_HomeSelectedView.h"

@interface MB_HomePageViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong)MB_HomeSelectedView *selectedView;

@property (nonatomic,weak)UIScrollView *scrollView;

@end

@implementation MB_HomePageViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //设置左,右按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"search_15x14"] style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"head_crown_24x24"] style:UIBarButtonItemStyleDone target:self action:@selector(rankCrown)];
}

- (void)rankCrown{

    MB_HomeWebViewController *homeWebVC = [[MB_HomeWebViewController alloc]initWithUrlStr:@"http://live.9158.com/Rank/WeekRank?Random=10"];
    homeWebVC.title = @"排行";
    self.selectedView.hidden = YES;
    [self.navigationController pushViewController:homeWebVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    self.selectedView.hidden = NO;
    if (!_selectedView) {
        [self setupTopMenu];
        [self setupVC];
    }
}

- (void)setupTopMenu{

    MB_HomeSelectedView *selectedView = [[MB_HomeSelectedView alloc]initWithFrame:self.navigationController.navigationBar.bounds];
    selectedView.x = 45;
    selectedView.width = SCREEN_WIDTH - 45 * 2;
    [selectedView setSelectedBlock:^(HomeSelectedType type) {
        [self.scrollView setContentOffset:CGPointMake(type * SCREEN_WIDTH, 0) animated:YES];
    }];
    [self.navigationController.navigationBar addSubview:selectedView];
    _selectedView = selectedView;
}

#pragma mark - 创建控制器
- (void)setupVC{

    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, 0);
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.bounces = NO;
    
    MB_HomeHotViewController *homeHotVC = [[MB_HomeHotViewController alloc]init];
    homeHotVC.view.frame = [UIScreen mainScreen].bounds;
    homeHotVC.view.x = 0;
    [self addChildViewController:homeHotVC];
    [scrollView addSubview:homeHotVC.view];
    
    MB_HomeNewStarViewController *homeNewVC = [[MB_HomeNewStarViewController alloc]init];
    homeNewVC.view.frame = [UIScreen mainScreen].bounds;
    homeNewVC.view.x = SCREEN_WIDTH;
    [self addChildViewController:homeNewVC];
    [scrollView addSubview:homeNewVC.view];
    
    MB_HomeCareViewController *careVC = [UIStoryboard storyboardWithName:NSStringFromClass([MB_HomeCareViewController class]) bundle:nil].instantiateInitialViewController;
    careVC.view.frame = [UIScreen mainScreen].bounds;
    careVC.view.x = SCREEN_WIDTH * 2;
    [self addChildViewController:careVC];
    [scrollView addSubview:careVC.view];

    self.view = scrollView;
    self.scrollView = scrollView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
 
    CGFloat page = scrollView.contentOffset.x / SCREEN_WIDTH;
    CGFloat offsetX = scrollView.contentOffset.x / SCREEN_WIDTH * (self.selectedView.width * 0.5 - Home_Seleted_Item_W * 0.5 - 15);

    self.selectedView.underLine.x = 15 + offsetX;
    
    if (page == 1) {
        self.selectedView.underLine.x = offsetX + 10;
        //更新最新视图的导航栏
        [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollNew" object:nil];
    }else if (page > 1){
        self.selectedView.underLine.x = offsetX + 5;
    }
    
    self.selectedView.selectedType = (int)page;
    
    if (page == 2) { //滑动到关注
        [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollCare" object:nil];
    }else if (page == 0){
     [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollHot" object:nil];
    }
}

@end
