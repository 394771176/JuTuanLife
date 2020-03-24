//
//  CLDatePickerView.m
//  CLCommon
//
//  Created by cheng on 14-9-25.
//  Copyright (c) 2014年 eclicks. All rights reserved.
//

#import "CLDatePickerView.h"
#import "WCUICommon.h"

@interface CLDatePickerView () {
    UIView *_bgView, *_containView;
    UIDatePicker *_datePicker;
    BOOL _chooseDate;
}

@end

@implementation CLDatePickerView

- (id)initWithDelegate:(id<CLDatePickerViewDelegate>)delegate date:(NSDate *)date
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        _delegate = delegate;
        
        _bgView = [[UIView alloc] initWithFrame:self.bounds];
        _bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _bgView.backgroundColor = [UIColor colorWithWhite:.0f alpha:.5f];
        [self addSubview:_bgView];
        
        _containView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-216-44, self.width, 260)];
        _containView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:_containView];
        
        UIToolbar * topView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.width, 44)];
        UIBarButtonItem * cancelBtn = nil;
        UIBarButtonItem * doneBtn = nil;
        
        cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
        [cancelBtn setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"666666" alpha:1],NSFontAttributeName:[UIFont systemFontOfSize:15.f]} forState:UIControlStateNormal];
        doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneBtnAction)];
        [doneBtn setTitleTextAttributes:@{NSForegroundColorAttributeName:APP_CONST_BLUE_COLOR,NSFontAttributeName:[UIFont systemFontOfSize:15.f]} forState:UIControlStateNormal];
        
        UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        NSArray * buttons = nil;
        if (iOS(7)) {
            topView.barTintColor = [UIColor whiteColor];
            UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            leftBtn.width = rightBtn.width = -2;
            buttons = [NSArray arrayWithObjects:leftBtn,cancelBtn,btnSpace,doneBtn,rightBtn, nil];
        } else {
            buttons = [NSArray arrayWithObjects:cancelBtn,btnSpace,doneBtn, nil];
        }
        
        [topView setItems:buttons];
        [_containView addSubview:topView];
        
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, topView.bottom, self.width, 216)];
        _datePicker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _datePicker.backgroundColor = [UIColor whiteColor];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        [_containView addSubview:_datePicker];
        
        _tapDismiss = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        tap.cancelsTouchesInView = NO;
        [self addGestureRecognizer:tap];
        
        if (date != nil) {
            [self setDate:date];
        }
    }
    return self;
}

- (void)setDatePickerMode:(UIDatePickerMode)datePickerMode
{
    _datePickerMode = datePickerMode;
    _datePicker.datePickerMode = datePickerMode;
}

- (void)setMinDate:(NSDate *)minDate
{
    _datePicker.minimumDate = minDate;
}

- (void)setMaxDate:(NSDate *)maxDate
{
    _datePicker.maximumDate = maxDate;
}

- (void)setDate:(NSDate *)date
{
    _date = date;
    [_datePicker setDate:date animated:NO];
}

- (void)setDate:(NSDate *)date animated:(BOOL)animated
{
    _date = date;
    [_datePicker setDate:date animated:animated];
}

- (void)setBgAlpha:(CGFloat)bgAlpha
{
    _bgAlpha = bgAlpha;
    _bgView.alpha = bgAlpha;
}

- (void)showInView:(UIView *)view
{
    self.frame = CGRectMake(0, 0, view.width, view.height);
    [view addSubview:self];
    _containView.top = self.height;
    _bgView.alpha = .0f;
    [UIView animateWithDuration:.3f animations:^{
        _containView.top = self.height-_containView.height;
        _bgView.alpha = _bgAlpha;
    }];
}

- (void)removeFromSuperviewWithAnimated:(BOOL)animated
{
    if (_finishBlock) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        if (_datePickerMode == UIDatePickerModeDate) {
            [formatter setDateFormat:@"yyyy-MM-dd"];
        }else{
            [formatter setDateFormat:@"HH:mm"];
        }
        NSString *date = [formatter stringFromDate:_datePicker.date];
        _finishBlock(_chooseDate,date);
    }
    if (_delegate && [_delegate respondsToSelector:@selector(datePickerViewDidDismissAction:)]) {
        [_delegate datePickerViewDidDismissAction:self];
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
    _chooseDate = YES;
    [_delegate datePickerView:self selectedDate:_datePicker.date];
    [self removeFromSuperviewWithAnimated:YES];
}

- (void)cancelAction
{
    _chooseDate = NO;
    if (_delegate && [_delegate respondsToSelector:@selector(datePickerViewDidCancelAction:)]) {
        [_delegate datePickerViewDidCancelAction:self];
    }
    [self removeFromSuperviewWithAnimated:YES];
}

@end
