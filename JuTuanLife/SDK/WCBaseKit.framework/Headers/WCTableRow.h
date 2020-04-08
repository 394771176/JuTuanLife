//
//  WCTableRow.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/7.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WCCategory.h"

typedef CGFloat (^CellHeight)(id data, NSIndexPath *indexPath);
typedef UITableViewCell * (^CellItem)(id data, NSIndexPath *indexPath);

typedef void (^CellConfig)(id cell, id data, NSIndexPath *indexPath);

typedef void (^CellClick)(id data, NSIndexPath *indexPath);

@interface WCTableRow : NSObject<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) id item;
@property (nonatomic, strong) id userInfo;
@property (nonatomic, strong) Class cellClass;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) NSString *reuseCellId;

@property (nonatomic, strong) CellHeight    heightBlock;
@property (nonatomic, strong) CellItem      cellBlock;
@property (nonatomic, strong) CellConfig    configBlock;
@property (nonatomic, strong) CellClick     clickBlock;

//该方法只适用于子类section, 当前类固定返回data
- (id)dataAtIndexPath:(NSIndexPath *)indexPath;

+ (id)rowWithItem:(id)item;
+ (id)rowWithItem:(id)item cellClass:(Class)cellClass;
+ (id)rowWithItem:(id)item cellClass:(Class)cellClass height:(CGFloat)height;
+ (id)rowWithItem:(id)item cellClass:(Class)cellClass heightBlock:(CellHeight)heightBlock;
+ (id)rowWithItem:(id)item cellClass:(Class)cellClass config:(CellConfig)config click:(CellClick)click;
+ (id)rowWithCell:(CellItem)cell config:(CellConfig)config click:(CellClick)click;

+ (id)rowWithCell:(id)item height:(CGFloat)height click:(CellClick)click;
+ (id)rowWithCell:(id)item heightBlock:(CellHeight)heightBlock click:(CellClick)click;
+ (id)rowWithCell:(id)item heightBlock:(CellHeight)heightBlock config:(CellConfig)config click:(CellClick)click;

+ (id)rowWithCellBlock:(CellItem)cellBlock height:(CGFloat)height click:(CellClick)click;
+ (id)rowWithCellBlock:(CellItem)cellBlock heightBlock:(CellHeight)heightBlock click:(CellClick)click;

- (void)setConfigBlock:(CellConfig)configBlock clickBlock:(CellClick)clickBlock;

@end
