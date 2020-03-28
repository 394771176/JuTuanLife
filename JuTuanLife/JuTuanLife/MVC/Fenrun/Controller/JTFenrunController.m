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
#import "JTFenrunQueryController.h"
#import "JTUserFenrunController.h"

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
    
    [self setRightBarItem:[WCBarItemUtil barButtonItemWithImage:[UIImage imageNamed:@"jt_fenrun_rili"] target:self action:@selector(rightBarAction)]];
}

//- (BOOL)haveCacheOrData
//{
//    return YES;
//}

- (DTLoadMoreCommonCell *)createLoadMoreCell
{
    DTLoadMoreCommonCell *cell = [super createLoadMoreCell];
    [cell setSelectionStyleClear];
    return cell;
}

- (DTListDataModel *)createDataModel
{
    return [self modelForPeriod:_period];
}

- (JTFenRunModel *)modelForPeriod:(JTFenRunPeriod)period
{
    if (!_modelDict) {
        _modelDict = [NSMutableDictionary dictionary];
    }
    JTFenRunModel *model = [_modelDict objectForKey:@(period)];
    if (!model) {
        model = [[JTFenRunModel alloc] initWithFetchLimit:20 delegate:self];
        model.period = period;
        [model loadCache];
        [_modelDict safeSetObject:model forKey:@(period)];
    }
    return model;
}

- (void)showNoDataView
{
    self.noDataViewTopOff = [self.tableView totalHeightToSection:1 target:self];
    [super showNoDataView];
}

- (void)reloadData
{
    if ([self.Model fenrun]) {
        _fenrunCell.itemList = nil;
        _fenrunCell.item = [self.Model fenrun];
    } else {
        _fenrunCell.itemList = self.fenrunForAll;
    }
    if (self.dataModel.itemCount) {
        [self hideNoDataView];
    }
    [super reloadData];
}

- (WCTableSourceData *)setupTableSourceData
{
    WEAK_SELF
    WCTableSourceData *source = [WCTableSourceData new];
    
    {
        if (!_fenrunCell) {
            _fenrunCell = [[JTHomeFenrunCell alloc] init];
            _fenrunCell.delegate = self;
            _fenrunCell.period = _period;
        }
        WCTableSection *section = [WCTableSection sectionWithCells:@[_fenrunCell] click:^(id data, NSIndexPath *indexPath) {
            
        }];
        [source addSectionItem:section];
    }
    
    {
        WCTableSection *section = [WCTableSection sectionWithItems:[self.dataModel data] cellClass:NULL];
        section.cellBlock = ^UITableViewCell *(id data, NSIndexPath *indexPath) {
            KEY(JTShipListCell_key)
            JTShipListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:JTShipListCell_key];
            if (!cell) {
                cell = [[JTShipListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:JTShipListCell_key];
                cell.cellType = JTShipCellTypeFenrun;
            }
            return cell;
        };
        section.clickBlock = ^(JTShipItem *data, NSIndexPath *indexPath) {
            PUSH_VC_WITH(JTUserFenrunController , vc.user = data; vc.period = weakSelf.period;);
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

#pragma mark - action

- (void)rightBarAction
{
    PUSH_VC_WITH(JTFenrunQueryController, vc.period = _period);
}

#pragma mark - DTTabBarViewDelegate

- (void)tabBarViewDidSelectIndex:(NSInteger)index
{
    _period = (JTFenRunPeriod)index;
    JTFenRunModel *model = [self modelForPeriod:_period];
    [self resetDataModel:model];
    [self reloadData];
    if (!model.hasLoadData) {
        [model reload];
    }
}

@end
