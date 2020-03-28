//
//  DTTableController.m
//  DrivingTest
//
//  Created by Kent on 14-2-25.
//  Copyright (c) 2014年 eclicks. All rights reserved.
//

#import "DTTableController.h"

@interface DTTableController () {
    
}

@end

@implementation DTTableController

- (void)dealloc
{
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithTableStyle:(UITableViewStyle)tableViewStyle
{
    self = [super init];
    if (self) {
        _noDataViewTopOff = 0;
        _noDataBtnTopOff = 0;
        _noDataImgTopOff = 0;
        _noDataLabTopOff = 0;
        self.tableViewStyle = tableViewStyle;
        
        
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _noDataViewTopOff = 0;
        _noDataBtnTopOff = 0;
        _noDataImgTopOff = 0;
        _noDataLabTopOff = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

//    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:self.tableViewStyle];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:_tableView];
    
    if ([DTPubUtil isIPhoneX]) {
        [self.tableView setTableFooterHeight:SAFE_BOTTOM_VIEW_HEIGHT];
    } else {
        [self.tableView setTableFooterHeight:12];
    }
    
    [self reloadTableView];
}

- (BOOL)isViewRealAppear
{
    return YES;
}

- (void)didViewRealAppear
{
    
}

- (WCTableSourceData *)setupTableSourceData
{
    return nil;
}

- (void)reloadTableView
{
    if (self.tableSourceData) {
        [self.tableSourceData clearDataSource];
    }
    self.tableSourceData = [self setupTableSourceData];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.tableSourceData) {
        return [self.tableSourceData numberOfSectionsInTableView:tableView];
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.tableSourceData) {
        return [self.tableSourceData tableView:tableView numberOfRowsInSection:section];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableSourceData) {
        return [self.tableSourceData tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableSourceData) {
        return [self.tableSourceData tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    return [[UITableViewCell alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.tableSourceData) {
        return [self.tableSourceData tableView:tableView heightForHeaderInSection:section];
    }
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.tableSourceData) {
        return [self.tableSourceData tableView:tableView viewForHeaderInSection:section];
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.tableSourceData) {
        return [self.tableSourceData tableView:tableView heightForFooterInSection:section];
    }
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (self.tableSourceData) {
        return [self.tableSourceData tableView:tableView viewForFooterInSection:section];
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.tableSourceData) {
        [self.tableSourceData tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)setTableViewScrollToTop:(BOOL)top
{
    self.tableView.scrollsToTop = top;
}

- (void)scrollToTop:(BOOL)animated
{
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, self.tableView.width, 1) animated:animated];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([[UIMenuController sharedMenuController] isMenuVisible]) {
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
    }
}

#pragma mark UIScrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_tableScrollDelegate && [_tableScrollDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [_tableScrollDelegate tableController:self scrollViewDidScroll:scrollView];
    }
}

- (void)showNoDataViewWithType:(int)type msg:(NSString *)msg image:(UIImage *)image
{
    if (!_noDataView) {
        _noDataView = [[DTNoDataView alloc] initWithFrame:CGRectMake(0, _noDataViewTopOff, self.tableView.width, self.tableView.height-_noDataViewTopOff)];
        _noDataView.imgOffset = _noDataImgTopOff;
        _noDataView.labOffset = _noDataLabTopOff;
        _noDataView.btnOffset = _noDataBtnTopOff;
        _noDataView.delegate = self;
        _noDataView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    
    if (type==0) {
        self.tableView.alpha = 1;
        self.tableView.userInteractionEnabled = YES;
        if (_noDataView.superview!=_tableView) {
            [_noDataView removeFromSuperview];
//            _noDataView.frame = _tableView.bounds;
            _noDataView.frame = CGRectMake(0, _noDataViewTopOff, self.tableView.width, self.tableView.height-_noDataViewTopOff);
            [_tableView addSubview:_noDataView];
        }
    } else {
        self.tableView.alpha = 0;
        self.tableView.userInteractionEnabled = NO;
        if (_noDataView.superview!=self.view) {
            [_noDataView removeFromSuperview];
//            _noDataView.frame = _tableView.frame;
            _noDataView.frame = CGRectMake(_tableView.left, _tableView.top + _noDataViewTopOff, self.tableView.width, self.tableView.height-_noDataViewTopOff);
            [self.view addSubview:_noDataView];
            [self.view bringSubviewToFront:_noDataView];
        }
    }
    _noDataView.image = image;
    _noDataView.msg = msg;
    _noDataView.hidden = NO;
    if(_failBtnTitle.length > 0){
        [_noDataView setBtnTitle:_failBtnTitle];
    }
}

- (void)showNoDataViewWithTop:(float)top msg:(NSString *)msg image:(UIImage *)image
{
    if (_noDataView) {
        [_noDataView removeFromSuperview];
        _noDataView = nil;
    }
    _noDataView = [[DTNoDataView alloc] initWithFrame:CGRectMake(0, top, self.tableView.width, self.tableView.height-top)];
    _noDataView.imgOffset = _noDataImgTopOff;
    _noDataView.labOffset = _noDataLabTopOff;
    _noDataView.btnOffset = _noDataBtnTopOff;
    _noDataView.delegate = self;
    _noDataView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _noDataView.image = image;
    _noDataView.msg = msg;
    [self.view addSubview:_noDataView];
}

- (void)showNoDataView
{
    if (_noDataMsg.length <= 0) {
        self.noDataMsg = @"暂无内容";
    }
    if (_noDataImg == nil) {
        _noDataImg = [UIImage imageNamed:@"jt_no_data_img"];
    }
    
    [self showNoDataViewWithType:0 msg:_noDataMsg image:_noDataImg];
    if(_noDataBtnTitle.length > 0){
        [_noDataView setBtnTitle:_noDataBtnTitle];
    }
}

- (void)hideNoDataView
{
    _noDataView.hidden = YES;
    self.tableView.alpha = 1;
    self.tableView.userInteractionEnabled = YES;
}

- (void)setNoDataMsg:(NSString *)noDataMsg
{
    _noDataMsg = noDataMsg;
    
    _noDataView.msg = _noDataMsg;
}

#pragma mark - DTNoDataViewDelegate

- (void)noDataViewDidClick:(DTNoDataView *)view
{
    
}

- (void)noDataViewBtnAction:(DTNoDataView *)view
{
    //子类继承 各自实现需求
}

@end
