//
//  JTLoginAuth2Controller.m
//  JuTuanLife
//
//  Created by cheng on 2020/4/4.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTLoginAuth2Controller.h"
#import "JTLoginAuthUserCell.h"
#import "JTLoginAgreementController.h"
#import "RPSDKManager.h"

@interface JTLoginAuth2Controller ()
<
DTTableButtonCellDelegate
>
{
    JTLoginAuthUserCell *_authCell;
    DTTableButtonCell *_submitCell;
}

@end

@implementation JTLoginAuth2Controller

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.disableBackGesture = YES;
        self.disableBackBtn = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"认证身份";
    self.backgroundColor = [UIColor whiteColor];
}

- (WCTableSourceData *)setupTableSourceData
{
//    WEAK_SELF
    WCTableSourceData *source = [WCTableSourceData new];
    
    {
        if (!_authCell) {
            _authCell = [[JTLoginAuthUserCell alloc] init];
        }
        [source addRowWithCell:_authCell height:0];
        
        if (!_submitCell) {
            _submitCell = [[DTTableButtonCell alloc] init];
            [_submitCell setButtonTitle:@"开始认证"];
            _submitCell.red = APP_JT_BTN_BG_RED;
            _submitCell.style = DTTableButtonStyleRed;
            _submitCell.submitBtn.height = 48;
            [_submitCell setButtonTop:22];
            _submitCell.delegate = self;
        }
        [source addRowWithCell:_submitCell height:48 + 22 * 2];
    }
    
    return source;
}

#pragma mark - DTTableButtonCellDelegate

- (void)tableButtonCellDidClickAction:(DTTableCustomCell *)cell
{
    [RPSDKManager startAuthWithCompletion:^(BOOL success, id userInfo) {
        if (success) {
            [DTPubUtil startHUDLoading:@"校验认证信息"];
            [RPSDKManager getAndUploadVerifyResultWith:^(WCDataResult *result) {
                if (result.success) {
                    [DTPubUtil stopHUDLoading];
                    [[JTUserManager sharedInstance] checkToNextForStatus:JTUserStatusAuthPass];
                } else {
                    [DTPubUtil showHUDErrorHintInWindow:result.msg];
                }
            }];
        } else {
            if ([userInfo isKindOfClass:NSString.class]) {
                [DTPubUtil showHUDErrorHintInWindow:userInfo];
            }
        }
    }];
}

@end
