//
//  JTLoginForgetController.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/5.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTLoginForgetController.h"
#import "SCLoginTextFieldCell.h"
#import "JTMineHomeController.h"

@interface JTLoginForgetController () <DTTableButtonCellDelegate, SCLoginTextFieldCellDelegate> {
    NSMutableArray *_cellList;
    
    SCLoginTextFieldCell *_phoneCell;
    SCLoginTextFieldCell *_codeCell;
    SCLoginTextFieldCell *_passwordCell;
    DTTableButtonCell *_submitCell;
}

@end

@implementation JTLoginForgetController

- (void)viewDidLoad {
    _cellList = [NSMutableArray array];

    [_cellList safeAddObject:[self titleCell:@"账号"]];
    
    {
        CREATE_ITEM(SCLoginPhoneCell);
        item.phoneTextStyle = YES;
        [item hiddenIcon:YES];
        [item setleftGap:59 textHeight:34];
        if (_phone.length) {
            item.textField.text = _phone;
        }
        item.delegate = self;
        [_cellList safeAddObject:item];
        _phoneCell = item;
    }
    
    [_cellList safeAddObject:[self titleCell:@"验证码"]];
    
    {
        CREATE_ITEM(SCLoginPhoneCodeCell);
        [item setleftGap:59 textHeight:34];
        [item hiddenIcon:YES];
        item.delegate = self;
        item.codeBtn.normalColor = APP_JT_BLUE_COLOR;
        item.maxTextLength = 6;
        item.textField.clearButtonMode = UITextFieldViewModeNever;
        [_cellList safeAddObject:item];
        _codeCell = item;
    }
    
    [_cellList safeAddObject:[self titleCell:@"输入新密码"]];
    
    {
        CREATE_ITEM(SCLoginPasswordCell);
        [item setleftGap:59 textHeight:34];
        [item hiddenIcon:YES];
        item.delegate = self;
        item.maxTextLength = 12;
        item.placehloder = @"请输入6-12位字母、数字";
        item.textField.clearButtonMode = UITextFieldViewModeNever;
        [_cellList safeAddObject:item];
        _passwordCell = item;
    }
    
    {
        CREATE_ITEM(DTTableButtonCell);
        item.height = item.contentView.height = 150;
        [item setButtonTop:89];
        item.submitBtn.height = 48;
        [item setButtonHorGap:59];
//        [item setStyle:DTTableButtonStyleBlue];
        [item setStyle:DTTableButtonStyleGray];
        item.delegate = self;
        [item.submitBtn setTitle:@"提 交" fontSize:18 colorString:@"ffffff"];
        [_cellList safeAddObject:item];
        _submitCell = item;
    }
    
    [super viewDidLoad];
    
    self.title = @"找回密码";
    self.backgroundColor = [UIColor whiteColor];
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [self.tableView setTableHeaderHeight:45];
}

- (DTTableTitleCell *)titleCell:(NSString *)title
{
    CREATE_ITEM(DTTableTitleCell);
    item.title = title;
    [item setHorizontalGap:59];
    [item setTitleColorString:@"333333" withFontSize:16];
    [item setSelectionStyleClear];
    [item setLabelTop:20];
    return item;
}

- (void)backAction
{
    if (_phoneCell.text.length == 11) {
        [[NSNotificationCenter defaultCenter] postNotificationName:JTLoginForgetController_PHONE object:_phoneCell.textField.text];
    }
    [super backAction];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cellList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [_cellList safeObjectAtIndex:indexPath.row];
    if ([cell isKindOfClass:DTTableTitleCell.class]) {
        return 44;
    } else if ([cell isKindOfClass:SCLoginTextFieldCell.class]) {
        return 37;
    } else if ([cell isKindOfClass:DTTableButtonCell.class]) {
        return 90 + 48;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DTTableCustomCell *cell = [_cellList safeObjectAtIndex:indexPath.row];
    if (cell) {
        return cell;
    }
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - DTTableButtonCellDelegate

- (void)tableButtonCellDidClickAction:(DTTableCustomCell *)cell
{
    [self.view endEditing:YES];
    
    if (![JTCoreUtil isValidPassword:_passwordCell.text]) {
        return [DTPubUtil showHUDErrorHintInWindow:@"密码为6-12位字母、数字组合，\n且不能包含特殊字符"];
    }
    
    [JTService async:[JTUserRequest resetPasswordWithMobile:_phoneCell.text password:_passwordCell.text smsCode:_codeCell.text] finish:^(WCDataResult *result) {
        if (result.success) {
            [self backAction];
        } else {
            [DTPubUtil showHUDErrorHintInWindow:result.msg];
        }
    }];
}

#pragma mark - SCLoginTextFieldCellDelegate

- (void)loginTextFieldCell:(SCLoginTextFieldCell *)cell textFieldDidReturn:(UITextField *)textField
{
    if (cell == _passwordCell) {
        [_passwordCell.textField resignFirstResponder];
    }
}

- (void)loginTextFieldCell:(SCLoginTextFieldCell *)cell textFieldDidChange:(UITextField *)textField
{
    if (cell == _phoneCell) {
        if (_phoneCell.text.length == 11 && _codeCell.text.length == 0) {
            [_codeCell.textField becomeFirstResponder];
        }
    } else if (cell == _codeCell) {
        if (_codeCell.text.length == 4 && _passwordCell.text.length == 0) {
            [_passwordCell.textField becomeFirstResponder];
        }
    } else if (cell == _passwordCell) {
        if (_passwordCell.text.length == _passwordCell.maxTextLength) {
            [self.view endEditing:YES];
        }
    }
    
    if (_phoneCell.text.length == 11 && _codeCell.text.length >= 4 && _passwordCell.text.length >= 6) {
        [_submitCell setStyle:DTTableButtonStyleBlue];
    } else {
        [_submitCell setStyle:DTTableButtonStyleGray];
    }
}

- (void)loginTextFieldCell:(SCLoginTextFieldCell *)cell didCodeBtn:(SCCodeBtn *)sender
{
    if (_phoneCell.text.length < 11) {
        if (_phoneCell.text.length <= 0) {
            [DTPubUtil showHUDMessageInWindow:@"请输入手机号码"];
        } else {
            [DTPubUtil showHUDMessageInWindow:@"请输入正确的手机号码"];
        }
        return;
    }
    sender.status = SCCodeBtnStatusRequest;
    [JTService async:[JTUserRequest getSmsCodeWithMobile:_phoneCell.text] finish:^(WCDataResult *result) {
        if (result.success) {
            sender.status = SCCodeBtnStatusWait;
            [cell.textField becomeFirstResponder];
        } else {
            sender.status = SCCodeBtnStatusNormal;
            [DTPubUtil showHUDErrorHintInWindow:result.msg];
        }
    }];
}

@end
