//
//  MP_ParentTableController.h
//  Purchase
//
//  Created by makepolo-ios on 14/11/27.
//  Copyright (c) 2014年 com.soudoushi.makepolo. All rights reserved.
//

@interface MB_ParentTableController : MB_BaseViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView  *tableView;
@property (nonatomic,strong)NSMutableArray *dataSource;

@end
