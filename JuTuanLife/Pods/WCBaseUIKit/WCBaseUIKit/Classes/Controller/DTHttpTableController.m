//
//  DTHttpTableController.m
//  DrivingTest
//
//  Created by Kent on 14-3-4.
//  Copyright (c) 2014年 eclicks. All rights reserved.
//

#import "DTHttpTableController.h"
#import "WCUICommon.h"

@interface DTHttpTableController ()

@end

@implementation DTHttpTableController

- (void)dealloc
{
    [_dataModel setDelegate:nil];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.reloadForCache = YES;
        self.autoRefresh = YES;
        self.autoCreateModel = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (_autoCreateModel) {
        _dataModel = [self createDataModel];
        
        // 有缓存先显示缓存数据
        if (_reloadForCache && [self haveCacheOrData] > 0) {
            [self reloadData];
        }
        
        if (_autoRefresh) {
            [self performSelector:@selector(refresh) withObject:nil afterDelay:0.05f];
        }
    }
}

- (void)refresh
{
    _refreshOneTimeWhenAppear = NO;
    
    [_dataModel reload];
}

- (DTListDataModel *)createDataModel
{
    return nil;
}

- (void)resetDataModel:(DTListDataModel *)dataModel
{
    _dataModel = dataModel;
    [self reloadData];
}

- (void)reloadData
{
    [self reloadTableView];
}

- (void)enableRefreshOneTimeWhenAppear
{
    if ([self.view window]) {
        [self refresh];
    } else {
        _refreshOneTimeWhenAppear = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_refreshOneTimeWhenAppear) {
        [self refresh];
    }
}

- (BOOL)haveCacheOrData
{
    return _dataModel.itemCount>0;
}

#pragma mark - VGEDataModelDelegate

- (void)dataModelPrepareStart:(VGEDataModel *)model
{
    
}

- (void)dataModelWillStart:(VGEDataModel *)model
{
    // 无缓存显示loading indicator
    [self hideNoDataView];
    if (![self haveCacheOrData]) {
        [self startLoadingIndicator];
    }
}

- (void)dataModelDidUpdate:(VGEDataModel *)model
{
    [self stopLoadingIndicator];
}

- (void)dataModelDidSuccess:(VGEDataModel *)model
{
    [self reloadData];
    if (![DTReachabilityUtil sharedInstance].isReachable) {
        [DTPubUtil showHUDNoNetWorkHintInWindow];
    }
    if (![self haveCacheOrData]) {
        // 加载成功之后仍然无数据，显示无数据内容
        if (!_disableNoDataView) {
            [self showNoDataView];
        }
    } else {
        [self hideNoDataView];
    }
}

- (void)dataModelDidFail:(VGEDataModel *)model
{
    if (![self haveCacheOrData]) {        
        if ([model.result isKindOfClass:[WCDataResult class]]) {
            
        } else {
//            [self showFailedViewWithMsg:@"网络不给力，点击重试" image:[UIImage imageNamed:@"table_no_data_net"]];
        }
    } else {
        //有缓存 或者model中多个接口请求，部分请求正常
        [self reloadData];
        if ([model.result isKindOfClass:[WCDataResult class]]) {
            [DTPubUtil showHUDErrorHintInWindow:model.result.msg];
        }
    }
}

- (void)dataModelWillFinish:(VGEDataModel *)model
{
    _isDataModelLoadedFromNet = YES;
}

- (void)dataModelDidFinish:(VGEDataModel *)model
{
    [self stopLoadingIndicator];
}

#pragma mark - DTNoDataViewDelegate

- (void)noDataViewDidClick:(DTNoDataView *)view
{
    [self refresh];
}

@end
