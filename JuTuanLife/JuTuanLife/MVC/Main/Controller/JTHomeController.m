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
#import "JTFenrunController.h"
#import "JTMessageBtn.h"

@interface JTHomeController () <DTTabBarViewDelegate> {
    JTMineHeaderView *_headerView;
    
    JTHomeFenrunCell *_fenrunCell;
    
    JTMessageBtn *_messageBtn;
    BOOL _hadSetDefaultForNetData;
}

@end

@implementation JTHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _refreshHeadView.minOffsetY = 20 + 60 + SAFE_BOTTOM_VIEW_HEIGHT;
    
    [self setupTableHeader];
    
    [self reloadData];
}

- (void)setupTableHeader
{
    if (!_headerView) {
        UICREATETo(_headerView, JTMineHeaderView, 0, 0, self.width, 155 + SAFE_BOTTOM_VIEW_HEIGHT, AAW, nil);
        self.tableView.tableHeaderView = _headerView;
        
        UICREATEBtnImgTo(_messageBtn, JTMessageBtn, _headerView.width - 40 - 15, _headerView.headerView.top - 5, 40, 40, AAL, nil, nil, nil, _headerView);
        [_messageBtn updateMessageCount];
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
    if (_fenrunCell.itemList == nil || _hadSetDefaultForNetData == NO) {
        _fenrunCell.period = [self.Model defaultStat];
    }
    
    if ([self.Model hasLoadData] && [self.dataModel.result success]) {
        _hadSetDefaultForNetData = YES;
    }
    _fenrunCell.itemList = [self.Model fenrunForAll];
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
    
    WEAK_SELF
    WCTableRow *row = [WCTableRow rowWithItem:_fenrunCell cellClass:[JTHomeFenrunCell class]];
    row.clickBlock = ^(id data, NSIndexPath *indexPath) {
        STRONG_SELF
        PUSH_VC_WITH(JTFenrunController, vc.fenrunForAll = [self.Model fenrunForAll]; vc.period = self ->_fenrunCell.period);
    };
    [source addRowItem:row];
    
    WCTableSection *section = [WCTableSection sectionWithItems:self.dataModel.data cellClass:[JTHomeBusinessCell class]];
    [section setConfigBlock:nil clickBlock:^(JTBusinessItem *data, NSIndexPath *indexPath) {
        [JTLinkUtil openWithLink:data.entryUrl];
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

#pragma mark - action

#pragma mark - DTTabBarViewDelegate

- (void)tabBarViewDidSelectIndex:(NSInteger)index
{
    NSLog(@"%zd", index);
}

@end
