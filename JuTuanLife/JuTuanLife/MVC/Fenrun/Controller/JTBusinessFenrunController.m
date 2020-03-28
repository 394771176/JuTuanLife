//
//  JTBusinessFenrunController.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/28.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTBusinessFenrunController.h"
#import "JTBusinessFenrunCell.h"
#import "JTBusinessFenrunHeaderCell.h"

@interface JTBusinessFenrunController () {
    JTBusinessFenrunHeaderCell *_headerCell;
}

@end

@implementation JTBusinessFenrunController

- (void)viewDidLoad {
    _headerCell = [[JTBusinessFenrunHeaderCell alloc] init];

    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"%@业绩", _business.name];
}

- (void)setBusiness:(JTBusinessItem *)business
{
    _business = business;
    _businessCode = business.code;
}

- (DTListDataModel *)createDataModel
{
    JTBusinessFenrunModel *model = [[JTBusinessFenrunModel alloc] initWithFetchLimit:20 delegate:self];
    model.businessCode = _businessCode;
    model.period = _period;
    [model loadCache];
    return model;
}

- (WCTableSourceData *)setupTableSourceData
{
    WEAK_SELF
    WCTableSourceData *source = [WCTableSourceData new];
    
    if (_headerCell) {
        [source addSectionWithCells:@[_headerCell] heightBlock:^CGFloat(id data, NSIndexPath *indexPath) {
            return [JTBusinessFenrunHeaderCell cellHeightWithItem:[self.Model businessFenRunTitle] tableView:weakSelf.tableView];
        } click:nil];
    }
    
    {
        WCTableSection *section = [WCTableSection sectionWithItems:self.dataModel.data cellClass:JTBusinessFenrunCell.class];
        [section setConfigBlock:^(JTBusinessFenrunCell *cell, id data, NSIndexPath *indexPath) {
            cell.titleItem = [weakSelf.Model businessFenRunTitle];
            cell.item = data;
        }];
        [source addSectionItem:section];
    }
    
    return source;
}

- (void)reloadData
{
    _headerCell.titleItem = [self.Model businessFenRunTitle];
    [super reloadData];
}

@end
