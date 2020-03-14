//
//  JTMineHomeController.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/7.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTMineHomeController.h"
#import "JTMineHeaderView.h"
#import "JTUserInfoController.h"
#import "JTUserBankController.h"
#import "JTUserProtorolsController.h"
#import "JTAboutUsController.h"

@interface JTMineHomeController () {
    JTMineHeaderView *_headerView;
}

@end

@implementation JTMineHomeController

- (BOOL)hiddenNavBar
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    
    [self setupTableHeader];
    
    [self reloadTableView];
}

- (void)setupTableHeader
{
    if (!_headerView) {
        UICREATETo(_headerView, JTMineHeaderView, 0, 0, self.width, 180 + SAFE_BOTTOM_VIEW_HEIGHT, AAW, nil);
        self.tableView.tableHeaderView = _headerView;
    }
}

- (WCTableSourceData *)setupTableSourceData
{
    WCTableSourceData *source = [WCTableSourceData new];
    {
        NSMutableArray *items = [NSMutableArray array];
        [items addObject:[DTTitleIconItem itemWithTitle:@"身份信息" iconName:@"user_home_info" scheme:@"info"]];
        [items addObject:[DTTitleIconItem itemWithTitle:@"银行卡" iconName:@"user_home_bank" scheme:@"bank"]];
        [items addObject:[DTTitleIconItem itemWithTitle:@"协议合同" iconName:@"user_home_protorol" scheme:@"protorol"]];
        [source addSectionWithItems:items cellClass:[DTTableIconCell class] height:44];
        [source setLastSectionHeaderHeight:12 footerHeight:4];
    }
    
    {
        NSMutableArray *items = [NSMutableArray array];
        [items addObject:[DTTitleIconItem itemWithTitle:@"关于聚推帮" iconName:@"user_home_jutui" scheme:@"about"]];
        [items addObject:[DTTitleIconItem itemWithTitle:@"退出登录" iconName:@"user_home_logout" scheme:@"logout"]];
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
            if ([data.openSchemeUrl isEqualToString:@"info"]) {
                PUSH_VC(JTUserInfoController);
            } else if ([data.openSchemeUrl isEqualToString:@"bank"]) {
                PUSH_VC(JTUserBankController);
            } else if ([data.openSchemeUrl isEqualToString:@"protorol"]) {
                PUSH_VC(JTUserProtorolsController);
            } else if ([data.openSchemeUrl isEqualToString:@"about"]) {
                PUSH_VC(JTAboutUsController);
            } else if ([data.openSchemeUrl isEqualToString:@"logout"]) {
                [self logoutAction];
            }
        }
    }];
    
    return source;
}

#pragma mark - action

- (void)logoutAction
{
    [JTCoreUtil showActionSheetWithTitle:nil message:nil cancelTitle:@"取消" confirmTitle:nil destructiveTitle:@"退出登录" handler:^(UIAlertAction *action) {
        [JTUserManager logoutAction:^{
            NSLog(@"退出");
        }];
    }];
}

- (void)reloadTableView
{
    _headerView.user = [JTUserManager sharedInstance].user;
    [super reloadTableView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
}

@end
