//
//  CLDatePickerView.h
//  CLCommon
//
//  Created by cheng on 14-9-25.
//  Copyright (c) 2014年 eclicks. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLDatePickerView;

@protocol CLDatePickerViewDelegate <NSObject>

- (void)datePickerView:(CLDatePickerView *)pickerView selectedDate:(NSDate *)date;

- (void)datePickerViewDidCancelAction:(CLDatePickerView *)pickerView;

- (void)datePickerViewDidDismissAction:(CLDatePickerView *)pickerView;

@end

@interface CLDatePickerView : UIView

@property (nonatomic, weak) id <CLDatePickerViewDelegate> delegate;
@property (nonatomic, strong) NSDate *minDate;
@property (nonatomic, strong) NSDate *maxDate;
@property (nonatomic, strong) NSDate *date;

@property (nonatomic) UIDatePickerMode datePickerMode;//default is UIDatePickerModeDate

@property (nonatomic, assign) CGFloat bgAlpha;//default is 0.5
@property (nonatomic, assign) BOOL tapDismiss;//default is YES;

@property (copy) void (^finishBlock)(BOOL success,NSString *date);

- (id)initWithDelegate:(id<CLDatePickerViewDelegate>)delegate date:(NSDate *)date;
- (void)setDate:(NSDate *)date animated:(BOOL)animated;
- (void)showInView:(UIView *)view;
- (void)dismissPickerView;

@end
