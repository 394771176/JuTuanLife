//
//  JTHomeController.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/8.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTHomeController.h"
#import "JTMineHeaderView.h"
#import "JTHomeFenrunCell.h"
#import "JTHomeBusinessCell.h"
#import "JTHomeListModel.h"

@interface JTHomeController () <DTTabBarViewDelegate> {
    JTMineHeaderView *_headerView;
    
    JTHomeFenrunCell *_fenrunCell;
}

@end

@implementation JTHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableHeader];
    
    [self reloadTableView];
}

- (void)setupTableHeader
{
    if (!_headerView) {
        UICREATETo(_headerView, JTMineHeaderView, 0, 0, self.width, 155 + SAFE_BOTTOM_VIEW_HEIGHT, AAW, nil);
        self.tableView.tableHeaderView = _headerView;
    }
}

- (DTListDataModel *)createDataModel
{
    JTHomeListModel *model = [[JTHomeListModel alloc] initWithDelegate:self];
    [model loadCache];
    return model;
}

- (void)reloadTableView
{
    _headerView.user = [JTUserManager sharedInstance].user;
    _fenrunCell.item = [self.Model fenrun];
    self.tableSourceData = [self setupTableSourceData];
    [super reloadTableView];
}

- (WCTableSourceData *)setupTableSourceData
{
    WCTableSourceData *source = [WCTableSourceData new];
    if (!_fenrunCell) {
        _fenrunCell = [[JTHomeFenrunCell alloc] init];
        _fenrunCell.delegate = self;
        _fenrunCell.period = 0;
        [_fenrunCell showArrow:YES];
    }
    
    WCTableRow *row = [WCTableRow rowWithItem:_fenrunCell cellClass:[JTHomeFenrunCell class]];
    row.clickBlock = ^(id data, NSIndexPath *indexPath) {
        NSLog(@"%@", data);
    };
    [source addRowItem:row];
    
    WCTableSection *section = [WCTableSection sectionWithItems:self.dataModel.data cellClass:[JTHomeBusinessCell class]];
    [section setConfigBlock:nil clickBlock:^(JTBusinessItem *data, NSIndexPath *indexPath) {
        [JTLinkUtil openLink:data.entryUrl];
    }];
    section.headerBlock = ^UIView *(NSInteger section) {
        UIView *view = [WCTableSection tableView:self.tableView headerFooterViewWithHeight:50];
        UICREATELabel(UILabel, 20, 0, view.width - 40, view.height, AAH, @"业务产品", @"20", @"333333", view);
        return view;
    };
    section.headerHeight = 50;
    [source addSectionItem:section];
    
    return source;
}

#pragma mark - DTTabBarViewDelegate

- (void)tabBarViewDidSelectIndex:(NSInteger)index
{
    NSLog(@"%zd", index);
}

@end
