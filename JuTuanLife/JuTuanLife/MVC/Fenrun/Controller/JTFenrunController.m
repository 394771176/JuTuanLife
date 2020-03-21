//
//  JTFenrunController.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/21.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTFenrunController.h"
#import "JTHomeFenrunCell.h"
#import "JTShipListCell.h"
#import "JTFenRunModel.h"

@interface JTFenrunController () <DTTabBarViewDelegate> {
    JTHomeFenrunCell *_fenrunCell;
    NSMutableDictionary *_modelDict;
}

@end

@implementation JTFenrunController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"分润";
    
    [self.tableView setTableHeaderHeight:10];
}

- (BOOL)haveCacheOrData
{
    return YES;
}

- (DTListDataModel *)createDataModel
{
    return [self modelForPeriod:0];
}

- (JTFenRunModel *)modelForPeriod:(JTFenRunPeriod)period
{
    if (!_modelDict) {
        _modelDict = [NSMutableDictionary dictionary];
    }
    JTFenRunModel *model = [_modelDict objectForKey:@(period)];
    if (!model) {
        model = [[JTFenRunModel alloc] initWithFetchLimit:20 delegate:self];
        [model loadCache];
        [_modelDict safeSetObject:model forKey:@(period)];
    }
    return model;
}

- (void)reloadData
{
    if ([self.Model fenrun]) {
        _fenrunCell.itemList = nil;
        _fenrunCell.item = [self.Model fenrun];
    } else {
        _fenrunCell.itemList = self.fenrunForAll;
    }
    [super reloadData];
}

- (WCTableSourceData *)setupTableSourceData
{
    WCTableSourceData *source = [WCTableSourceData new];
    
    {
        if (!_fenrunCell) {
            _fenrunCell = [[JTHomeFenrunCell alloc] init];
            _fenrunCell.delegate = self;
            _fenrunCell.period = 0;
        }
        WCTableSection *section = [WCTableSection sectionWithCells:@[_fenrunCell] click:^(id data, NSIndexPath *indexPath) {
            
        }];
        [source addSectionItem:section];
    }
    
    {
        WCTableSection *section = [WCTableSection sectionWithItems:[self.dataModel data] cellClass:[JTShipListCell class]];
        section.clickBlock = ^(id data, NSIndexPath *indexPath) {
            
        };
        [source addSectionItem:section];
    }
    
    {
        WCTableSection *section = [WCTableSection sectionWithItems:@[self.loadMoreCell] countBlock:^NSInteger(NSInteger section) {
            return (self.dataModel.canLoadMore ? 1 : 0);
        }];
        [source addSectionItem:section];
    }
    
    return source;
}

#pragma mark - DTTabBarViewDelegate

- (void)tabBarViewDidSelectIndex:(NSInteger)index
{
    JTFenRunModel *model = [self modelForPeriod:index];
    [self resetDataModel:model];
    [self reloadData];
    if (!model.hasLoadData) {
        [model reload];
    }
}

@end
