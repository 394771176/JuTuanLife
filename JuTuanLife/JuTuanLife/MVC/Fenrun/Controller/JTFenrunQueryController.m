//
//  JTFenrunQueryController.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/23.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTFenrunQueryController.h"
#import "JTHomeFenrunCell.h"
#import "JTShipListCell.h"
#import "JTFenRunModel.h"
#import "JTUserCenterController.h"
#import "DTPickerView.h"
#import "CLDatePickerView.h"
#import "JTUserFenrunController.h"

@interface JTFenrunQueryController ()
<
DTTabBarViewDelegate
, CLDatePickerViewDelegate
, DTPickerViewDelegate
>
{
    JTHomeFenrunCell *_fenrunCell;
    NSMutableDictionary *_modelDict;
    
    CLDatePickerView *_datePicker;
    DTPickerView *_pickerView;
    
    NSDate *_today;
}

@end

@implementation JTFenrunQueryController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _period = JTFenRunPeriodFixDay;
    }
    return self;
}

- (void)setPeriod:(JTFenRunPeriod)period
{
    if (period == JTFenRunPeriodYear) {
        _period = JTFenRunPeriodFixYear;
    } else if (period == JTFenRunPeriodMonth || period == JTFenRunPeriodQuarter) {
        _period = JTFenRunPeriodFixMonth;
    } else {
        _period = JTFenRunPeriodFixDay;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self showPickerView];
}

- (void)viewDidLoad {
    
    self.autoRefresh = NO;
    
    [super viewDidLoad];
    self.title = @"分润查询";
    
    //标记当前选中，再次查询默认选中当前
    _today = [NSDate date];
    
    [self.tableView setTableHeaderHeight:10];
    
    [self reloadData];
}

- (void)showNoDataView
{
    self.noDataViewTopOff = [self.tableView totalHeightToSection:1 target:self];
    [super showNoDataView];
}

- (void)reloadData
{
    if ([self.Model selectedDate].length <= 0) {
        return;
    }
    _fenrunCell.item = [self.Model fenrun];
    
    if (self.dataModel.hasLoadData && self.dataModel.itemCount <= 0) {
        [self showNoDataView];
    } else {
        [self hideNoDataView];
    }
    [super reloadData];
}

- (DTListDataModel *)createDataModel
{
    return [self modelForPeriod:_period];
}

- (JTFenRunModel *)modelForPeriod:(JTFenRunPeriod)period
{
    if (!_modelDict) {
        _modelDict = [NSMutableDictionary dictionary];
    }
    JTFenRunModel *model = [_modelDict objectForKey:@(period)];
    if (!model) {
        model = [[JTFenRunModel alloc] initWithFetchLimit:20 delegate:self];
        model.period = period;
        //查询没有缓存
//        [model loadCache];
        [_modelDict safeSetObject:model forKey:@(period)];
    }
    return model;
}

- (WCTableSourceData *)setupTableSourceData
{
    WEAK_SELF
    WCTableSourceData *source = [WCTableSourceData new];
    
    {
        if (!_fenrunCell) {
            _fenrunCell = [[JTHomeFenrunCell alloc] init];
            _fenrunCell.delegate = self;
            _fenrunCell.onlyFixPeriod = YES;
            _fenrunCell.period = _period;
        }
        WCTableSection *section = [WCTableSection sectionWithCells:@[_fenrunCell] click:^(id data, NSIndexPath *indexPath) {
            
        }];
        
        section.heightBlock = ^CGFloat(id data, NSIndexPath *indexPath) {
            return [JTHomeFenrunCell cellHeightWithItem:[self.Model fenrun] tableView:self.tableView onlyFixPeriod:YES];
        };
        [source addSectionItem:section];
    }
    
    {
        WCTableSection *section = [WCTableSection sectionWithItems:[self.dataModel data] cellClass:NULL];
        section.cellBlock = ^UITableViewCell *(id data, NSIndexPath *indexPath) {
            KEY(JTShipListCell_key)
            JTShipListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:JTShipListCell_key];
            if (!cell) {
                cell = [[JTShipListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:JTShipListCell_key];
                cell.cellType = JTShipCellTypeFenrun;
            }
            return cell;
        };
        section.clickBlock = ^(JTShipItem *data, NSIndexPath *indexPath) {
            PUSH_VC_WITH(JTUserFenrunController , vc.user = data; vc.period = weakSelf.period; );
        };
        [source addSectionItem:section];
    }
    
    {
        WCTableSection *section = [WCTableSection sectionWithItems:@[self.loadMoreCell] countBlock:^NSInteger(NSInteger section) {
            return (self.dataModel.canLoadMore ? 1 : 0);
        }];
        [source addSectionItem:section];
    }
    
    return source;
}

