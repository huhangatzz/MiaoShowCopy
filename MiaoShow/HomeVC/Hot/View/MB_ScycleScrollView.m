//
//  HU_ScycleScrollView.m
//  轮播图
//
//  Created by huhang on 15/11/4.
//  Copyright (c) 2015年 huhang. All rights reserved.
//

#import "MB_ScycleScrollView.h"
#import "UIImageView+WebCache.h"
#define SCYLE_WIDTH CGRectGetWidth(self.frame)
#define SCYLE_HEIGHT CGRectGetHeight(self.frame)

@interface MB_ScycleScrollView()<UIScrollViewDelegate>

/** 延迟时间 */
@property (nonatomic,assign)NSTimeInterval intervalTime;
/** 滑动视图 */
@property (nonatomic,strong)UIScrollView *scrollView;
/** 小圆点控制器 */
@property (nonatomic,strong)UIPageControl *pageControl;
/** 延时器 */
@property (nonatomic,strong)NSTimer *delayTimer;
/** 标题 */
@property (nonatomic,strong)UILabel *titleLabel;

/** 上一张图片 */
@property (nonatomic,strong)UIImageView *beforeImageView;
/** 上一张图片位置 */
@property (nonatomic,assign)NSUInteger beforeImgIndex;

/** 目前这张图片 */
@property (nonatomic,strong)UIImageView *currentImageView;
/** 目前图片位置 */
@property (nonatomic,assign)NSInteger currentImgIndex;

/** 下一张图片 */
@property (nonatomic,strong)UIImageView *nextImageView;
/** 下一张图片的位置 */
@property (nonatomic,assign)NSInteger nextImgIndex;

@end

@implementation MB_ScycleScrollView

#pragma mark 初始化
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.intervalTime = 3;
        [self setupScycleView];
    }
    return self;
}

#pragma mark 创建视图
- (void)setupScycleView{
    
    //添加scrollView
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    scrollView.pagingEnabled = YES;
    scrollView.scrollEnabled = YES;
    scrollView.bounces = NO;
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(SCYLE_WIDTH * 3, SCYLE_HEIGHT);
    scrollView.contentOffset = CGPointMake(SCYLE_WIDTH, 0);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    
    //创建pageControl
    UIPageControl *pageControl = [[UIPageControl alloc]init];
    pageControl.currentPage = self.currentImgIndex;
    pageControl.enabled = NO;
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
    [self addSubview:pageControl];
    self.pageControl = pageControl;
    
    //创建3个UIImageView
    [self setupThreeImageView];
    
}

- (void)setImages:(NSArray *)images{
    
    _images = images;
    
    self.intervalTime = 10;
    self.pageControl.numberOfPages = images.count;
    self.pageControl.frame = CGRectMake(SCYLE_WIDTH - 20 * images.count, SCYLE_HEIGHT - 24, 20 * images.count, 24);
    
    //创建延时器
    [self renewSetDelayTimer];
    
    //更新图片位置
    [self updateScycelScrollViewImageIndex];
}

- (void)setupThreeImageView{
    
    //上一张图片
    UIImageView *beforeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCYLE_WIDTH, SCYLE_HEIGHT)];
    [self.scrollView addSubview:beforeImageView];
    self.beforeImageView = beforeImageView;
    
    //目前图片
    UIImageView *currentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCYLE_WIDTH, 0, SCYLE_WIDTH, SCYLE_HEIGHT)];
    currentImageView.userInteractionEnabled = YES;
    [self.scrollView addSubview:currentImageView];
    self.currentImageView = currentImageView;
    //给目前图片添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickTheCurrentImgAction:)];
    [currentImageView addGestureRecognizer:tap];
    
    //下一张图片
    UIImageView *nextImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCYLE_WIDTH * 2, 0, SCYLE_WIDTH, SCYLE_HEIGHT)];
    [self.scrollView addSubview:nextImageView];
    self.nextImageView = nextImageView;
}

#pragma mark 更新图片位置
- (void)updateScycelScrollViewImageIndex{
    
    if (self.images.count > 0) {
        [self addTheImageUrlStr:self.images[self.beforeImgIndex] imageView:_beforeImageView];
        [self addTheImageUrlStr:self.images[self.currentImgIndex] imageView:_currentImageView];
        [self addTheImageUrlStr:self.images[self.nextImgIndex] imageView:_nextImageView];
    }else{
        //没有图片,给目前图片位置设置为0
        _currentImgIndex = 0;
    }
    
    if (self.titles) {
        self.titleLabel.text = self.titles[_currentImgIndex];
    }
    _pageControl.currentPage = _currentImgIndex;
}

