//
//  JTUserInfoEditController.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/11.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTUserInfoEditController.h"
#import "JTMineInfoListCell.h"
#import "DTTextViewEditCell.h"

@interface JTUserInfoEditController () <SCLoginTextFieldCellDelegate> {
    DTTextViewEditCell *_textCell;
}

@end

@implementation JTUserInfoEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.title.length) {
        self.title = @"信息编辑";
    }
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [self setRightBarItem:[WCBarItemUtil barButtonItemWithTitle:@"保存" target:self action:@selector(rightBarAciton)]];
}

- (WCTableSourceData *)setupTableSourceData
{
    WCTableSourceData *source = [WCTableSourceData new];
//    WEAK_SELF
//    WCTableSection *section = [WCTableSection sectionWithItems:@[@"拓业城市：", @"收货地址："] cellClass:[JTMineInfoListCell class] heightBlock:^CGFloat(id data, NSIndexPath *indexPath) {
//        if (indexPath.row == 1) {
//            return [JTMineInfoListCell cellHeightWithItem:_address tableView:weakSelf.tableView];
//        } else {
//            return [JTMineInfoListCell cellHeightWithItem:nil tableView:weakSelf.tableView];
//        }
//    }];
//    [section setConfigBlock:^(JTMineInfoListCell *cell, id data, NSIndexPath *indexPath) {
//        [cell setTitle:data];
//        [cell setLineStyle:DTCellLineCustom];
//        if (indexPath.row == 1) {
//            [cell setCanEdit:YES];
//            cell.delegate = self;
//            [cell setSelectionStyleNone];
//        } else {
//            [cell setCanEdit:NO];
//            cell.delegate = nil;
//            [cell setSelectionStyleDefault];
//        }
//    } clickBlock:^(id data, NSIndexPath *indexPath) {
//
//    }];
//
//    WCTableRow *row = [WCTableRow rowWithItem:nil cellClass:[DTTableCustomCell class] height:30];
//    row.configBlock = ^(DTTableCustomCell *cell, id data, NSIndexPath *indexPath) {
//        [cell setSelectionStyleNoneLine];
//    };
//    [section addItemToDataList:row];
//    [source addSectionItem:section];
//    [source setLastSectionHeaderHeight:12 footerHeight:0];
    WEAK_SELF
    {
        if (!_textCell) {
            _textCell = [[DTTextViewEditCell alloc] init];
            _textCell.placeholder = weakSelf.placeholder;
            _textCell.orignalText = weakSelf.orignalText;
        }
        WCTableRow *row = [WCTableRow rowWithCell:_textCell height:0 click:nil];
        [source addRowItem:row];
        [source setLastSectionHeaderHeight:10 footerHeight:0];
    }
    
//    [source addNewSection];
//
//    [source addRowWithItem:@"提 交" cellClass:[DTTableTitleCell class] height:48];
//    [source setLastRowConfigBlock:^(DTTableTitleCell *cell, id data, NSIndexPath *indexPath) {
//        cell.titleLabel.textAlignment = NSTextAlignmentCenter;
//        [cell.titleLabel setFontSize:18 colorString:APP_JT_BTN_TITLE_BLUE];
//        [cell setTitle:data];
//        [cell setLineStyle:DTCellLineNone];
//    } clickBlock:^(id data, NSIndexPath *indexPath) {
//        NSLog(@"%@", data);
//        [self.view endEditing:YES];
//    }];
//    [source setLastSectionHeaderHeight:12 footerHeight:0];
    
    return source;
}

- (void)backAction
{
    [self.view endEditing:YES];
    if (self.orignalText && _textCell.text && ![self.orignalText isEqualToString:_textCell.text]) {
        [JTCoreUtil showAlertWithTitle:@"温馨提示" message:@"是否保存你的修改" cancelTitle:@"不保存" confirmTitle:@"保存" destructiveTitle:nil handler:^(UIAlertAction *action) {
            [self rightBarAciton];
        } cancel:^(UIAlertAction *action) {
            [super backAction];
        }];
        return;
    }
    [super backAction];
}

- (void)rightBarAciton
{
    [self.view endEditing:YES];
    [DTPubUtil sendTagert:_delegate action:@selector(userInfoEditController:changeText:) object:self object2:_textCell.text];
    [super backAction];
}

#pragma mark - SCLoginTextFieldCellDelegate

- (void)loginTextFieldCell:(SCLoginTextFieldCell *)cell textFieldDidChange:(UITextField *)textField
{
//    _address = textField.text;
//    [self reloadTableView];
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
//    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)loginTextFieldCell:(SCLoginTextFieldCell *)cell textFieldDidReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
}

@end
