//
//  JTUserProtorolsController.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/7.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTUserProtorolsController.h"
#import "JTMineInfoListCell.h"
#import "JTUserProtorolsCell.h"
#import "JTUserProtorolsModel.h"

@interface JTUserProtorolsController ()

@end

@implementation JTUserProtorolsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"协议合同";
}

- (DTListDataModel *)createDataModel
{
    JTUserProtorolsModel *model = [[JTUserProtorolsModel alloc] initWithDelegate:self];
    [model loadCache];
    return model;
}

- (WCTableSourceData *)setupTableSourceData
{
    WCTableSourceData *source = [WCTableSourceData new];
    
    for (NSArray *item in self.dataModel.data) {
        WCTableSection *section = [WCTableSection new];
        {
            WCTableRow *row = [WCTableRow rowWithItem:nil cellClass:DTTableCustomCell.class height:10];
            row.configBlock = ^(id cell, id data, NSIndexPath *indexPath) {
                [cell setSelectionStyleNoneLine];
            };
            [section addItemToDataList:row];
        }
        
        {
            __block NSArray *array = @[@"姓    名：", @"手    机：", @"身份证号："];
            [section addToDataListFromArray:array];
            section.cellClass = JTMineInfoListCell.class;
            section.height = 40;
            [section setConfigBlock:^(JTMineInfoListCell *cell, id data, NSIndexPath *indexPath) {
                JTUser *user = [JTUserManager sharedInstance].user;
                NSInteger index = [array indexOfObject:data];
                switch (index) {
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
                    default:
                        break;
                }
                [cell setTitle:data];
                [cell setSelectionStyleNoneLine];
            }];
        }
        
        {
            WCTableRow *row = [WCTableRow rowWithItem:item cellClass:JTUserProtorolsCell.class];
            [section addItemToDataList:row];
        }
        [section setHeaderHeight:12];
        [source addSectionItem:section];
    }
    
//    [source addRowWithItem:nil cellClass:[DTTableCustomCell class] height:10];
//    [source setLastRowConfigBlock:^(DTTableCustomCell *cell, id data, NSIndexPath *indexPath) {
//        [cell setSelectionStyleNoneLine];
//    } clickBlock:nil];
//    [source addSectionWithItems:@[@"姓 名：", @"手 机：", @"身份证号："] cellClass:[JTMineInfoListCell class]];
//    [source setLastSectionConfigBlock:^(JTMineInfoListCell *cell, id data, NSIndexPath *indexPath) {
//        [cell setTitle:data];
//        [cell setSelectionStyleNoneLine];
//    } clickBlock:nil];
//
//    [source addRowWithItem:nil cellClass:[JTUserProtorolsCell class]];
    
    return source;
}

@end
