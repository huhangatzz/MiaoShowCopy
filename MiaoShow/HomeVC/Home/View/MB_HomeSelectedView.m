//
//  MB_HomeSelectedView.m
//  MiaoShow
//
//  Created by huhang on 16/9/5.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import "MB_HomeSelectedView.h"

@interface MB_HomeSelectedView ()

@property (nonatomic,strong)UIButton *selectedBtn;
@property (nonatomic,weak)UIButton *hotBtn;

@end

@implementation MB_HomeSelectedView

- (UIView *)underLine{

    if (!_underLine) {
        UIView *underLine = [[UIView alloc]initWithFrame:CGRectMake(15, self.height-4, Home_Seleted_Item_W + DefaultMargin, 2)];
        underLine.backgroundColor = [UIColor whiteColor];
        [self addSubview:underLine];
        _underLine = underLine;
    }
    return _underLine;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)setupView{

    UIButton *hotBtn = [self createBtn:@"热门" tag:HomeSelectedTypeHot];
    UIButton *newBtn = [self createBtn:@"最新" tag:HomeSelectedTypeNew];
    UIButton *careBtn = [self createBtn:@"关注" tag:HomeSelectedTypeCare];
    [self addSubview:hotBtn];
    [self addSubview:newBtn];
    [self addSubview:careBtn];
    _hotBtn = hotBtn;
    //显示下划线
    [self underLine];
    
    [newBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(Home_Seleted_Item_W);
    }];
    
    [hotBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).with.offset(DefaultMargin * 2);
        make.width.mas_equalTo(Home_Seleted_Item_W);
    }];
    
    [careBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(self);
        make.right.equalTo(self).with.offset(-DefaultMargin * 2);
        make.width.mas_equalTo(Home_Seleted_Item_W);
    }];
    
    //强制更新一次
    //如果，有需要刷新的标记，立即调用layoutSubviews进行布局
    [self layoutIfNeeded];
    //默认选中热门
    [self click:hotBtn];
    //监听通知,去看热门主播
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toSeeHotWorld) name:kNotifyToSeeHotWorld object:nil];
}

- (void)toSeeHotWorld{
    [self click:_hotBtn];
}

- (UIButton *)createBtn:(NSString *)title tag:(HomeSelectedType)tag{
 
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.6] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    btn.tag = tag;
    [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

#pragma mark 点击事件
- (void)click:(UIButton *)sender{

    //把以前选择的按钮给设置成不选择状态
    self.selectedBtn.selected = NO;
    sender.selected = YES;
    self.selectedBtn = sender;

    if (self.selectedBlock) {
        self.selectedBlock(sender.tag);
    }
}

- (void)setSelectedType:(HomeSelectedType)selectedType{

    //滑动时切换按钮
    _selectedType = selectedType;
    self.selectedBtn.selected = NO;
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]] && view.tag == selectedType) {
            self.selectedBtn = (UIButton *)view;
            ((UIButton *)view).selected = YES;
        }
    }

}

@end
