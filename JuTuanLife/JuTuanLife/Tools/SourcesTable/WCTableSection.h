//
//  WCTableSection.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/7.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WCTableRow.h"

typedef NSInteger (^SectionRowCount)(NSInteger section);
typedef UIView * (^SectionHeaderFooter)(NSInteger section);

@interface WCTableSection : WCTableRow

@property (nonatomic, strong, readonly) NSMutableArray *dataList;

@property (nonatomic, strong) SectionRowCount countBlock;

@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, assign) CGFloat footerHeight;

@property (nonatomic, strong) SectionHeaderFooter headerBlock;
@property (nonatomic, strong) SectionHeaderFooter footerBlock;

- (void)clearDataList;
- (void)resetDataList:(NSArray *)dataList;

//item 可以是数据对象，也可以是WCTableRow，但不能是WCTableSection了
- (void)addItemToDataList:(id)item;
- (void)addToDataListFromArray:(NSArray *)array;

+ (id)sectionWithItems:(NSArray *)items;
+ (id)sectionWithItems:(NSArray *)items countBlock:(SectionRowCount)block;
+ (id)sectionWithItems:(NSArray *)items cellClass:(Class)cellClass;
+ (id)sectionWithItems:(NSArray *)items cellClass:(Class)cellClass height:(CGFloat)height;
+ (id)sectionWithItems:(NSArray *)items cellClass:(Class)cellClass heightBlock:(CellHeight)heightBlock;
+ (id)sectionWithItems:(id)item cellClass:(Class)cellClass config:(CellConfig)config click:(CellClick)click;
+ (id)sectionWithCell:(CellItem)cell config:(CellConfig)config click:(CellClick)click;

+ (id)sectionWithCells:(NSArray *)items click:(CellClick)click;
+ (id)sectionWithCells:(NSArray *)items height:(CGFloat)height click:(CellClick)click;
+ (id)sectionWithCells:(NSArray *)items heightBlock:(CellHeight)heightBlock click:(CellClick)click;

+ (UIView *)tableView:(UITableView *)tableView headerFooterViewWithHeight:(CGFloat)height;

@end
