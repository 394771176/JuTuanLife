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
    NSString *_address;
}

@end

@implementation JTUserInfoEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改身份信息";
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}

- (WCTableSourceData *)setupTableSourceData
{
    WCTableSourceData *source = [WCTableSourceData new];
    WEAK_SELF
    WCTableSection *section = [WCTableSection sectionWithItems:@[@"拓业城市：", @"收货地址："] cellClass:[JTMineInfoListCell class] heightBlock:^CGFloat(id data, NSIndexPath *indexPath) {
        if (indexPath.row == 1) {
            return [JTMineInfoListCell cellHeightWithItem:_address tableView:weakSelf.tableView];
        } else {
            return [JTMineInfoListCell cellHeightWithItem:nil tableView:weakSelf.tableView];
        }
    }];
    [section setConfigBlock:^(JTMineInfoListCell *cell, id data, NSIndexPath *indexPath) {
        [cell setTitle:data];
        [cell setLineStyle:DTCellLineCustom];
        if (indexPath.row == 1) {
            [cell setCanEdit:YES];
            cell.delegate = self;
            [cell setSelectionStyleNone];
        } else {
            [cell setCanEdit:NO];
            cell.delegate = nil;
            [cell setSelectionStyleDefault];
        }
    } clickBlock:^(id data, NSIndexPath *indexPath) {
        
    }];
    
    WCTableRow *row = [WCTableRow rowWithItem:nil cellClass:[DTTableCustomCell class] height:30];
    row.configBlock = ^(DTTableCustomCell *cell, id data, NSIndexPath *indexPath) {
        [cell setSelectionStyleNoneLine];
    };
    [section addItemToDataList:row];
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
        [self.view endEditing:YES];
    }];
    [source setLastSectionHeaderHeight:16 footerHeight:0];
    
    return source;
}

#pragma mark - SCLoginTextFieldCellDelegate

- (void)loginTextFieldCell:(SCLoginTextFieldCell *)cell textFieldDidChange:(UITextField *)textField
{
    _address = textField.text;
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
