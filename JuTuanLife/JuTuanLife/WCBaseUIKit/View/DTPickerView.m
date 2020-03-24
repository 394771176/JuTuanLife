//
//  DTPickerView.m
//  DrivingTest
//
//  Created by Kent on 13-12-10.
//  Copyright (c) 2013年 eclicks. All rights reserved.
//

#import "DTPickerView.h"
#import "WCUICommon.h"

@interface DTPickerView () <UIPickerViewDelegate, UIPickerViewDataSource> {
    UIView *_bgView, *_containView;
    NSUInteger _selectedIndex;
    
    UILabel *_titleLabel;
    UIToolbar *_topView;
}

@end

@implementation DTPickerView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithDelegate:(id<DTPickerViewDelegate>)delegate selectedRow:(NSInteger)row
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _delegate = delegate;
        
        _bgView = [[UIView alloc] initWithFrame:self.bounds];
        _bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _bgView.backgroundColor = [UIColor colorWithWhite:.0f alpha:.5f];
        [self addSubview:_bgView];
        
        _containView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-216-44, self.width, 260)];
        _containView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:_containView];
        
        _topView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.width, 44)];
        _topView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        UIBarButtonItem * cancelBtn = nil;
        UIBarButtonItem * doneBtn = nil;
        
        cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
        [cancelBtn setTitleTextAttributes:@{NSForegroundColorAttributeName :[UIColor colorWithHexString:@"666666" alpha:1], NSFontAttributeName:[UIFont systemFontOfSize:15.f]} forState:UIControlStateNormal];
        doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneBtnAction)];
        [doneBtn setTitleTextAttributes:@{NSForegroundColorAttributeName:APP_CONST_BLUE_COLOR, NSFontAttributeName:[UIFont systemFontOfSize:15.f]} forState:UIControlStateNormal];
        
        UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        NSArray * buttons = nil;
        if (iOS(7)) {
            _topView.barTintColor = [UIColor whiteColor];
            UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            leftBtn.width = rightBtn.width = -2;
            buttons = [NSArray arrayWithObjects:leftBtn,cancelBtn,btnSpace,doneBtn,rightBtn, nil];
        } else {
            buttons = [NSArray arrayWithObjects:cancelBtn,btnSpace,doneBtn, nil];
        }
        
        [_topView setItems:buttons];
        [_containView addSubview:_topView];
        
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, _topView.bottom, self.width, 216)];
        _pickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.showsSelectionIndicator = YES;
        [_containView addSubview:_pickerView];
        
        _tapDismiss = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        tap.cancelsTouchesInView = NO;
        [self addGestureRecognizer:tap];
        
//        [_pickerView selectRow:row inComponent:0 animated:NO];
        _selectedIndex = row;
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissPickerView) name:APP_EVENT_KJZ_POP_VIEW_DISMISS object:nil];
    }
    return self;
}

- (void)addTitleView
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:_topView.bounds];
        _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        _titleLabel.font = [UIFont systemFontOfSize:16.f];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_topView addSubview:_titleLabel];
    }
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    [self addTitleView];
    _titleLabel.text = _title;
}

- (void)setSource:(NSArray *)source
{
    _source = source;
    _componentSource = [NSArray arrayWithObjects:source, nil];
    [_pickerView reloadAllComponents];
    if (_selectedIndex < _source.count && _selectedIndex > 0) {
        [_pickerView selectRow:_selectedIndex inComponent:0 animated:NO];
    }
}

- (void)setComponentSource:(NSArray *)componentSource
{
    if (componentSource.count) {
        if (![componentSource.firstObject isKindOfClass:NSArray.class]) {
            self.source = componentSource;
            return;
        }
    }
    _componentSource = componentSource;
    [_pickerView reloadAllComponents];
    NSArray *array = [_componentSource safeObjectAtIndex:0];
    if (_selectedIndex < array.count && _selectedIndex > 0) {
        [_pickerView selectRow:_selectedIndex inComponent:0 animated:NO];
    }
}

