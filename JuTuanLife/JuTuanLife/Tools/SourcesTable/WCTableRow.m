//
//  WCTableRow.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/7.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "WCTableRow.h"

@interface WCTableRow () {
    
}

+ (CGFloat)cellHeightWithItem:(id)item tableView:(UITableView *)tableView;

@end

@implementation WCTableRow

+ (id)rowWithItem:(id)item
{
    return [self rowWithItem:item cellClass:NULL];
}

+ (id)rowWithItem:(id)item cellClass:(Class)cellClass
{
    return [self rowWithItem:item cellClass:cellClass height:0];
}

+ (id)rowWithItem:(id)item cellClass:(Class)cellClass height:(CGFloat)height
{
    WCTableRow *row = [WCTableRow new];
    row.item = item;
    row.cellClass = cellClass;
    row.height = height;
    return row;
}

+ (id)rowWithItem:(id)item cellClass:(Class)cellClass heightBlock:(CellHeight)heightBlock
{
    WCTableRow *row = [WCTableRow rowWithItem:item cellClass:cellClass height:0];
    row.heightBlock = heightBlock;
    return row;
}

+ (id)rowWithItem:(id)item cellClass:(Class)cellClass config:(CellConfig)config click:(CellClick)click
{
    WCTableRow *row = [WCTableRow rowWithItem:item cellClass:cellClass height:0];
    [row setConfigBlock:config clickBlock:click];
    return row;
}

+ (id)rowWithCell:(CellItem)cell config:(CellConfig)config click:(CellClick)click
{
    WCTableRow *row = [WCTableRow new];
    row.cellBlock = cell;
    [row setConfigBlock:config clickBlock:click];
    return row;
}

//+ (id)rowWithCell:(id)item config:(CellConfig)config click:(CellClick)click
//{
//    WCTableRow *row = [WCTableRow rowWithItem:item];
//    [row setConfigBlock:config clickBlock:click];
//    return row;
//}

+ (id)rowWithCell:(id)item height:(CGFloat)height click:(CellClick)click
{
    WCTableRow *row = [WCTableRow rowWithItem:item cellClass:NULL height:height];
    [row setConfigBlock:nil clickBlock:click];
    return row;
}

+ (id)rowWithCell:(id)item heightBlock:(CellHeight)heightBlock click:(CellClick)click
{
    WCTableRow *row = [WCTableRow rowWithItem:item cellClass:NULL heightBlock:heightBlock];
    [row setConfigBlock:nil clickBlock:click];
    return row;
}

+ (id)rowWithCell:(id)item heightBlock:(CellHeight)heightBlock config:(CellConfig)config click:(CellClick)click
{
    WCTableRow *row = [WCTableRow rowWithItem:item cellClass:NULL heightBlock:heightBlock];
    [row setConfigBlock:config clickBlock:click];
    return row;
}

+ (id)rowWithCellBlock:(CellItem)cellBlock height:(CGFloat)height click:(CellClick)click
{
    WCTableRow *row = [WCTableRow rowWithItem:nil cellClass:NULL height:height];
    row.cellBlock = cellBlock;
    row.clickBlock = click;
    return row;
}

+ (id)rowWithCellBlock:(CellItem)cellBlock heightBlock:(CellHeight)heightBlock click:(CellClick)click
{
    WCTableRow *row = [WCTableRow rowWithItem:nil cellClass:NULL heightBlock:heightBlock];
    row.cellBlock = cellBlock;
    row.clickBlock = click;
    return row;
}

+ (CGFloat)cellHeightWithItem:(id)item tableView:(UITableView *)tableView
{
    return 0;
}

- (void)setConfigBlock:(CellConfig)configBlock clickBlock:(CellClick)clickBlock
{
    _configBlock = configBlock;
    _clickBlock = clickBlock;
}

- (id)dataAtIndexPath:(NSIndexPath *)indexPath
{
    return self.item;
}

// MARK: - UITableViewDelegate -

//只是消除警告，row 不负责该方法的返回
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_heightBlock) {
        return _heightBlock(self.item, indexPath);
    } else if (_height > 0) {
        return _height;
    } else if (_cellClass && [_cellClass respondsToSelector:@selector(cellHeightWithItem:tableView:)]) {
        return [[_cellClass class] cellHeightWithItem:self.item tableView:tableView];
    } else if (_cellBlock) {
        id cell = _cellBlock(self.item, indexPath);
        if ([[cell class] respondsToSelector:@selector(cellHeightWithItem:tableView:)]) {
            return [[cell class] cellHeightWithItem:self.item tableView:tableView];
        }
    } else if ([self.item isKindOfClass:UITableViewCell.class]) {
        id cell = self.item;
        if ([[cell class] respondsToSelector:@selector(cellHeightWithItem:tableView:)]) {
            return [[cell class] cellHeightWithItem:self.item tableView:tableView];
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.item isKindOfClass:UITableViewCell.class]) {
        return self.item;
    }
    UITableViewCell *cell = nil;
    if (_cellBlock) {
        cell = _cellBlock(self.item, indexPath);
    } else if (_cellClass) {
        if (!self.reuseCellId) {
            self.reuseCellId = NSStringFromClass([self.cellClass class]);
        }
        cell = [tableView dequeueReusableCellWithIdentifier:self.reuseCellId];
        if (!cell) {
            cell = [(UITableViewCell *)[_cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.reuseCellId];
        }
    }
    
    if (cell) {
        if (_configBlock) {
            _configBlock(cell, self.item, indexPath);
        } else {
            if ([cell respondsToSelector:@selector(setItem:)]) {
                //只是借助WCTableRow为替身，方便调setItem方法，而没有警告
                [(WCTableRow *)cell setItem:self.item];
            }
            if ([cell respondsToSelector:@selector(setUserInfo:)]) {
                [(WCTableRow *)cell setUserInfo:self.userInfo];
            }
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.clickBlock) {
        self.clickBlock(self.item, indexPath);
    }
}

@end
