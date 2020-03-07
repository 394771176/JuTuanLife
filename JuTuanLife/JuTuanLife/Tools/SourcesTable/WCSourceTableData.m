//
//  WCSourceTableUtil.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/7.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "WCSourceTableData.h"

@interface WCSourceTableData () {
    NSMutableDictionary *_headerHeightDict;
    NSMutableDictionary *_footerHeightDict;
}

@end

@implementation WCSourceTableData

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataSource = (id)[NSMutableArray array];
    }
    return self;
}

#pragma mark - publich action

- (void)clearDataSource
{
    [_dataSource removeAllObjects];
    [_headerHeightDict removeAllObjects];
    [_footerHeightDict removeAllObjects];
}

- (void)resetDataSource:(NSArray *)dataSource
{
    [self clearDataSource];
    if (dataSource.count) {
        [_dataSource addObjectsFromArray:dataSource];
    }
}

- (void)resetDataSourceWithItems:(NSArray *)items cellClass:(nonnull Class)cellClass
{
    [self clearDataSource];
    [self addSectionWithItems:items cellClass:cellClass];
}

- (void)addRowWithItem:(id)item cellClass:(Class)cellClass
{
    [self addRowWithItem:item cellClass:cellClass height:0];
}

- (void)addRowWithItem:(id)item cellClass:(Class)cellClass height:(CGFloat)height
{
    WCTableRow *row = [WCTableRow rowWithItem:item cellClass:cellClass height:height];
    [self addRowItem:row];
}

- (void)addRowToLastSectionWithItem:(id)item cellClass:(Class)cellClass height:(CGFloat)height
{
    WCTableRow *row = [WCTableRow rowWithItem:item cellClass:cellClass height:height];
    [self addRowItemToLastSection:row];
}

- (void)addSectionWithItems:(NSArray *)items cellClass:(Class)cellClass
{
    [self addSectionWithItems:items cellClass:cellClass height:0];
}

- (void)addSectionWithItems:(NSArray *)items cellClass:(Class)cellClass height:(CGFloat)height
{
    WCTableSection *section = [WCTableSection sectionWithItems:items cellClass:cellClass height:height];
    [self addSectionItem:section];
}

- (void)addRowItem:(WCTableRow *)row
{
    if (![self isSectionData]) {
        [self.dataSource safeAddObject:row];
    } else {
        WCTableSection *section = [WCTableSection sectionWithItems:[NSArray arrayWithObjects:row.data, nil] cellClass:row.cellClass];
        [self addSectionItem:section];
    }
}

- (void)addRowItemToLastSection:(WCTableRow *)row
{
    if (![self isSectionData]) {
        [self.dataSource safeAddObject:row];
    } else {
        id lastData = [self.dataSource lastObject];
        if ([lastData isKindOfClass:NSArray.class]) {
            if ([lastData isKindOfClass:NSMutableArray.class]) {
                [lastData safeAddObject:row];
            } else {
                NSMutableArray *array = [NSMutableArray arrayWithArray:lastData];
                [array safeAddObject:row];
                [self.dataSource replaceObjectAtIndex:self.dataSource.count - 1 withObject:array];
            }
        } else if ([lastData isKindOfClass:WCTableSection.class]) {
            [(WCTableSection *)lastData addItemToDataList:row.data];
        }
    }
}

- (void)addSectionItem:(WCTableSection *)section
{
    if ([self isSectionData] || self.dataSource.count <= 0) {
        [self.dataSource addObject:section];
    } else {
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.dataSource];
        NSMutableArray *sections = [NSMutableArray arrayWithObjects:array, section, nil];
        [self resetDataSource:sections];
    }
}

//- (void)insertRowItem:(WCTableRow *)row inSection:(NSInteger)section;
//- (void)insertSectionItem:(WCTableSection *)row inSection:(NSInteger)section;

- (void)setSection:(NSInteger)section headerHeight:(CGFloat)height
{
    WCTableSection *item = [self dataForSection:section];
    if ([item isKindOfClass:WCTableSection.class]) {
        item.headerHeight = height;
    } else {
        if (!_headerHeightDict) {
            _headerHeightDict = [NSMutableDictionary dictionary];
        }
        [_headerHeightDict safeSetObject:@(height) forKey:@(section)];
    }
}

