//
//  JTLoginForgetController.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/5.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTLoginForgetController.h"
#import "SCLoginTextFieldCell.h"

@interface JTLoginForgetController () <DTTableButtonCellDelegate> {
    NSMutableArray *_cellList;
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
        [_cellList safeAddObject:item];
    }
    
    [_cellList safeAddObject:[self titleCell:@"验证码"]];
    
    {
        CREATE_ITEM(SCLoginPhoneCodeCell);
        [item setleftGap:59 textHeight:34];
        [item hiddenIcon:YES];
        [_cellList safeAddObject:item];
    }
    
    [_cellList safeAddObject:[self titleCell:@"输入新密码"]];
    
    {
        CREATE_ITEM(SCLoginPasswordCell);
        [item setleftGap:59 textHeight:34];
        [item hiddenIcon:YES];
        [_cellList safeAddObject:item];
    }
    
    {
        CREATE_ITEM(DTTableButtonCell);
        item.height = item.contentView.height = 150;
        [item setButtonTop:89];
        item.submitBtn.height = 48;
        [item setButtonHorGap:59];
        [item setStyle:DTTableButtonStyleBlue];
        item.delegate = self;
        [item.submitBtn setTitle:@"提 交"];
        [_cellList safeAddObject:item];
    }
    
    [super viewDidLoad];
    
    self.title = @"找回密码";
    
    [self.tableView setTableHeaderHeight:100];
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
    NSLog(@"123");
    [self backAction];
}

@end
