//
//  JTShipHomeController.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/8.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTShipHomeController.h"
#import "JTShipListModel.h"
#import "JTShipListCell.h"

@interface JTShipHomeController () {
    UIView *_headerSearchView;
    
    UIBarButtonItem *_rightBarItem;
}

@end

@implementation JTShipHomeController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setRightBarItem:_rightBarItem];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _rightBarItem = [WCBarItemUtil barButtonItemWithImage:[UIImage imageNamed:@"jt_ship_add"] target:self action:@selector(addShipAction)];
    
    [self setupTableHeader];
    
    [self reloadTableView];
}

- (void)setupTableHeader
{
    if (!_headerSearchView) {
        UICREATETo(_headerSearchView, UIView, 0, 0, self.view.width, 60, AAW, nil);
        _headerSearchView.backgroundColor = [UIColor clearColor];
        self.tableView.tableHeaderView = _headerSearchView;
    }
}

- (DTListDataModel *)createDataModel
{
    JTShipListModel *model = [[JTShipListModel alloc] init];
    [model loadCache];
    return model;
}

- (WCTableSourceData *)setupTableSourceData
{
    WCTableSourceData *source = [WCTableSourceData new];
    
    if ([self.Model teachers].count) {
        WCTableSection *section = [WCTableSection sectionWithItems:[self.Model teachers] cellClass:[JTShipListCell class]];
        section.clickBlock = ^(id data, NSIndexPath *indexPath) {
            
        };
    }
    
    if ([self.Model itemCount]) {
        WCTableSection *section = [WCTableSection sectionWithItems:[self.Model data] cellClass:[JTShipListCell class]];
        section.clickBlock = ^(id data, NSIndexPath *indexPath) {
            
        };
    }
    
    WCTableSection *section = [WCTableSection sectionWithItems:@[@"", @"", @""] cellClass:[JTShipListCell class]];
    section.configBlock = ^(JTShipListCell * cell, id data, NSIndexPath *indexPath) {
        cell.item = (id)[JTUserManager sharedInstance].user;
    };
    section.clickBlock = ^(id data, NSIndexPath *indexPath) {
        
    };
    
    [source addSectionItem:section];
    
    return source;
}

- (void)reloadData
{
    [super reloadData];
}

- (void)addShipAction
{
    NSLog(@"add");
    [JTCoreUtil showActionSheetWithTitle:nil message:nil cancelTitle:@"取消" confirmTitle:@"分享到微信好友" destructiveTitle:nil handler:^(UIAlertAction *action) {
        NSLog(@"%@", action.title);
    }];
}

@end
