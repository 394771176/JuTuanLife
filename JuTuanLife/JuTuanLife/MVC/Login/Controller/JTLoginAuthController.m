//
//  JTLoginAuthController.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/5.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTLoginAuthController.h"
#import "JTLoginAuthImageCell.h"
#import "JTLoginAgreementController.h"
#import "RPSDKManager.h"

@interface JTLoginAuthController ()
<
DTTableButtonCellDelegate
>
{
    NSMutableArray<JTLoginAuthImageCell *> *_cellArray;
    UIView *_bottomView;
    UIButton *_bottomBtn;
}

@end

@implementation JTLoginAuthController

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
    
    _cellArray = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        JTLoginAuthImageCell *cell = [[JTLoginAuthImageCell alloc] init];
        cell.step = i + 1;
        cell.delegate = self;
        [_cellArray safeAddObject:cell];
    }
    
    [super viewDidLoad];
    self.title = @"认证身份";
    
    [self.tableView setTableHeaderHeight:10 footerHeight:12];
    
    [self setupBottomView];
}

- (void)setupBottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 74 - SAFE_BOTTOM_VIEW_HEIGHT, self.width, 74 + SAFE_BOTTOM_VIEW_HEIGHT)];
        _bottomView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        _bottomView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_bottomView];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(24, 13, _bottomView.width - 48, 48);
        btn.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [btn setBackgroundImageAndHightlightWithColorHex:APP_JT_BTN_BG_RED cornerRadius:5];
        [btn addTarget:self action:@selector(nextStepAction)];
        [btn setTitle:@"下一步" fontSize:18 colorString:@"FFFFFF"];
        [_bottomView addSubview:btn];
        
        self.tableView.height = _bottomView.top;
    }
}

- (void)nextStepAction
{
    [RPSDKManager startAuthWithCompletion:^(BOOL success, id userInfo) {
        if (success) {
            [DTPubUtil startHUDLoading:@"校验认证信息"];
            [RPSDKManager getAndUploadVerifyResultWith:^(WCDataResult *result) {
                if (result.success) {
                    [DTPubUtil stopHUDLoading];
                    [[JTUserManager sharedInstance] checkToNextForStatus:JTUserStatusNeedCertifie];
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
    
//    [[JTUserManager sharedInstance] checkToNextForStatus:JTUserStatusNeedCertifie];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cellArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [JTLoginAuthImageCell cellHeightWithItem:nil tableView:tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [_cellArray safeObjectAtIndex:indexPath.row];
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

- (void)tableButtonCellDidClickAction:(JTLoginAuthImageCell *)cell
{
    NSInteger step = cell.step;
    NSLog(@"step:%zd", step);
}

@end
