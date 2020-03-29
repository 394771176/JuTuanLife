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
    
    [source addRowWithItem:nil cellClass:[DTTableCustomCell class] height:10];
    [source setLastRowConfigBlock:^(DTTableCustomCell *cell, id data, NSIndexPath *indexPath) {
        [cell setSelectionStyleNoneLine];
    } clickBlock:nil];
    [source setLastSectionHeaderHeight:12 footerHeight:0];
    
    [source addSectionWithItems:@[@"姓 名：", @"手 机：", @"身份证号："] cellClass:[JTMineInfoListCell class]];
    [source setLastSectionConfigBlock:^(JTMineInfoListCell *cell, id data, NSIndexPath *indexPath) {
        [cell setTitle:data];
        [cell setSelectionStyleNoneLine];
    } clickBlock:nil];
    
    [source addRowWithItem:nil cellClass:[JTUserProtorolsCell class]];
    
    return source;
}

@end
