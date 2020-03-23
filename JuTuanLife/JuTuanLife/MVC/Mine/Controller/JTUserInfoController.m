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

@interface JTUserInfoController () <UIImagePickerControllerDelegate>
{
    JTMineInfoAvatarCell *_avatarCell;
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
//            STRONG_SELF
            self->_avatarCell = cell;
            if (APP_DEBUG) {
                [self -> _avatarCell setAvatar:[UIImage imageNamed:@"user_home_avatar"]];
            }
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
                    [cell setContent:[user bizCityName]];
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
            if (indexPath.row == 0) {
                
            } else if (indexPath.row > 2) {
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
    
    [_avatarCell setAvatar:image];
}

@end
