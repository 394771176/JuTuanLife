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
#import "JTUserBankModel.h"

@interface JTUserBankController () <DTTableButtonCellDelegate> {
    UIButton *_addBankBtn;
    UILabel *_addBankTip;
    
    BOOL _showBank;
    
    UIBarButtonItem *_rightBarItem;
}

@end

@implementation JTUserBankController

- (void)viewDidLoad {
    _rightBarItem = [WCBarItemUtil barButtonItemWithTitle:@"变更" target:self action:@selector(changeBankCard)];
    
    [super viewDidLoad];
    self.title = @"结算银行卡";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:JTUserAddBankController_ADD_BANK object:nil];
}

- (BOOL)canShowLoadingIndicator
{
    return NO;
}

- (DTListDataModel *)createDataModel
{
    JTUserBankModel *model = [[JTUserBankModel alloc] initWithDelegate:self];
    [model loadCache];
    return model;
}

- (WCTableSourceData *)setupTableSourceData;
{
    WCTableSourceData *source = [WCTableSourceData new];

    {
        [source addSectionWithItems:self.dataModel.data cellClass:[JTUserBankCell class]];
        WEAK_SELF
        [source setConfigBlock:^(JTUserBankCell *cell, id data, NSIndexPath *indexPath) {
            cell.delegate = weakSelf;
        }];
    }
    
    return source;
}

- (void)reloadTableView
{
    if (self.dataModel.itemCount) {
        [self setRightBarItem:_rightBarItem];
        [self hideNoDataView];
    } else {
        [self showNoDataView];
        [self setRightBarItem:nil];
    }
    [super reloadTableView];
}

- (void)showNoDataView
{
    self.tableView.hidden = YES;
    if (!_addBankBtn) {
        UICREATEBtnTo(_addBankBtn, UIButton, self.width / 2 - 128 / 2, 84, 128, 40, AALR, @"＋添加银行卡", @"16", APP_JT_BTN_TITLE_BLUE, self, @selector(addBankAction), self.view);
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

- (void)changeBankCard
{
    JTUserBank *bank = [self.dataModel itemAtIndex:0];
    [self changeBankCardWithCard:bank];
}

- (void)changeBankCardWithCard:(JTUserBank *)card
{
    PUSH_VC_WITH(JTUserAddBankController, vc.bank = card)
}

#pragma mark - DTTableButtonCellDelegate

- (void)tableButtonCellDidClickAction:(DTTableCustomCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [JTCoreUtil showActionSheetWithTitle:nil message:nil cancelTitle:@"取消" confirmTitle:@"变更" destructiveTitle:nil handler:^(UIAlertAction *action) {
        JTUserBank *bank = [self.dataModel itemAtIndex:indexPath.row];
        [self changeBankCardWithCard:bank];
    }];
}

@end
