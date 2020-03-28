//
//  JTUserCenterController.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/22.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTUserCenterController.h"
#import "JTMineHeaderView.h"
#import "JTHomeFenrunCell.h"
#import "JTHomeBusinessCell.h"
#import "JTBusinessFenrunController.h"

@interface JTUserCenterController ()
<
DTTabBarViewDelegate
>
{
    JTMineHeaderView *_headerView;
    
    UIButton *_backBtn;
    
    JTHomeFenrunCell *_fenrunCell;
    
    NSMutableDictionary *_modelDict;
}

@end

@implementation JTUserCenterController

- (BOOL)hiddenNavBar
{
    return YES;
}

- (void)viewDidLoad {
    
    if (_userNo.length <= 0) {
        self.user = [JTUserManager sharedInstance].user;
    }
    
    if (!_fenrunCell) {
        _fenrunCell = [[JTHomeFenrunCell alloc] init];
        _fenrunCell.delegate = self;
        _fenrunCell.period = _period;
        _fenrunCell.cellType = JTFenrunCellTypeBarDate;
    }
    
    [super viewDidLoad];
    self.title = @"个人主页";
    
    [self.tableView setTableHeaderHeight:10 footerHeight:10];
    
    [self setupTableHeader];
    
    [self reloadData];
    
}

- (void)setUser:(JTUser *)user
{
    _userNo = user.userNo;
    _user = user;
}

- (void)setupTableHeader
{
    if (!_headerView) {
        UICREATETo(_headerView, JTMineHeaderView, 0, 0, self.width, 155 + SAFE_BOTTOM_VIEW_HEIGHT, AAW, nil);
        self.tableView.tableHeaderView = _headerView;
        
        UICREATEBtnImgTo(_backBtn, UIButton, 12, STATUSBAR_HEIGHT + 6, 40, 40, AAR, @"", self, @selector(backAction), _headerView);
    }
}

- (DTListDataModel *)createDataModel
{
    return [self modelForPeriod:_period];
}

- (JTUserCenterModel *)modelForPeriod:(JTFenRunPeriod)period
{
    if (!_modelDict) {
        _modelDict = [NSMutableDictionary dictionary];
    }
    JTUserCenterModel *model = [_modelDict objectForKey:@(period)];
    if (!model) {
        model = [[JTUserCenterModel alloc] initWithDelegate:self];
        model.period = _period;
        model.userNo = _userNo;
        [model loadCache];
        [_modelDict safeSetObject:model forKey:@(period)];
    }
    return model;
}

- (WCTableSourceData *)setupTableSourceData
{
    WEAK_SELF
    WCTableSourceData *source = [WCTableSourceData new];
    
    if (_fenrunCell) {
        [source addSectionWithCells:@[_fenrunCell] heightBlock:^CGFloat(id data, NSIndexPath *indexPath) {
            return [JTHomeFenrunCell cellHeightWithItem:nil tableView:weakSelf.tableView type:JTFenrunCellTypeBarDate];
        } click:^(id data, NSIndexPath *indexPath) {
            
        }];
    }
    
    {
        [source addSectionWithItems:self.dataModel.data cellClass:[JTHomeBusinessCell class]];
        [source setLastSectionConfigBlock:nil clickBlock:^(JTFenRunOverItem *data, NSIndexPath *indexPath) {
            PUSH_VC_WITH(JTBusinessFenrunController, vc.business = data.business; vc.period = weakSelf.period);
        }];
        [source setLastSectionHeaderHeight:12 footerHeight:0];
    }
    
    
    return source;
}

- (void)reloadData
{
    _headerView.user = _user;
    _fenrunCell.item = [self.Model fenrun];
    [super reloadData];
}

#pragma mark - DTTabBarViewDelegate

- (void)tabBarViewDidSelectIndex:(NSInteger)index
{
    _period = (JTFenRunPeriod)index;
    JTUserCenterModel *model = [self modelForPeriod:_period];
    [self resetDataModel:model];
    [self reloadData];
    if (!model.hasLoadData) {
        [model reload];
    }
}

@end
