//
//  JTUserAddBankController.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/9.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTUserAddBankController.h"
#import "JTMineInfoListCell.h"

@interface JTUserAddBankController ()

@end

@implementation JTUserAddBankController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加银行卡";
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}

- (WCTableSourceData *)setupTableSourceData
{
    WEAK_SELF
    WCTableSourceData *source = [WCTableSourceData new];
    
    WCTableSection *section = [WCTableSection sectionWithItems:@[@"银行名称：", @"开户行：", @"银行卡号：", @"账户姓名："] cellClass:[JTMineInfoListCell class] heightBlock:^CGFloat(id data, NSIndexPath *indexPath) {
        if (indexPath.row == 1) {
            return [JTMineInfoListCell cellHeightWithItem:nil tableView:weakSelf.tableView];
        } else {
            return [JTMineInfoListCell cellHeightWithItem:nil tableView:weakSelf.tableView];
        }
    }];
    [section setConfigBlock:^(JTMineInfoListCell *cell, id data, NSIndexPath *indexPath) {
        [cell setCanEdit:YES];
        [cell setTitle:data];
        [cell setShowCamera:indexPath.row == 2];
    } clickBlock:^(id data, NSIndexPath *indexPath) {
        NSLog(@"%@", data);
    }];
    DTTableCustomCell *cell = [DTTableCustomCell new];
    [cell setSelectionStyleNoneLine];
    [section addItemToDataList:[WCTableRow rowWithItem:cell cellClass:NULL height:30]];
    [source addSectionItem:section];
    [source setLastSectionHeaderHeight:12 footerHeight:0];
    
    [source addRowWithItem:@"提 交" cellClass:[DTTableTitleCell class] height:48];
    [source setLastRowConfigBlock:^(DTTableTitleCell *cell, id data, NSIndexPath *indexPath) {
        cell.titleLabel.textAlignment = NSTextAlignmentCenter;
        [cell.titleLabel setFontSize:18 colorString:APP_JT_BTN_BLUE];
        [cell setTitle:data];
        [cell setLineStyle:DTCellLineNone];
    } clickBlock:^(id data, NSIndexPath *indexPath) {
        NSLog(@"%@", data);
    }];
    [source setLastSectionHeaderHeight:16 footerHeight:0];
    return source;
}

@end