- (void)setSelectedContents:(NSArray *)selectedContents
{
    for (int i = 0; i < selectedContents.count && i < _componentSource.count; i++) {
        NSString *content = [selectedContents safeObjectAtIndex:i];
        NSArray *array = [_componentSource safeObjectAtIndex:i];
        if ([array containsObject:content]) {
            NSInteger index = [array indexOfObject:content];
            [_pickerView selectRow:index inComponent:i animated:NO];
        }
    }
}

- (void)setBgAlpha:(CGFloat)bgAlpha
{
    _bgAlpha = bgAlpha;
    _bgView.alpha = bgAlpha;
}

- (void)showInView:(UIView *)view
{
    _bgView.alpha = 0.0f;
    self.frame = view.bounds;
    [view addSubview:self];
    _containView.top = self.height;
    
    [UIView animateWithDuration:.3f animations:^{
        _containView.top = self.height-_containView.height;
        _bgView.alpha = _bgAlpha;
    }];
}

- (void)removeFromSuperviewWithAnimated:(BOOL)animated
{
    if (_delegate && [_delegate respondsToSelector:@selector(pickerViewDidDismissAction:)]) {
        [_delegate pickerViewDidDismissAction:self];
    }
    [UIView animateWithDuration:.3f animations:^{
        _containView.top = self.height;
        _bgView.alpha = .0f;
    }completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

#pragma mark - Action

- (void)tapAction:(UIGestureRecognizer *)recognizer
{
    if (!_tapDismiss) {
        return;
    }
    CGPoint location = [recognizer locationInView:self];
    if (location.y<_containView.top) {
        [self cancelAction];
    }
}

- (void)doneBtnAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(pickerViewSelectedRow:content:selectedRow:)]) {
        NSArray *array = [_componentSource safeObjectAtIndex:0];
        [_delegate pickerViewSelectedRow:self content:[array safeObjectAtIndex:_selectedIndex] selectedRow:_selectedIndex];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(pickerViewSelectedRow:contents:selectedRows:)]) {
        NSMutableArray *contents = [NSMutableArray array];
        NSMutableArray *rows = [NSMutableArray array];
        for (int i = 0; i < _componentSource.count; i++) {
            NSInteger row = [_pickerView selectedRowInComponent:i];
            NSArray *array = [_componentSource safeObjectAtIndex:i];
            NSString *content = [array safeObjectAtIndex:row];
            [contents safeAddObject:content];
            [rows safeAddObject:@(row)];
        }
        [_delegate pickerViewSelectedRow:self contents:contents selectedRows:rows];
    }
    
    if ([self isSingleComponent]) {
        if (_needSelectedToSubmit && _selectedIndex==0) {
            return;
        }
    }
    
    [self removeFromSuperviewWithAnimated:YES];
}

- (void)cancelAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(pickerViewDidCancelAction:)]) {
        [_delegate pickerViewDidCancelAction:self];
    }
    [self removeFromSuperviewWithAnimated:YES];
}

#pragma mark - UIPickerViewDelegate&&UIPickerViewDataSource

- (BOOL)isSingleComponent
{
    return _componentSource.count <= 1;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return _componentSource.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSArray *array = [_componentSource safeObjectAtIndex:component];
    return array.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSArray *array = [_componentSource safeObjectAtIndex:component];
    return [array safeObjectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSArray *array = [_componentSource safeObjectAtIndex:component];
    
    if (component == 0) {
        _selectedIndex = row;
        if ([_delegate respondsToSelector:@selector(pickerViewRowDidChange:content:row:)]) {
            [_delegate pickerViewRowDidChange:self content:[array safeObjectAtIndex:row] row:row];
        }
    }
    
    if ([_delegate respondsToSelector:@selector(pickerViewRowDidChange:content:row:component:)]) {
        [_delegate pickerViewRowDidChange:self content:[array safeObjectAtIndex:row] row:row component:component];
    }
}

@end
