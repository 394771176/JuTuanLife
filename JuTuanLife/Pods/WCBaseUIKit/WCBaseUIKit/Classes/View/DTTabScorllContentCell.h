//
//  DTTabScorllContentCell.h
//  DrivingTest
//
//  Created by cheng on 2018/8/7.
//  Copyright © 2018年 eclicks. All rights reserved.
//

#import "DTTableCustomCell.h"
#import "DTScrollTabView.h"
#import "DTControllerListView.h"
#import "DTHorizontalScrollView.h"

@class DTTabScorllContentCell;

@protocol DTTabScorllContentItemViewDelegate;

@protocol DTTabScorllContentCellDelegate <NSObject>

- (id<DTTabScorllContentItemViewDelegate>)tabScorllContentCell:(DTTabScorllContentCell *)cell viewForIndex:(NSInteger)index;

@optional
- (NSString *)tabScorllContentCell:(DTTabScorllContentCell *)cell identifierForIndex:(NSInteger)index;
- (void)tabScorllContentCell:(DTTabScorllContentCell *)cell updateView:(id)view withIndex:(NSInteger)index;

@end

@protocol DTTabScorllContentItemViewDelegate <NSObject>

@required
- (CGFloat)tabScorllContentItemViewContentOffsetY;
- (CGSize)tabScorllContentItemViewContentSize;
- (void)tabScorllContentItemViewSetContentOffsetY:(CGFloat)offsetY;
- (void)tabScorllContentItemViewSetTableViewUnableScroll;

@end

@interface DTTabScorllContentCell : DTTableCustomCell

@property (nonatomic, weak) id<DTTabScorllContentCellDelegate> delegate;
@property (nonatomic, strong) DTScrollTabView *tabBar;
@property (nonatomic, assign) BOOL tabBarAsHeader;//default yes mean 始终悬浮在顶部
@property (nonatomic, strong) DTControllerListView *scrollView;
@property (nonatomic, assign) NSInteger lastIndex;
@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, weak) UITableView *tableView;



- (void)reloadData;
- (void)tableViewDidScroll:(UIScrollView *)scrollView;
- (id)currentContentView;

- (id)currentTitleItem;

- (NSString *)currentTitleString;

@end

@interface DTTabScorllContentItemView : DTHorizontalScrollItemView

@property (nonatomic, strong) id item;

@end
