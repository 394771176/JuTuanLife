//
//  JTUserBankController.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/7.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTUserBankController.h"
#import "JTUserBankCell.h"
#import "JTUserAddBankController.h"

@interface JTUserBankController () <DTTableButtonCellDelegate> {
    UIButton *_addBankBtn;
    UILabel *_addBankTip;
    
    BOOL _showBank;
}

@end

@implementation JTUserBankController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"结算银行卡";
    
    [self reloadTableView];
}

- (WCTableSourceData *)setupTableSourceData;
{
    return [WCTableSourceData new];
}

- (void)reloadTableView
{
    [self.tableSourceData clearDataSource];
    if ([JTUserManager sharedInstance].user.bankNum.length || _showBank) {
        [self hideNoDataView];
        [self.tableSourceData addRowWithItem:nil cellClass:[JTUserBankCell class]];
        WEAK_SELF
        [self.tableSourceData setConfigBlock:^(JTUserBankCell *cell, id data, NSIndexPath *indexPath) {
            cell.delegate = weakSelf;
        }];
    } else {
        [self showNoDataView];
    }
    [super reloadTableView];
}

- (void)showNoDataView
{
    self.tableView.hidden = YES;
    if (!_addBankBtn) {
        UICREATEBtnTo(_addBankBtn, UIButton, self.width / 2 - 128 / 2, 84, 128, 40, AALR, @"＋添加银行卡", @"16", APP_JT_BTN_BLUE, self, @selector(addBankAction), self.view);
        _addBankBtn.backgroundColor = [UIColor whiteColor];
        _addBankBtn.cornerRadius = 3;
        
        
        UICREATELabelTo(_addBankTip, UILabel, 10, _addBankBtn.bottom + 10, self.view.width - 20, 32, AAW, @"请添加1张用于收取分润的银行卡", @"12", @"999999", self.view);
        _addBankTip.textAlignment = NSTextAlignmentCenter;
    }
    _addBankBtn.hidden = _addBankTip.hidden = NO;
}

- (void)hideNoDataView
{
    self.tableView.hidden = NO;
    _addBankBtn.hidden = _addBankTip.hidden = YES;
}

- (void)addBankAction
{
    PUSH_VC(JTUserAddBankController);
    if (APP_DEBUG) {
        _showBank = YES;
        [self reloadTableView];
    }
}

#pragma mark - DTTableButtonCellDelegate

- (void)tableButtonCellDidClickAction:(DTTableCustomCell *)cell
{
    [JTCoreUtil showActionSheetWithTitle:nil message:nil cancelTitle:@"取消" confirmTitle:@"解除绑定" destructiveTitle:nil handler:^(UIAlertAction *action) {
        NSLog(@"%@", action.title);
        if (APP_DEBUG) {
            _showBank = NO;
            [self reloadTableView];
        }
    }];
}

@end
