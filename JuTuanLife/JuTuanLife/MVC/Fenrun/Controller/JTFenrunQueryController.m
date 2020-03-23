//
//  JTFenrunQueryController.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/23.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTFenrunQueryController.h"
#import "JTHomeFenrunCell.h"
#import "JTShipListCell.h"
#import "JTFenRunModel.h"
#import "JTUserCenterController.h"

@interface JTFenrunQueryController ()
<DTTabBarViewDelegate>
{
    JTHomeFenrunCell *_fenrunCell;
    NSMutableDictionary *_modelDict;
}

@end

@implementation JTFenrunQueryController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _period = JTFenRunPeriodFixDay;
    }
    return self;
}

- (void)setPeriod:(JTFenRunPeriod)period
{
    if (period == JTFenRunPeriodYear) {
        _period = JTFenRunPeriodFixYear;
    } else if (period == JTFenRunPeriodMonth || period == JTFenRunPeriodQuarter) {
        _period = JTFenRunPeriodFixMonth;
    } else {
        _period = JTFenRunPeriodFixDay;
    }
}

- (void)viewDidLoad {
    
    self.autoCreateModel = NO;
    
    [super viewDidLoad];
    self.title = @"分润查询";
    
    [self reloadData];
    
    if (APP_DEBUG) {
        self.noDataMsg = @"敬请期待，马上就做";
        [self showNoDataView];
    }
}

- (void)showNoDataView
{
    self.noDataViewTopOff = [self.tableView totalHeightToSection:1 target:self];
    [super showNoDataView];
}

- (void)reloadData
{
    _fenrunCell.item = [self.Model fenrun];
    if (self.dataModel.itemCount) {
        [self hideNoDataView];
    }
    [super reloadData];
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
        //查询没有缓存
//        [model loadCache];
        [_modelDict safeSetObject:model forKey:@(period)];
    }
    return model;
}

- (WCTableSourceData *)setupTableSourceData
{
//    WEAK_SELF
    WCTableSourceData *source = [WCTableSourceData new];
    
    {
        if (!_fenrunCell) {
            _fenrunCell = [[JTHomeFenrunCell alloc] init];
            _fenrunCell.delegate = self;
            _fenrunCell.onlyFixPeriod = YES;
            _fenrunCell.period = _period;
        }
        WCTableSection *section = [WCTableSection sectionWithCells:@[_fenrunCell] click:^(id data, NSIndexPath *indexPath) {
            
        }];
        
        section.heightBlock = ^CGFloat(id data, NSIndexPath *indexPath) {
            return [JTHomeFenrunCell cellHeightWithItem:[self.Model fenrun] tableView:self.tableView onlyFixPeriod:YES];
        };
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
            PUSH_VC_WITH(JTUserCenterController , vc.userNo = data.userNo);
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

- (void)didQueryAction
{
    [self.Model setSelectedDate:@"2020-03"];
    [self refresh];
}

- (void)didCancelQuery
{
    if (![self haveCacheOrData]) {
        [self backAction];
    }
}

#pragma mark - DTTabBarViewDelegate

- (void)tabBarViewDidSelectIndex:(NSInteger)index
{
    _period = (JTFenRunPeriod)(index + JTFenRunPeriodFixDay);
    JTFenRunModel *model = [self modelForPeriod:_period];
    [self resetDataModel:model];
    [self reloadData];
    
    if (APP_DEBUG) {
        [self didQueryAction];
    }
}

@end
