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
<
SCLoginTextFieldCellDelegate
>
{
    JTMineInfoListCell *_bankCell;
    JTMineInfoListCell *_kaihuCell;
    JTMineInfoListCell *_cardNoCell;
    JTMineInfoListCell *_userNameCell;
    
    NSString *_kaihuText;
}

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
    
    if (!_bankCell) {
        NSArray *array = @[@"银行名称：", @"开  户  行：", @"银行卡号：", @"账户姓名："];
        {
            JTMineInfoListCell *cell = [[JTMineInfoListCell alloc] init];
            cell.delegate = self;
            cell.title = [array safeObjectAtIndex:0];
            cell.canEdit = YES;
            [cell.textView setReturnKeyType:UIReturnKeyNext];
            _bankCell = cell;
        }
        {
            JTMineInfoListCell *cell = [[JTMineInfoListCell alloc] init];
            cell.delegate = self;
            cell.title = [array safeObjectAtIndex:1];
            cell.canEdit = YES;
            [cell.textView setReturnKeyType:UIReturnKeyNext];
            cell.topOffset = 5;
            _kaihuCell = cell;
        }
        {
            JTMineInfoListCell *cell = [[JTMineInfoListCell alloc] init];
            cell.delegate = self;
            cell.title = [array safeObjectAtIndex:2];
            cell.canEdit = YES;
            [cell.textView setReturnKeyType:UIReturnKeyNext];
            _cardNoCell = cell;
        }
        {
            JTMineInfoListCell *cell = [[JTMineInfoListCell alloc] init];
            cell.delegate = self;
            cell.title = [array safeObjectAtIndex:3];
            cell.canEdit = YES;
            [cell.textView setReturnKeyType:UIReturnKeyDone];
            _userNameCell = cell;
        }
        
        if (_bank) {
            _bankCell.textView.text = _bank.bankName;
            _kaihuCell.textView.text = _bank.bankBranch;
            _cardNoCell.textView.text = _bank.cardNo;
            _userNameCell.textView.text = _bank.holder;
        }
    }
    
    WCTableSection *section = [WCTableSection sectionWithCells:@[_bankCell, _kaihuCell, _cardNoCell, _userNameCell] heightBlock:^CGFloat(id data, NSIndexPath *indexPath) {
        if (indexPath.row == 1) {
            return [JTMineInfoListCell cellHeightWithItem:self->_kaihuText tableView:weakSelf.tableView] + 5;
        } else {
            return [JTMineInfoListCell cellHeightWithItem:nil tableView:weakSelf.tableView];
        }
    } click:^(id data, NSIndexPath *indexPath) {
        
    }];
    
    DTTableCustomCell *cell = [DTTableCustomCell new];
    [cell setSelectionStyleNoneLine];
    [section addItemToDataList:[WCTableRow rowWithItem:cell cellClass:NULL height:12]];
    [source addSectionItem:section];
    [source setLastSectionHeaderHeight:12 footerHeight:0];
    
    [source addNewSection];
    
    [source addRowWithItem:@"提 交" cellClass:[DTTableTitleCell class] height:48];
    [source setLastRowConfigBlock:^(DTTableTitleCell *cell, id data, NSIndexPath *indexPath) {
        cell.titleLabel.textAlignment = NSTextAlignmentCenter;
        [cell.titleLabel setFontSize:18 colorString:@"333333"];
        [cell setTitle:data];
        [cell setLineStyle:DTCellLineNone];
    } clickBlock:^(id data, NSIndexPath *indexPath) {
        [self addBankAction];
    }];
    [source setLastSectionHeaderHeight:12 footerHeight:0];
    return source;
}

- (void)addBankAction
{
    if (_bankCell.textView.text.length <= 0) {
        [DTPubUtil showHUDMessageInWindow:@"请输入银行名称"];
        return;
    }
    if (_kaihuCell.textView.text.length <= 0) {
        [DTPubUtil showHUDMessageInWindow:@"请输入开户行"];
        return;
    }
    if (_cardNoCell.textView.text.length <= 0) {
        [DTPubUtil showHUDMessageInWindow:@"请输入银行卡号"];
        return;
    }
    if (_userNameCell.textView.text.length <= 0) {
        [DTPubUtil showHUDMessageInWindow:@"请输入账户姓名"];
        return;
    }
    
    JTUserBank *bank = nil;
    if (_bank) {
        bank = _bank;
    } else {
        bank = [JTUserBank new];
    }
    bank.bankName = _bankCell.textView.text;
    bank.bankBranch = _kaihuCell.textView.text;
    bank.cardNo = _cardNoCell.textView.text;
    bank.holder = _userNameCell.textView.text;
    
    [DTPubUtil startHUDLoading:@"提交中"];
    [JTService async:[JTUserRequest addOrUpdate_bank_cardWithBank:bank] finish:^(WCDataResult *result) {
        if (result.success) {
            [[NSNotificationCenter defaultCenter] postNotificationName:JTUserAddBankController_ADD_BANK object:nil];
            [DTPubUtil addBlock:^{
                if (bank.itemId) {
                    [DTPubUtil showHUDSuccessHintInWindow:@"更新成功"];
                } else {
                    [DTPubUtil showHUDSuccessHintInWindow:@"添加成功"];
                }
                
                [self backAction];
            } withDelay:0.5];
        } else {
            [DTPubUtil showHUDErrorHintInWindow:result.msg];
        }
    }];
}

#pragma mark - SCLoginTextFieldCellDelegate

- (void)loginTextFieldCell:(SCLoginTextFieldCell *)cell textFieldDidChange:(UITextField *)textField
{
    if (cell == (id)_kaihuCell) {
        _kaihuText = textField.text;
    }
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (void)loginTextFieldCell:(SCLoginTextFieldCell *)cell textFieldDidReturn:(UITextField *)textField
{
    if (textField == (id)_bankCell) {
        [_kaihuCell.textView becomeFirstResponder];
    } else if (textField == (id)_kaihuCell) {
        [_cardNoCell.textView becomeFirstResponder];
    } else if (textField == (id)_cardNoCell) {
        [_userNameCell.textView becomeFirstResponder];
    } else if (textField == (id)_userNameCell) {
        
    }
}

@end