- (void)setSection:(NSInteger)section footerHeight:(CGFloat)height
{
    WCTableSection *item = [self dataForSection:section];
    if ([item isKindOfClass:WCTableSection.class]) {
        item.footerHeight = height;
    } else {
        if (!_headerHeightDict) {
            _headerHeightDict = [NSMutableDictionary dictionary];
        }
        [_footerHeightDict safeSetObject:@(height) forKey:@(section)];
    }
}

- (void)setSection:(NSInteger)section headerHeight:(CGFloat)height footerHeight:(CGFloat)fheight
{
    [self setSection:section headerHeight:height];
    [self setSection:section footerHeight:fheight];
}

- (void)setLastSectionHeaderHeight:(CGFloat)height footerHeight:(CGFloat)fheight
{
    if ([self isSectionData]) {
        [self setSection:self.dataSource.count - 1 headerHeight:height footerHeight:fheight];
    } else {
        [self setSection:0 headerHeight:height footerHeight:fheight];
    }
}

- (void)setConfigBlock:(CellConfig)configBlock clickBlock:(CellClick)clickBlock
{
    self.configBlock = configBlock;
    self.clickBlock = clickBlock;
}

#pragma mark - tableview Delegate

- (BOOL)isSectionData
{
    if (self.dataSource.count) {
        id item = [self.dataSource firstObject];
        if ([item isKindOfClass:WCTableSection.class] || [item isKindOfClass:NSArray.class]) {
            return YES;
        }
    }
    
    return NO;
}

- (id)dataForSection:(NSInteger)section
{
    if ([self isSectionData]) {
        return [self.dataSource safeObjectAtIndex:section];
    } else {
        return self.dataSource;
    }
}

- (WCTableRow *)itemForIndexPath:(NSIndexPath *)indexPath
{
    id sectionData = [self dataForSection:indexPath.section];
    if ([sectionData isKindOfClass:NSArray.class]) {
        return [sectionData safeObjectAtIndex:indexPath.row];
    } else {
        return sectionData;
    }
}

- (NSInteger)countForSection:(NSInteger)section
{
    id data = [self dataForSection:section];
    if ([data isKindOfClass:NSArray.class]) {
        return [data count];
    } else if ([data isKindOfClass:WCTableSection.class]) {
        return [(WCTableSection *)data count];
    } else {
        return 0;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self isSectionData]) {
        return self.dataSource.count;
    } else if (self.dataSource.count) {
        return 1;
    } else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self countForSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WCTableRow *item = [self itemForIndexPath:indexPath];
    return [item tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WCTableRow *item = [self itemForIndexPath:indexPath];
    UITableViewCell *cell = [item tableView:tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        if (_configBlock) {
            _configBlock(cell, [item dataAtIndexPath:indexPath], indexPath);
        }
        return cell;
    }
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WCTableRow *item = [self itemForIndexPath:indexPath];
    [item tableView:tableView didSelectRowAtIndexPath:indexPath];
    if (_clickBlock) {
        _clickBlock([item dataAtIndexPath:indexPath], indexPath);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    WCTableSection *item = [self dataForSection:section];
    if ([item isKindOfClass:WCTableSection.class]) {
        return [item tableView:tableView heightForHeaderInSection:section];
    } else {
        if ([_headerHeightDict objectForKey:@(section)]) {
            return [[_headerHeightDict objectForKey:@(section)] floatValue];
        }
    }
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([self tableView:tableView heightForHeaderInSection:section] > 0) {
        WCTableSection *item = [self dataForSection:section];
        if ([item isKindOfClass:WCTableSection.class]) {
            return [item tableView:tableView viewForHeaderInSection:section];
        } else {
            return [WCTableSection tableView:tableView headerFooterViewWithHeight:10];
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    WCTableSection *item = [self dataForSection:section];
    if ([item isKindOfClass:WCTableSection.class]) {
        return [item tableView:tableView heightForFooterInSection:section];
    } else if ([_footerHeightDict objectForKey:@(section)]) {
        return [[_footerHeightDict objectForKey:@(section)] floatValue];
    }
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if ([self tableView:tableView heightForFooterInSection:section] > 0) {
        WCTableSection *item = [self dataForSection:section];
        if ([item isKindOfClass:WCTableSection.class]) {
            return [item tableView:tableView viewForFooterInSection:section];
        } else {
            return [WCTableSection tableView:tableView headerFooterViewWithHeight:10];
        }
    }
    return nil;
}

@end
