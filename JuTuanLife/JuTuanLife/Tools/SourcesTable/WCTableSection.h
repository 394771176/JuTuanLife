//
//  WCTableSection.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/7.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WCTableRow.h"

typedef UIView * (^SectionHeaderFooter)(NSInteger section);

@interface WCTableSection : WCTableRow

@property (nonatomic, strong, readonly) NSMutableArray *dataList;

@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, assign) CGFloat footerHeight;

@property (nonatomic, strong) SectionHeaderFooter headerBlock;
@property (nonatomic, strong) SectionHeaderFooter footerBlock;

- (NSInteger)count;

- (void)clearDataList;
- (void)resetDataList:(NSArray *)dataList;

- (void)addItemToDataList:(id)item;

+ (id)sectionWithItems:(NSArray *)items;
+ (id)sectionWithItems:(NSArray *)items cellClass:(Class)cellClass;
+ (id)sectionWithItems:(NSArray *)items cellClass:(Class)cellClass height:(CGFloat)height;

+ (UIView *)tableView:(UITableView *)tableView headerFooterViewWithHeight:(CGFloat)height;

@end
