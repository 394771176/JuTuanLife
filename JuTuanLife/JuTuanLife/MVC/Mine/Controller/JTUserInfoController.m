//
//  JTUserInfoController.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/7.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTUserInfoController.h"
#import "JTMineInfoListCell.h"
#import "JTMineInfoAvatarCell.h"
#import "JTMineYaJinCell.h"
#import "JTUserInfoEditController.h"

@interface JTUserInfoController ()

@end

@implementation JTUserInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"身份信息";
}

- (WCTableSourceData *)setupTableSourceData
{
    JTUser *user = [JTUserManager sharedInstance].user;
    WCTableSourceData *source = [WCTableSourceData new];
    [source addRowWithItem:user cellClass:[JTMineInfoAvatarCell class]];
    [source setLastSectionHeaderHeight:12 footerHeight:0];
    
    {
        WEAK_SELF
        __weak JTUser *user = [JTUserManager sharedInstance].user;
        WCTableSection *section = [WCTableSection sectionWithItems:@[@"姓 名：", @"手 机：", @"身份证号：", @"拓业城市：", @"收货地址："] cellClass:[JTMineInfoListCell class]];
        section.heightBlock = ^CGFloat(id data, NSIndexPath *indexPath) {
            if (indexPath.row == 4) {
                return [JTMineInfoListCell cellHeightWithItem:user.address tableView:weakSelf.tableView];
            } else {
                return [JTMineInfoListCell cellHeightWithItem:nil tableView:weakSelf.tableView];
            }
        };
        section.configBlock = ^(JTMineInfoListCell *cell, NSString *data, NSIndexPath *indexPath) {
            cell.title = data;
            [cell showArrow:indexPath.row > 2];
            if (cell.isShowArrow) {
                [cell setLineStyle:DTCellLineCustom];
                [cell setSelectionStyleDefault];
            } else {
                [cell setSelectionStyleNoneLine];
            }
            switch (indexPath.row) {
                case 0:
                {
                    [cell setContent:user.name];
                }
                    break;
                case 1:
                {
                    [cell setContent:[user phoneCipher]];
                }
                    break;
                case 2:
                {
                    [cell setContent:[user IDNumCipher]];
                }
                    break;
                case 3:
                {
                    [cell setContent:[user city]];
                }
                    break;
                case 4:
                {
                    [cell setContent:[user address]];
                }
                    break;
                default:
                    break;
            }
        };
        section.clickBlock = ^(id data, NSIndexPath *indexPath) {
            if (indexPath.row > 2) {
                PUSH_VC(JTUserInfoEditController)
            }
        };
        
        WCTableRow *row = [WCTableRow rowWithItem:nil cellClass:[DTTableCustomCell class] height:30];
        row.configBlock = ^(DTTableCustomCell *cell, id data, NSIndexPath *indexPath) {
            [cell setSelectionStyleNoneLine];
        };
        [section addItemToDataList:row];
        [source addSectionItem:section];
        [source setLastSectionHeaderHeight:12 footerHeight:0];
    }
    
    {
        [source addRowWithItem:nil cellClass:[JTMineYaJinCell class]];
        [source setLastSectionHeaderHeight:12 footerHeight:0];
    }
    
    return source;
}


@end
