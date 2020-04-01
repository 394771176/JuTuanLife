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
<
UIImagePickerControllerDelegate
, JTUserInfoEditControllerDelegate>
{
    JTMineInfoAvatarCell *_avatarCell;
    JTMineInfoListCell *_addressCell;
}

@end

@implementation JTUserInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"身份信息";
}

- (WCTableSourceData *)setupTableSourceData
{
    WEAK_SELF
    JTUser *user = [JTUserManager sharedInstance].user;
    WCTableSourceData *source = [WCTableSourceData new];
    [source addRowWithItem:user cellClass:[JTMineInfoAvatarCell class]];
    [source setLastRowConfigBlock:^(id cell, id data, NSIndexPath *indexPath) {
        if (weakSelf) {
            self->_avatarCell = cell;
            self->_avatarCell.item = data;
        }
    } clickBlock:^(id data, NSIndexPath *indexPath) {
        [JTCoreUtil showAlertWithTitle:nil message:nil style:UIAlertControllerStyleActionSheet handler:^(UIAlertAction *action) {
            UIImagePickerControllerSourceType type;
            if ([action.title isEqualToString:@"拍照"]) {
                type = UIImagePickerControllerSourceTypeCamera;
            } else {
                type = UIImagePickerControllerSourceTypePhotoLibrary;
            }
            [DTImagePickerController showInViewController:self sourceType:type config:^(DTImagePickerController *picker) {
                picker.allowsEditing = YES;
            }];
        } cancelTitle:@"取消" destructiveTitle:nil confirmTitle:@"拍照", @"相册", nil];
    }];
    [source setLastSectionHeaderHeight:12 footerHeight:0];
    
    {
        WEAK_SELF
        WCTableSection *section = [WCTableSection sectionWithItems:@[@"姓        名：", @"手        机：", @"身份证号：", @"拓业城市：", @"聚  推  号："] cellClass:[JTMineInfoListCell class]];
        section.configBlock = ^(JTMineInfoListCell *cell, NSString *data, NSIndexPath *indexPath) {
            cell.title = data;
            if (cell.isShowArrow) {
                
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
                    [cell setContent:[user bizCityName]];
                }
                    break;
                case 4:
                {
                    [cell setContent:[user jobNo]];
                }
                    break;
                default:
                    break;
            }
        };
        
//        WCTableRow *row = [WCTableRow rowWithItem:nil cellClass:[DTTableCustomCell class] height:30];
//        row.configBlock = ^(DTTableCustomCell *cell, id data, NSIndexPath *indexPath) {
//            [cell setSelectionStyleNoneLine];
//        };
//        [section addItemToDataList:row];
        section.headerHeight = 12;
        [source addSectionItem:section];
    }
    
    {
        WCTableSection *section = [WCTableSection sectionWithItems:@[@"收货地址："] cellClass:[JTMineInfoListCell class]];
        section.reuseCellId = @"JTMineInfoListCell_address";
        section.heightBlock = ^CGFloat(id data, NSIndexPath *indexPath) {
            CGFloat height = [JTMineInfoListCell cellHeightWithItem:user.shippingAddress tableView:weakSelf.tableView] + 12;
            if (height < 55) {
                height = 55;
            }
            return height;
        };
        [section setConfigBlock:^(JTMineInfoListCell *cell, id data, NSIndexPath *indexPath) {
            cell.title = data;
            if (user.shippingAddress.length) {
                [cell setContent:user.shippingAddress];
                [cell setContentColor:[UIColor colorWithString:@"333333"]];
                [cell.contentLabel setTextAlignment:NSTextAlignmentLeft];
            } else {
                [cell setContent:@"请填写收货地址"];
                [cell.contentLabel setTextAlignment:NSTextAlignmentRight];
                [cell setContentColor:[UIColor colorWithString:@"999999"]];
            }
            
            [cell setLineStyle:DTCellLineNone];
            [cell showArrow:YES];
            [cell setSelectionStyleDefault];
            if (weakSelf) {
                self -> _addressCell = cell;
            }
        } clickBlock:^(id data, NSIndexPath *indexPath) {
            PUSH_VC_WITH(JTUserInfoEditController, {
                vc.delegate = self;
                vc.title = @"收货地址";
                vc.placeholder = @"请输入收货地址";
                vc.orignalText = user.shippingAddress;
            })
        }];
        section.headerHeight = 12;
        [source addSectionItem:section];
    }
    
    {
        WCTableRow *row = [WCTableRow rowWithItem:user cellClass:[JTMineYaJinCell class]];
        [source addRowItemToNewSection:row];
        [source setLastSectionHeaderHeight:12 footerHeight:0];
    }
    
    return source;
}

#pragma mark - JTUserInfoEditControllerDelegate

- (void)userInfoEditController:(JTUserInfoEditController *)controller changeText:(NSString *)text
{
    WEAK_SELF
    [JTService async:[JTUserRequest update_user_infoAvatar:nil address:text] finish:^(WCDataResult *result) {
        if (weakSelf) {
            if (result.success) {
                [JTUserManager sharedInstance].user.shippingAddress = text;
                [self->_addressCell setContent:text];
                [self reloadTableView];
                [[JTUserManager sharedInstance] refreshUserInfo:nil];
            } else {
                [DTPubUtil showHUDErrorHintInWindow:result.msg];
            }
        }
    }];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    image = [image resizeWithMaxSize:CGSizeMake(640.0f, 640.0f)];
    
    WEAK_SELF
    [JTService async:[JTRequest uploadImage:image] finish:^(WCDataResult *result) {
        if (result.success && [NSDictionary validDict:result.data]) {
            NSString *path = [result.data objectForKey:@"path"];
            [JTService async:[JTUserRequest update_user_infoAvatar:path address:nil] finish:^(WCDataResult *result) {
                if (weakSelf) {
                    if (result.success) {
                        [self->_avatarCell setAvatar:image];
                        [[JTUserManager sharedInstance] refreshUserInfo:nil];
                    } else {
                        [DTPubUtil showHUDErrorHintInWindow:result.msg];
                    }
                }
            }];
        } else {
            [DTPubUtil showHUDErrorHintInWindow:result.msg];
        }
    }];
}

@end
