//
//  WCTableSection.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/7.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "WCTableSection.h"

@implementation WCTableSection

+ (id)sectionWithItems:(NSArray *)items
{
    return [self sectionWithItems:items cellClass:NULL];
}

+ (id)sectionWithItems:(NSArray *)items countBlock:(SectionRowCount)block
{
    WCTableSection *section = [WCTableSection sectionWithItems:items];
    section.countBlock = block;
    return section;
}

+ (id)sectionWithItems:(NSArray *)items cellClass:(Class)cellClass
{
    return [self sectionWithItems:items cellClass:cellClass height:0];
}

+ (id)sectionWithItems:(NSArray *)items cellClass:(Class)cellClass height:(CGFloat)height
{
    WCTableSection *section = [WCTableSection new];
    section.cellClass = cellClass;
    section.height = height;
    [section resetDataList:items];
    return section;
}

+ (id)sectionWithItems:(NSArray *)items cellClass:(Class)cellClass heightBlock:(CellHeight)heightBlock
{
    WCTableSection *section = [WCTableSection sectionWithItems:items cellClass:cellClass height:0];
    section.heightBlock = heightBlock;
    return section;
}

+ (id)sectionWithItems:(id)items cellClass:(Class)cellClass config:(CellConfig)config click:(CellClick)click
{
    WCTableSection *section = [WCTableSection sectionWithItems:items cellClass:cellClass height:0];
    [section setConfigBlock:config clickBlock:click];
    return section;
}

+ (id)sectionWithCell:(CellItem)cell config:(CellConfig)config click:(CellClick)click
{
    WCTableSection *section = [WCTableSection new];
    section.cellBlock = cell;
    [section setConfigBlock:config clickBlock:click];
    return section;
}

+ (id)sectionWithCells:(NSArray *)items click:(CellClick)click
{
    return [self sectionWithCells:items height:0 click:click];
}

+ (id)sectionWithCells:(NSArray *)items height:(CGFloat)height click:(CellClick)click
{
    WCTableSection *section = [WCTableSection sectionWithItems:items cellClass:NULL height:height];
    section.clickBlock = click;
    return section;
}

+ (id)sectionWithCells:(NSArray *)items heightBlock:(CellHeight)heightBlock click:(CellClick)click
{
    WCTableSection *section = [WCTableSection sectionWithItems:items cellClass:NULL height:0];
    section.heightBlock = heightBlock;
    section.clickBlock = click;
    return section;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataList = [NSMutableArray array];
    }
    return self;
}

- (void)clearDataList
{
    [_dataList removeAllObjects];
}

- (void)resetDataList:(NSArray *)dataList
{
    [self clearDataList];
    if (dataList.count) {
        [_dataList addObjectsFromArray:dataList];
    }
}

- (void)addItemToDataList:(id)item
{
    [_dataList safeAddObject:item];
}

- (void)addToDataListFromArray:(NSArray *)array
{
    [_dataList safeAddObjectsFromArray:array];
}

- (id)dataAtIndexPath:(NSIndexPath *)indexPath
{
    id data = [self.dataList safeObjectAtIndex:indexPath.row];
    if ([data isKindOfClass:WCTableRow.class]) {
        return [data dataAtIndexPath:indexPath];
    } else {
        return data;
    }
}

// MARK: - UITableViewDelegate -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_countBlock) {
        return _countBlock(section);
    }
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id data = [self.dataList safeObjectAtIndex:indexPath.row];
    if ([data isKindOfClass:WCTableRow.class]) {
        return [data tableView:tableView heightForRowAtIndexPath:indexPath];
    } else {
        self.item = data;
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id data = [self.dataList safeObjectAtIndex:indexPath.row];
    if ([data isKindOfClass:WCTableRow.class]) {
        return [data tableView:tableView cellForRowAtIndexPath:indexPath];
    } else {
        self.item = data;
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id data = [self.dataList safeObjectAtIndex:indexPath.row];
    if ([data isKindOfClass:WCTableRow.class]) {
        if ([data clickBlock]) {
            [data tableView:tableView didSelectRowAtIndexPath:indexPath];
            return;
        } else {
            self.item = [(WCTableRow *)data item];
        }
    } else {
        self.item = data;
    }
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.headerHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.headerHeight > 0) {
        if (self.headerBlock) {
            return self.headerBlock(section);
        } else {
            return [self.class tableView:tableView headerFooterViewWithHeight:self.headerHeight];
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return self.footerHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (self.footerHeight > 0) {
        if (self.footerBlock) {
            return self.footerBlock(section);
        } else {
            return [self.class tableView:tableView headerFooterViewWithHeight:self.footerHeight];
        }
    }
    return nil;
}

+ (UIView *)tableView:(UITableView *)tableView headerFooterViewWithHeight:(CGFloat)height
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, height)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

@end
