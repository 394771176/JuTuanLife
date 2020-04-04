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
#import "JTLoginForgetController.h"

@interface JTLoginHomeController ()
<
SCLoginTextFieldCellDelegate,
DTTableButtonCellDelegate
>
{
//    JTLoginHeaderView *_loginHeader;
    UIView *_headerView;
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
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePhone:) name:JTLoginForgetController_PHONE object:nil];
    }
    return self;
}

- (BOOL)hiddenNavBar
{
    return YES;
}

//- (UIStatusBarStyle)statusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}

- (void)viewDidLoad
{
    _phoneCell = [[SCLoginPhoneCell alloc] init];
    _phoneCell.delegate = self;
    _phoneCell.phoneTextStyle = YES;
    _phoneCell.placehloder = @"请输入手机号码";
    _phoneCell.textField.returnKeyType = UIReturnKeyNext;
    [_phoneCell setleftGap:59 textHeight:_phoneCell.contentView.height];
    
    NSString *phone = [JTUserManager sharedInstance].phone;
    if (phone.length) {
        _phoneCell.text = phone;
    }
    
    _passwordCell = [[SCLoginPasswordCell alloc] init];
    _passwordCell.delegate = self;
    [_passwordCell setleftGap:59 textHeight:_phoneCell.contentView.height];
    _passwordCell.placehloder = @"请输入6-12位字母、数字";
    _passwordCell.maxTextLength = 12;
    _passwordCell.textField.clearButtonMode = UITextFieldViewModeNever;
    
    _loginCell = [[DTTableButtonCell alloc] init];
    [_loginCell.submitBtn setTitle:@"登 录"];
    _loginCell.gray = APP_JT_BTN_BG_GRAY;
    _loginCell.red = APP_JT_BTN_BG_RED;
    _loginCell.submitBtn.height = 48;
    [_loginCell setButtonTop:58];
    _loginCell.style = DTTableButtonStyleGray;
    _loginCell.delegate = self;
    
#ifdef DEBUG
    _loginCell.style = DTTableButtonStyleRed;
#endif
    
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
    
    self.tableView.tableHeaderView = [self headerView];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}

- (UIView *)headerView
{
//    _loginHeader = [[JTLoginHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.width, 204 + 55 + SAFE_BOTTOM_VIEW_HEIGHT)];
//    _loginHeader.showLogo = YES;

    if (!_headerView) {
        UICREATETo(_headerView, UIView, 0, 0, self.view.width, 200 + STATUSBAR_HEIGHT, AAW, self);
        
        UICREATELabelTo(UILabel *label1, UILabel, 36, 60+STATUSBAR_HEIGHT, self.view.width - 46, 45, AAW, APP_DISPLAY_NAME, FONT_B(32), @"000000", _headerView);
        
        UICREATELabelTo(UILabel *label2, UILabel, label1.left,label1.bottom + 4, label1.width, 30, AAW, @"生活服务线下销售运营平台", FONT(20), @"000000", _headerView);
        
        label2.left = label1.left;
    }
    return _headerView;
}

#pragma mark - action

- (void)loginAction
{
    //15618197321 / d4071255
    NSString *phone = _phoneCell.text;
    NSString *password = _passwordCell.text;
    if (APP_DEBUG && password.length <= 0) {
        phone = @"18800333031";
        password = @"qqq123";
        
        phone = @"15618197321";
        password = @"d4071255";
    }
    [JTUserManager loginActionWithPhone:phone password:password completion:^(WCDataResult *result) {
        if (result.success) {
            [[JTUserManager sharedInstance] checkToNextForStatus:JTUserStatusNeedLogin];
        } else {
            [DTPubUtil showHUDErrorHintInWindow:result.msg];
        }
    }];
}

- (void)forgetAction
{
    JTLoginForgetController *vc = [JTLoginForgetController new];
    vc.phone = _phoneCell.text;
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
            return 110;
            break;
        case 2:
        {
            CGFloat height = [tableView totalHeightToSection:indexPath.section target:self];
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
//    [_loginHeader setContentOffset:scrollView.contentOffset];
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
        [_loginCell setStyle:DTTableButtonStyleRed];
    } else {
        [_loginCell setStyle:DTTableButtonStyleGray];
    }
}

#pragma mark - updatePhone:

- (void)updatePhone:(NSNotification *)n
{
    if ([n.object isKindOfClass:NSString.class]) {
        _phoneCell.text = n.object;
    }
}

@end
