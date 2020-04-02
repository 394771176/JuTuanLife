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

@interface JTShipHomeController ()
<
DTTableButtonCellDelegate
, UISearchBarDelegate
>
{
    UIView *_headerSearchView;
    
    UIBarButtonItem *_rightBarItem;
    
    UISearchBar *_searchBar;
    
    JTShipHomeController *_searchResultVC;
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
    
    if (_isSearch) {
        self.noDataMsg = @"没有搜索到结果";
        self.noDataImgTopOff = -30;
    }
    
    _rightBarItem = [WCBarItemUtil barButtonItemWithImage:[UIImage imageNamed:@"jt_ship_add"] target:self action:@selector(addShipAction)];
    
    [self setupTableHeader];
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self reloadTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:JTUserManager_USER_SESSION object:nil];
}

- (void)setupTableHeader
{
    if (_isSearch) {
        _refreshHeadView.hidden = YES;
        return;
    }
    if (!_headerSearchView) {
        UICREATETo(_headerSearchView, UIView, 0, 0, self.view.width, 60, AAW, nil);
        _headerSearchView.backgroundColor = [UIColor clearColor];
        self.tableView.tableHeaderView = _headerSearchView;
        
        _searchBar = [[UISearchBar alloc] initWithFrame:_headerSearchView.bounds];
        [_searchBar setPlaceholder:@"按照姓名或手机号查询"];
        _searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_headerSearchView addSubview:_searchBar];
        _searchBar.delegate = self;
        
        _searchBar.backgroundColor = [UIColor clearColor];
        [_searchBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]]];
//        [_searchBar.searchField setTextAlignment:NSTextAlignmentCenter];
    }
}

- (BOOL)canShowLoadingIndicator
{
    if (_isSearch) {
        return NO;
    }
    return [super canShowLoadingIndicator];
}

- (void)setSearchText:(NSString *)searchText
{
    _searchText = searchText;
    if (self.dataModel) {
        [self.Model setSearchText:searchText];
        [self refresh];
    }
}

- (DTListDataModel *)createDataModel
{
    JTShipListModel *model = [[JTShipListModel alloc] initWithFetchLimit:20 delegate:self];
    model.searchText = _searchText;
    [model loadCache];
    return model;
}

- (BOOL)haveCacheOrData
{
    if (_isSearch && [self.dataModel hasLoadData]) {
        return [super haveCacheOrData];
    }
    return YES;
}

- (WCTableSourceData *)setupTableSourceData
{
    WCTableSourceData *source = [WCTableSourceData new];
    WEAK_SELF
    if ([self.Model teachers].count) {
        WCTableSection *section = [WCTableSection sectionWithItems:[self.Model teachers] cellClass:[JTShipListCell class]];
        section.clickBlock = ^(JTShipItem *data, NSIndexPath *indexPath) {
            [weakSelf clickItem:data];
        };
        section.headerBlock = ^UIView *(NSInteger section) {
            UIView *view = [WCTableSection tableView:self.tableView headerFooterViewWithHeight:50];
            UILabel *label = UICREATELabel(UILabel, 20, 0, view.width - 40, view.height, AAWH, nil, @"16", @"333333", view);
            label.text = [NSString stringWithFormat:@"师傅（%zd人）", [self.Model masterNum]];
            view.backgroundColor = self.view.backgroundColor;
            return view;
        };
        section.headerHeight = 50;
        [source addSectionItem:section];
    }
    
    if (!_isSearch || [self.Model itemCount])
    {
        WCTableSection *section = nil;
        if ([self.Model itemCount]) {
            section = [WCTableSection sectionWithItems:[self.Model data] cellClass:[JTShipListCell class]];
            section.clickBlock = ^(JTShipItem *data, NSIndexPath *indexPath) {
                [weakSelf clickItem:data];
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
                UIView *view = [WCTableSection tableView:self.tableView headerFooterViewWithHeight:50];
                UILabel *label = UICREATELabel(UILabel, 20, 0, view.width - 40, view.height, AAWH, nil, @"16", @"333333", view);
                label.text = [NSString stringWithFormat:@"徒弟（%zd人）", [self.Model apprenticeNum]];
                view.backgroundColor = self.view.backgroundColor;
                return view;
            };
            section.headerHeight = 50;
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

- (void)clickItem:(JTShipItem *)item
{
//    [DTPubUtil callPhoneNumber:item.mobile];
}

#pragma mark - DTTableButtonCellDelegate

- (void)tableButtonCellDidClickAction:(DTTableCustomCell *)cell
{
    [self addShipAction];
}

#pragma mark - UISearchBarDelegate

- (void)didSearchText
{
    NSString *searchText = _searchBar.text;
    if (searchText.length) {
        _searchResultVC.searchText = searchText;
    }
}

- (void)checkResultView
{
    [self cancelSearch];
    NSString *searchText = _searchBar.text;
    if (searchText.length) {
        if (!_searchResultVC) {
            _searchResultVC = [[JTShipHomeController alloc] init];
            _searchResultVC.isSearch = YES;
        }
        if (!_searchResultVC.view.superview) {
            _searchResultVC.view.frame = RECT(0, _headerSearchView.bottom, self.view.width, self.view.height - _headerSearchView.bottom);
            _searchResultVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [self.view addSubview:_searchResultVC.view];
        }
    } else {
        [_searchResultVC.view removeFromSuperview];
    }
}

- (void)cancelSearch
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(didSearchText) object:nil];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self checkResultView];
    [self performSelector:@selector(didSearchText) withObject:nil afterDelay:0.5];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = NO;
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self checkResultView];
    [self didSearchText];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = nil;
    [searchBar resignFirstResponder];
    [self checkResultView];
}

#pragma mark - DTPullRefreshHeadViewDelegate

- (BOOL)pullRefreshTableHeaderDataSourceIsLoading:(DTPushRefreshHeadView *)view
{
    if (_searchBar.isFirstResponder || _isSearch) {
        return YES;
    }
    return [super pullRefreshTableHeaderDataSourceIsLoading:view];
}

@end
