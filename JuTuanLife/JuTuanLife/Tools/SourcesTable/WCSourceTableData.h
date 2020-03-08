//
//  WCSourceTableUtil.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/7.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WCTableSection.h"
#import "WCTableRow.h"

@interface WCSourceTableData : NSObject <UITableViewDataSource, UITableViewDelegate>

/*
 1围数据：WCTableRow
 或者二围数据：WCTableSection 或 NSArray, Array里是WCTableRow
 不能为其他数据
 */
@property (nonatomic, strong, readonly) NSMutableArray<UITableViewDataSource, UITableViewDelegate> *dataSource;

@property (nonatomic, strong) CellConfig    configBlock;
@property (nonatomic, strong) CellClick     clickBlock;


- (void)clearDataSource;
- (void)resetDataSource:(NSArray *)dataSource;
- (void)resetDataSourceWithItems:(NSArray *)items cellClass:(Class)cellClass;

- (void)addRowWithItem:(id)item cellClass:(Class)cellClass;
- (void)addRowWithItem:(id)item cellClass:(Class)cellClass height:(CGFloat)height;

- (void)addRowToLastSectionWithItem:(id)item cellClass:(Class)cellClass height:(CGFloat)height;

- (void)addSectionWithItems:(NSArray *)items cellClass:(Class)cellClass;
- (void)addSectionWithItems:(NSArray *)items cellClass:(Class)cellClass height:(CGFloat)height;

- (void)addRowItem:(WCTableRow *)row;
- (void)addRowItemToNewSection:(WCTableRow *)row;
- (void)addRowItemToLastSection:(WCTableRow *)row;

- (void)addSectionItem:(WCTableSection *)section;

//- (void)insertRowItem:(WCTableRow *)row inSection:(NSInteger)section;
//- (void)insertSectionItem:(WCTableSection *)row inSection:(NSInteger)section;

- (void)setSection:(NSInteger)section headerHeight:(CGFloat)height;
- (void)setSection:(NSInteger)section footerHeight:(CGFloat)height;
- (void)setSection:(NSInteger)section headerHeight:(CGFloat)height footerHeight:(CGFloat)fheight;
- (void)setLastSectionHeaderHeight:(CGFloat)height footerHeight:(CGFloat)fheight;

- (void)setConfigBlock:(CellConfig)configBlock clickBlock:(CellClick)clickBlock;

@end
