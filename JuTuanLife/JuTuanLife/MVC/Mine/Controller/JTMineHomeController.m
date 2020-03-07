//
//  JTMineHomeController.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/7.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTMineHomeController.h"
#import "JTMineHeaderView.h"

@interface JTMineHomeController () {
    JTMineHeaderView *_headerView;
}

@end

@implementation JTMineHomeController

- (UIStatusBarStyle)statusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)hiddenNavBar
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    
    [self setupTableHeader];
}

- (void)setupTableHeader
{
    if (!_headerView) {
        CREATE_UI_VV(_headerView, JTMineHeaderView, 0, 0, self.width, 204 + SAFE_BOTTOM_VIEW_HEIGHT);
        _headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.tableView.tableHeaderView = _headerView;
    }
}

- (WCSourceTableData *)setupSourceTableData
{
    WCSourceTableData *source = [WCSourceTableData new];
    {
        NSMutableArray *items = [NSMutableArray array];
        [items addObject:[DTTitleIconItem itemWithTitle:@"身份信息" iconName:@"user_home_info"]];
        [items addObject:[DTTitleIconItem itemWithTitle:@"银行卡" iconName:@"user_home_bank"]];
        [items addObject:[DTTitleIconItem itemWithTitle:@"协议合同" iconName:@"user_home_protorol"]];
        [source addSectionWithItems:items cellClass:[DTTableIconCell class] height:44];
        [source setLastSectionHeaderHeight:12 footerHeight:4];
    }
    
    {
        NSMutableArray *items = [NSMutableArray array];
        [items addObject:[DTTitleIconItem itemWithTitle:@"关于聚推帮" iconName:@"user_home_jutui"]];
        [items addObject:[DTTitleIconItem itemWithTitle:@"退出登录" iconName:@"user_home_logout"]];
        [source addSectionWithItems:items cellClass:[DTTableIconCell class] height:44];
        [source setLastSectionHeaderHeight:12 footerHeight:4];
    }
    
    WEAK_SELF
    __weak id s = source;
    [source setConfigBlock:^(DTTableIconCell *cell, id data, NSIndexPath *indexPath) {
        if (weakSelf) {
            BOOL isLast = (indexPath.row == [s tableView:weakSelf.tableView numberOfRowsInSection:indexPath.section] - 1);
            [cell setLineStyle:(isLast ? DTCellLineNone : DTCellLineBottom)];
            [cell showArrow:YES];
        }
    } clickBlock:^(DTTitleIconItem *data, NSIndexPath *indexPath) {
        if (weakSelf) {
            NSLog(@"%@", data.title);
        }
    }];
    
    return source;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
    [_headerView setContentOffset:scrollView.contentOffset];
}

@end
