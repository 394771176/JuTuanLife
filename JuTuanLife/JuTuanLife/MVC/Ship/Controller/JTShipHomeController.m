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
#import "JTShipAddCell.h"

@interface JTShipHomeController () <DTTableButtonCellDelegate> {
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
    JTShipListModel *model = [[JTShipListModel alloc] initWithFetchLimit:20 delegate:self];
    [model loadCache];
    return model;
}

- (BOOL)haveCacheOrData
{
    return YES;
}

- (WCTableSourceData *)setupTableSourceData
{
    WCTableSourceData *source = [WCTableSourceData new];
    
    if ([self.Model teachers].count) {
        WCTableSection *section = [WCTableSection sectionWithItems:[self.Model teachers] cellClass:[JTShipListCell class]];
        section.clickBlock = ^(id data, NSIndexPath *indexPath) {
            
        };
        section.headerBlock = ^UIView *(NSInteger section) {
            UIView *view = [WCTableSection tableView:self.tableView headerFooterViewWithHeight:55];
            UILabel *label = UICREATELabel(UILabel, 20, 0, view.width - 40, view.height, AAWH, nil, @"16", @"333333", view);
            label.text = [NSString stringWithFormat:@"师傅（%zd）", [self.Model masterNum]];
            return view;
        };
        section.headerHeight = 56;
        [source addSectionItem:section];
    }
    
//    if ([self.Model itemCount])
    {
        WCTableSection *section = nil;
        if ([self.Model itemCount]) {
            section = [WCTableSection sectionWithItems:[self.Model data] cellClass:[JTShipListCell class]];
            section.clickBlock = ^(id data, NSIndexPath *indexPath) {
                
            };
        } else {
            section = [WCTableSection sectionWithItems:[NSArray arrayWithObjects:[JTUserManager sharedInstance].user, nil] cellClass:JTShipAddCell.class heightBlock:^CGFloat(id data, NSIndexPath *indexPath) {
                CGFloat height = [self.tableView totalHeightToIndexPath:indexPath target:self];
                height = self.tableView.height - height;
                height = height / (130 + 80) * 130;
                if (height < 130) {
                    height = 130;
                }
                return height;
            }];
            [section setConfigBlock:^(JTShipAddCell* cell, id data, NSIndexPath *indexPath) {
                cell.delegate = self;
            }];
        }
        
        if ([self.Model teachers].count || [self.Model itemCount]) {
            section.headerBlock = ^UIView *(NSInteger section) {
                UIView *view = [WCTableSection tableView:self.tableView headerFooterViewWithHeight:55];
                UILabel *label = UICREATELabel(UILabel, 20, 0, view.width - 40, view.height, AAWH, nil, @"16", @"333333", view);
                label.text = [NSString stringWithFormat:@"徒弟（%zd）", [self.Model apprenticeNum]];
                return view;
            };
            section.headerHeight = 56;
        }
        
        [source addSectionItem:section];
    }
    
    {
        if (self.loadMoreCell) {
            WCTableSection *section = [WCTableSection sectionWithItems:@[self.loadMoreCell] countBlock:^NSInteger(NSInteger section) {
                if ([self.Model canLoadMore]) {
                    return 1;
                } else {
                    return 0;
                }
            }];
            [source addSectionItem:section];
        }
    }
    
//    WCTableSection *section = [WCTableSection sectionWithItems:@[@"", @"", @""] cellClass:[JTShipListCell class]];
//    section.configBlock = ^(JTShipListCell * cell, id data, NSIndexPath *indexPath) {
//        cell.item = (id)[JTUserManager sharedInstance].user;
//    };
//    section.clickBlock = ^(id data, NSIndexPath *indexPath) {
//        
//    };
//    
//    [source addSectionItem:section];
    
    return source;
}

- (void)reloadData
{
    if ([self.Model teachers].count + [self.Model itemCount] <= 0) {
        self.tableView.tableHeaderView = nil;
    } else {
        self.tableView.tableHeaderView = _headerSearchView;
    }
    self.tableSourceData = [self setupTableSourceData];
    [super reloadData];
}

- (void)addShipAction
{
    NSLog(@"add");
    [JTCoreUtil showActionSheetWithTitle:nil message:nil cancelTitle:@"取消" confirmTitle:@"分享到微信好友" destructiveTitle:nil handler:^(UIAlertAction *action) {
        DTShareItem *item = [JTDataManager sharedInstance].shareItem;
        [DTShareUtil shareItem:item channel:DTShareToWXHy];
    }];
}

#pragma mark - DTTableButtonCellDelegate

- (void)tableButtonCellDidClickAction:(DTTableCustomCell *)cell
{
    [self addShipAction];
}

@end
