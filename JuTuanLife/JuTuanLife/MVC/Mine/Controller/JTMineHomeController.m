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
#import "JTUserCenterController.h"

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserInfo) name:JTUserManager_USERINFO_UPDATE object:nil];
}

- (void)setupTableHeader
{
    if (!_headerView) {
        UICREATETo(_headerView, JTMineHeaderView, 0, 0, self.width, 155 + SAFE_BOTTOM_VIEW_HEIGHT, AAW, nil);
        [_headerView addTarget:self singleTapAction:@selector(clickHeaderView)];
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
        [source addSectionWithItems:items cellClass:[DTTableIconCell class] height:55];
        [source setLastSectionHeaderHeight:6 footerHeight:16];
    }
    
    {
        NSMutableArray *items = [NSMutableArray array];
        [items addObject:[DTTitleIconItem itemWithTitle:@"分享APP" iconName:@"user_home_share" scheme:@"share"]];
        [items addObject:[DTTitleIconItem itemWithTitle:@"关于聚推帮" iconName:@"user_home_jutui" scheme:@"about"]];
        [items addObject:[DTTitleIconItem itemWithTitle:@"退出登录" iconName:@"user_home_logout" scheme:@"logout"]];
        [source addSectionWithItems:items cellClass:[DTTableIconCell class] height:55];
        [source setLastSectionHeaderHeight:0 footerHeight:16];
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
//                PUSH_VC(JTAboutUsController);
                [JTLinkUtil openAboutUsURL];
            } else if ([data.openSchemeUrl isEqualToString:@"logout"]) {
                [self logoutAction];
            } else if ([data.openSchemeUrl isEqualToString:@"share"]) {
                [self shareAction];
            }
        }
    }];
    
    return source;
}

#pragma mark - action

- (void)clickHeaderView
{
    PUSH_VC_WITH(JTUserCenterController, vc.period = [JTDataManager sharedInstance].currentPeriod)
}

- (void)shareAction
{
    [JTCoreUtil showActionSheetWithTitle:nil message:nil cancelTitle:@"取消" confirmTitle:@"分享到微信好友" destructiveTitle:nil handler:^(UIAlertAction *action) {
        DTShareItem *item = [JTDataManager sharedInstance].shareItem;
        [DTShareUtil shareItem:item channel:DTShareToWXHy];
    }];
}

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

#pragma mark - notice

- (void)updateUserInfo
{
    _headerView.user = [JTUserManager sharedInstance].user;
}

@end