#pragma mark 解析图片并添加到imageView上
- (void)addTheImageUrlStr:(NSString *)urlStr imageView:(UIImageView *)imageView{
    
    if ([urlStr hasPrefix:@"http://"]) {
        NSURL *url = [NSURL URLWithString:urlStr];
        [imageView sd_setImageWithURL:url placeholderImage:_placeHolderImg];
    }else{
        imageView.image = [UIImage imageNamed:urlStr];
    }
}

#pragma mark 延时器执行方法
- (void)useTimerIntervalUpdateScrollViewContentOffSet:(NSTimer *)timer{
    [_scrollView setContentOffset:CGPointMake(SCYLE_WIDTH * 2, 0) animated:YES];
}

#pragma mark 点击图片执行方法
- (void)clickTheCurrentImgAction:(UITapGestureRecognizer *)tap{
    if ([_delegate respondsToSelector:@selector(scyleScrollView:index:)]) {
        [self.delegate scyleScrollView:self index:_currentImgIndex];
    }
}

#pragma mark 手动拖拽时响应方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.delayTimer invalidate];
    _delayTimer = nil;
}

#pragma mark 滑动结束时停止动画
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self scrollViewDidEndDecelerating:scrollView];
}

#pragma mark 减速滑动时
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    int offSet = floor(scrollView.contentOffset.x);
    if (offSet == 0) {
        self.currentImgIndex = self.beforeImgIndex;
    }else if (offSet == SCYLE_WIDTH * 2){
        self.currentImgIndex = self.nextImgIndex;
    }
    
    //更新图片位置
    [self updateScycelScrollViewImageIndex];
    //设置偏移量
    scrollView.contentOffset = CGPointMake(SCYLE_WIDTH, 0);
    //重新设置延时器
    if (_delayTimer == nil) {
        [self renewSetDelayTimer];
    }
}

#pragma mark 重新设置延时器
- (void)renewSetDelayTimer{
    //添加延迟器
    self.delayTimer = [NSTimer scheduledTimerWithTimeInterval:self.intervalTime target:self selector:@selector(useTimerIntervalUpdateScrollViewContentOffSet:) userInfo:nil repeats:YES];
    //加入事件循环中
    [[NSRunLoop mainRunLoop] addTimer:self.delayTimer forMode:NSRunLoopCommonModes];
}

//上一张图片位置
- (NSUInteger)beforeImgIndex{
    
    if (self.currentImgIndex == 0) {
        return self.images.count - 1;
    }else{
        return self.currentImgIndex - 1;
    }
}

//下一张图片的位置
- (NSInteger)nextImgIndex{
    
    if (self.currentImgIndex < (self.images.count - 1)) {
        return self.currentImgIndex + 1;
    }else{
        return 0;
    }
}

#pragma mark 设置标题
- (void)setTitles:(NSArray *)titles{
    
    _titles = titles;
    
    //添加标题
    if (self.titles.count > 0) {
        
        UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, SCYLE_HEIGHT - 24, SCYLE_WIDTH, 24)];
        titleView.backgroundColor = [UIColor colorWithRed:0.0 / 255.0 green:0.0 / 255.0 blue:0.0 / 255.0 alpha:0.25];
        [self addSubview:titleView];
        
        //标题Label
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, SCYLE_WIDTH - 20 * self.images.count, 24)];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:12.0];
        [titleView addSubview:titleLabel];
        self.titleLabel = titleLabel;
    }
}

#pragma mark 设置圆点正常颜色
- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor{
    _pageIndicatorTintColor = pageIndicatorTintColor;
    self.pageControl.pageIndicatorTintColor = pageIndicatorTintColor;
}

#pragma mark 设置圆点目前颜色
- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor{
    _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
    self.pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor;
}

#pragma mark 小圆点显示位置
- (void)setPageAligment:(pageControlAligment)pageAligment{
    _pageAligment = pageAligment;
    if (pageAligment == pageControlAligmentCenter) {
        self.pageControl.center = CGPointMake(self.center.x, self.pageControl.center.y);
    }
}

#pragma mark 设置占位图片
- (void)setPlaceHolderImg:(UIImage *)placeHolderImg{
    
    _placeHolderImg = placeHolderImg;
    if (placeHolderImg) {
        self.beforeImageView.image = placeHolderImg;
        self.currentImageView.image = placeHolderImg;
        self.nextImageView.image = placeHolderImg;
    }
}

@end
