//
//  DTHttpRefreshTableController.m
//  DrivingTest
//
//  Created by Kent on 14-7-4.
//  Copyright (c) 2014年 eclicks. All rights reserved.
//

#import "DTHttpRefreshTableController.h"
#import "WCUICommon.h"

@interface DTHttpRefreshTableController () {
    BOOL _isPullRefresh;
    BOOL _hadScrollTop;
}

@end

@implementation DTHttpRefreshTableController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)dealloc
{
    _refreshHeadView.delegate = nil;
    _refreshHeadView = nil;
}

- (void)viewDidLoad
{
//    _refreshHeadView = [[DTPushRefreshHeadView alloc] initWithFrame:CGRectMake(0, -60, self.view.width, 60)];
    _refreshHeadView = [[DTTableRefreshHeaderView alloc] initWithFrame:CGRectMake(0, -60, self.view.width, 60)];
    _refreshHeadView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _refreshHeadView.delegate = self;
    
    [super viewDidLoad];

    [self.tableView addSubview:_refreshHeadView];
}

- (void)startLoadingIndicator
{
    if (_isPullRefresh) return;
    [super startLoadingIndicator];
}

- (void)didPullRefresh
{
    [_refreshHeadView didPullRefreshScrollView:self.tableView];
}

- (void)scrollToTop:(BOOL)animated
{
    if (_hadScrollTop && self.tableView.contentOffset.y<1) {
        _hadScrollTop = NO;
        [self performSelector:@selector(didPullRefresh) withObject:nil afterDelay:0.1];
    } else {
        _hadScrollTop = YES;
        [super scrollToTop:animated];
        [self performSelector:@selector(unSetHadScrollTop) withObject:nil afterDelay:0.3];
    }
}

- (void)unSetHadScrollTop
{
    _hadScrollTop = NO;
}

#pragma mark - VGEDataModelDelegate

- (void)dataModelDidSuccess:(VGEDataModel *)model
{
    if (![DTReachabilityUtil sharedInstance].isReachable||!_isPullRefresh) {
        _refreshHeadView.needDelay = NO;
        [super dataModelDidSuccess:model];
    } else {
        _refreshHeadView.needDelay = YES;
        _refreshHeadView.finishBlock = ^{
            [super dataModelDidSuccess:model];
        };
    }
}

- (void)dataModelDidFail:(VGEDataModel *)model
{
    _refreshHeadView.needDelay = NO;
    [super dataModelDidFail:model];
}

- (void)dataModelDidFinish:(VGEDataModel *)model
{
    [super dataModelDidFinish:model];
    [_refreshHeadView pullRefreshScrollViewDataSourceDidFinishLoading:self.tableView];
    _isPullRefresh = NO;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[_refreshHeadView pullRefreshScrollViewDidScroll:scrollView];
    [super scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	[_refreshHeadView pullRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark - DTPullRefreshHeadViewDelegate

- (BOOL)pullRefreshTableHeaderDataSourceIsLoading:(DTTableRefreshHeaderView *)view
{
    if (!self.dataModel) {
        return YES;
    }
    return [self.dataModel loading];
}

- (void)pullRefreshTableHeaderDidTriggerRefresh:(DTTableRefreshHeaderView *)view
{
    _isPullRefresh = YES;
    [self refresh];
}

@end
