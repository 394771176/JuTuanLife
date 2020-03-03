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
        
        if (iOS(7)) {
            cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismissPickerView)];
            [cancelBtn setTitleTextAttributes:@{NSForegroundColorAttributeName :[UIColor colorWithHexString:@"666666" alpha:1], NSFontAttributeName:[UIFont systemFontOfSize:15.f]} forState:UIControlStateNormal];
            doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneBtnAction)];
            [doneBtn setTitleTextAttributes:@{NSForegroundColorAttributeName:APP_CONST_BLUE_COLOR, NSFontAttributeName:[UIFont systemFontOfSize:15.f]} forState:UIControlStateNormal];
        } else {
            cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(dismissPickerView)];
            [cancelBtn setTitleTextAttributes:@{UITextAttributeTextColor:[UIColor whiteColor],UITextAttributeFont:[UIFont systemFontOfSize:15.f]} forState:UIControlStateNormal];
            doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(doneBtnAction)];
            [doneBtn setTitleTextAttributes:@{UITextAttributeTextColor:[UIColor whiteColor],UITextAttributeFont:[UIFont systemFontOfSize:15.f]} forState:UIControlStateNormal];
        }
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
    [_pickerView reloadAllComponents];
    if (_selectedIndex < _source.count && _selectedIndex >= 0) {
        [_pickerView selectRow:_selectedIndex inComponent:0 animated:NO];
    }
}

- (void)showInView:(UIView *)view
{
    _bgView.alpha = 0.0f;
    self.frame = view.bounds;
    [view addSubview:self];
    _containView.top = self.height;
    
    [UIView animateWithDuration:.3f animations:^{
        _containView.top = self.height-_containView.height;
        _bgView.alpha = 1.f;
    }];
}

- (void)removeFromSuperviewWithAnimated:(BOOL)animated
{
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
    CGPoint location = [recognizer locationInView:self];
    if (location.y<_containView.top) {
        [self removeFromSuperviewWithAnimated:YES];
    }
}

- (void)doneBtnAction
{
    [_delegate pickerViewSelectedRow:self content:[_source safeObjectAtIndex:_selectedIndex] selectedRow:_selectedIndex];
    if (!_needSelectedToSubmit||_selectedIndex!=0) {
        [self removeFromSuperviewWithAnimated:YES];
    }
}

- (void)dismissPickerView
{
    [self removeFromSuperviewWithAnimated:YES];
}

#pragma mark - UIPickerViewDelegate&&UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _source.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_source safeObjectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _selectedIndex = row;
    
    if ([_delegate respondsToSelector:@selector(pickerViewRowDidChange:content:row:)]) {
        [_delegate pickerViewRowDidChange:self content:[_source safeObjectAtIndex:row] row:row];
    }
}

@end
