//
//  JTLoginHomeController.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/4.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTLoginHomeController.h"
#import "SCLoginTextFieldCell.h"
#import "JTLoginHeaderView.h"
#import "JTLoginAuthController.h"
#import "JTLoginAgreementController.h"
#import "JTLoginForgetController.h"

@interface JTLoginHomeController ()
<
SCLoginTextFieldCellDelegate,
DTTableButtonCellDelegate
>
{
    JTLoginHeaderView *_loginHeader;
    
    SCLoginPhoneCell *_phoneCell;
    SCLoginPasswordCell *_passwordCell;
    DTTableButtonCell *_loginCell;
    DTTableButtonCell *_forgetCell;
}

@end

@implementation JTLoginHomeController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.disableBackGesture = YES;
        self.disableBackBtn = YES;
    }
    return self;
}

- (BOOL)hiddenNavBar
{
    return YES;
}

- (UIStatusBarStyle)statusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    _loginHeader = [[JTLoginHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.width, 204 + 55 + SAFE_BOTTOM_VIEW_HEIGHT)];
    _loginHeader.showLogo = YES;
    
    _phoneCell = [[SCLoginPhoneCell alloc] init];
    _phoneCell.delegate = self;
    _phoneCell.phoneTextStyle = YES;
    _phoneCell.placehloder = @"请输入手机号码";
    _phoneCell.textField.returnKeyType = UIReturnKeyNext;
    [_phoneCell setleftGap:59 textHeight:_phoneCell.contentView.height];
    
    _passwordCell = [[SCLoginPasswordCell alloc] init];
    _passwordCell.delegate = self;
    [_passwordCell setleftGap:59 textHeight:_phoneCell.contentView.height];
    _passwordCell.placehloder = @"请输入6-12位数字、字母";
    _passwordCell.maxTextLength = 18;
    
    _loginCell = [[DTTableButtonCell alloc] init];
    [_loginCell.submitBtn setTitle:@"登 录"];
    _loginCell.gray = APP_JT_GRAY_STRING;
    _loginCell.blue = APP_JT_BLUE_STRING;
    _loginCell.submitBtn.height = 48;
    [_loginCell setButtonTop:128];
    _loginCell.style = DTTableButtonStyleGray;
    _loginCell.delegate = self;
    
    if (APP_DEBUG) {
        _loginCell.style = DTTableButtonStyleBlue;
    }
    
    _forgetCell = [[DTTableButtonCell alloc] init];
    [_forgetCell setButtonTitle:@"找回密码" withTitleColorStr:@"#999999"];
    _forgetCell.style = DTTableButtonStyleNone;
    _forgetCell.height = _forgetCell.contentView.height = 100;
    _forgetCell.submitBtn.bottom = _forgetCell.contentView.height - (40);
    _forgetCell.submitBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    _forgetCell.delegate = self;
    
    [super viewDidLoad];
    self.title = @"登录";
    self.backgroundColor = [UIColor whiteColor];
    
    self.tableView.tableHeaderView = _loginHeader;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}

#pragma mark - action

- (void)loginAction
{
    //15618197321 / d4071255
    NSString *phone = _phoneCell.text;
    NSString *password = _passwordCell.text;
    if (APP_DEBUG) {
        phone = @"18800333031";
        password = @"wang@123";
    }
    [JTUserManager loginActionWithPhone:phone password:password completion:^(WCDataResult *result) {
        if (result.success) {
            [[JTUserManager sharedInstance] checkUpdateAuthStatusController];
        } else {
            [DTPubUtil showHUDErrorHintInWindow:result.msg];
            if (APP_DEBUG) {
                [[JTUserManager sharedInstance] setControllerAuthStatus:JTUserStatusNeedCertifie];
                [[JTUserManager sharedInstance] checkUpdateAuthStatusController];
            }
        }
    }];
    
//    JTLoginAuthController *vc = [JTLoginAuthController new];
//    [WCControllerUtil pushViewController:vc];
    
//    [JTCommon resetMainController];
}

- (void)forgetAction
{
    JTLoginForgetController *vc = [JTLoginForgetController new];
    [WCControllerUtil pushViewController:vc];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 56;
            break;
        case 1:
            return 176;
            break;
        case 2:
        {
            CGFloat height = [tableView totalHeightToSection:indexPath.section target:self];
            height += _loginHeader.height;
            height = self.tableView.height - height;
            if (height < 100) {
                height = 100;
            }
            return height;
        }
            break;
        default:
            break;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                return _phoneCell;
            } else {
                return _passwordCell;
            }
        }
            break;
        case 1:
        {
            return _loginCell;
        }
            break;
        case 2:
        {
            return _forgetCell;
        }
            break;
        default:
            break;
    }
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
    [_loginHeader setContentOffset:scrollView.contentOffset];
}

#pragma mark - DTTableButtonCellDelegate

- (void)tableButtonCellDidClickAction:(DTTableCustomCell *)cell
{
    if (cell == _loginCell) {
        [self loginAction];
    } else if (cell == _forgetCell) {
        [self forgetAction];
    }
}

#pragma mark - SCLoginTextFieldCellDelegate

- (void)loginTextFieldCell:(SCLoginTextFieldCell *)cell textFieldDidReturn:(UITextField *)textField
{
    if (textField == _phoneCell.textField) {
        [_passwordCell.textField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
}

- (void)loginTextFieldCell:(SCLoginTextFieldCell *)cell textFieldDidChange:(UITextField *)textField
{
    if (_phoneCell.text.length>=11 && _passwordCell.text.length>=6) {
        [_loginCell setStyle:DTTableButtonStyleBlue];
    } else {
        [_loginCell setStyle:DTTableButtonStyleGray];
    }
}

@end
