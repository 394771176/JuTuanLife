//
//  CLDatePickerView.h
//  CLCommon
//
//  Created by cheng on 14-9-25.
//  Copyright (c) 2014年 eclicks. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DTDatePickerView;

@protocol DTDatePickerViewDelegate <NSObject>

@optional

- (void)datePickerView:(DTDatePickerView *)pickerView selectedDate:(NSDate *)date;

- (void)datePickerViewDidCancelAction:(DTDatePickerView *)pickerView;

- (void)datePickerViewDidDismissAction:(DTDatePickerView *)pickerView;

@end

@interface DTDatePickerView : UIView

@property (nonatomic, weak) id <DTDatePickerViewDelegate> delegate;
@property (nonatomic, strong) NSDate *minDate;
@property (nonatomic, strong) NSDate *maxDate;
@property (nonatomic, strong) NSDate *date;

@property (nonatomic) UIDatePickerMode datePickerMode;//default is UIDatePickerModeDate

@property (nonatomic, assign) CGFloat bgAlpha;//default is 0.5
@property (nonatomic, assign) BOOL tapDismiss;//default is YES;

@property (nonatomic, strong) NSString *confirmTitle;

@property (copy) void (^finishBlock)(BOOL success,NSString *date);

- (id)initWithDelegate:(id<DTDatePickerViewDelegate>)delegate date:(NSDate *)date;
- (void)setDate:(NSDate *)date animated:(BOOL)animated;
- (void)showInView:(UIView *)view;
- (void)dismissPickerView;

@end