- (void)showPickerView
{
    if (_period == JTFenRunPeriodFixDay) {
        [_pickerView removeFromSuperview];
        
        if (!_datePicker) {
            CLDatePickerView *picker = [[CLDatePickerView alloc] initWithDelegate:self date:_today];
            picker.tapDismiss = NO;
            picker.bgAlpha = 0;
            picker.minDate = [NSDate dateWithTimeIntervalSince1970:0];
            picker.maxDate = _today;
            picker.confirmTitle = @"查询";
            _datePicker = picker;
        }
        [_datePicker showInView:self.view];
        _datePicker.frame = CGRectMake(0, 80, self.view.width, self.height - 80);
        _datePicker.date = _today;
    } else {
        [_datePicker removeFromSuperview];
        
        NSMutableArray *array = [NSMutableArray arrayWithObjects:[self yearsArray], nil];
        if (_period == JTFenRunPeriodFixMonth) {
            [array safeAddObject:@[@"1月", @"2月", @"3月", @"4月",  @"5月",  @"6月",
                                   @"7月", @"8月", @"9月", @"10月", @"11月", @"12月"]];
        }
        if (!_pickerView) {
            DTPickerView *picker = [[DTPickerView alloc] initWithDelegate:self selectedRow:0];
            picker.tapDismiss = NO;
            picker.bgAlpha = 0;
            picker.confirmTitle = @"查询";
            _pickerView = picker;
        }
        _pickerView.componentSource = array;
        [_pickerView showInView:self.view];
        _pickerView.frame = CGRectMake(0, 80, self.view.width, self.height - 80);
        [JTService addBlockOnMainThread:^{
            [_pickerView setSelectedContents:@[[NSString stringWithFormat:@"%zd年", _today.year],
                                               [NSString stringWithFormat:@"%zd月", _today.month]]];
        }];
    }
}

- (NSArray *)yearsArray
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i=1970; i <= _today.year; i++) {
        [array safeAddObject:[NSString stringWithFormat:@"%zd年", i]];
    }
    return array;
}

- (void)didQueryAction:(NSString *)selectedDate
{
    JTFenRunModel *model = [self modelForPeriod:_period];
    if (self.dataModel != model) {
        [self resetDataModel:model];
    }
    [self.Model setSelectedDate:selectedDate];
    [self refresh];
}

- (void)didCancelQuery
{
    if ([self.Model period] != _period) {
        _fenrunCell.period = [self.Model period];
    }
    if (!self.dataModel.hasLoadData) {
        [self backAction];
    }
}

#pragma mark - DTTabBarViewDelegate

- (void)tabBarViewDidSelectIndex:(NSInteger)index
{
    _period = (JTFenRunPeriod)(index + JTFenRunPeriodFixDay);
    JTFenRunModel *model = [self modelForPeriod:_period];
    if (model.itemCount || model.hasLoadData)
    {
        [self resetDataModel:model];
        [self reloadData];
    }
    
    [self showPickerView];
}

#pragma mark - , CLDatePickerViewDelegate

- (void)datePickerView:(CLDatePickerView *)pickerView selectedDate:(NSDate *)date
{
    [self didQueryAction:date.dayString];
}

- (void)datePickerViewDidCancelAction:(CLDatePickerView *)pickerView
{
    [self didCancelQuery];
}

#pragma mark - , DTPickerViewDelegate

- (void)pickerViewSelectedRow:(DTPickerView *)pickerView contents:(NSArray *)contents selectedRows:(NSArray *)rows
{
    NSMutableString *dateStr = [NSMutableString string];
    [contents enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *string = nil;
        if ([obj hasSuffix:@"年"] || [obj hasSuffix:@"月"]) {
            string = [obj substringToIndex:obj.length - 1];
        } else {
            string = obj;
        }
            
        if (dateStr.length) {
            [dateStr appendFormat:@"-%@", string];
        } else {
            [dateStr appendFormat:@"%@", string];
        }
    }];
    JTFenRunModel *model = [self modelForPeriod:_period];
    if (self.dataModel != model) {
        [self resetDataModel:model];
    }
    
    [self didQueryAction:dateStr];
}

- (void)pickerViewDidCancelAction:(DTPickerView *)pickerView
{
    [self didCancelQuery];
}

- (NSInteger)pickerView:(DTPickerView *)pickerView countForComponent:(NSInteger)component withSource:(NSArray *)source
{
    if (component == 1) {
        UIPickerView *picker = pickerView.pickerView;
        if ([picker selectedRowInComponent:0] == [picker numberOfRowsInComponent:0] - 1) {
            return _today.month;
        } else {
            return source.count;
        }
    } else {
        return source.count;
    }
}

@end
