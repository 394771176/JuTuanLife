//
//  DTPickerView.h
//  DrivingTest
//
//  Created by Kent on 13-12-10.
//  Copyright (c) 2013年 eclicks. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DTPickerView;

@protocol DTPickerViewDelegate <NSObject>

@optional
- (void)pickerViewSelectedRow:(DTPickerView *)pickerView content:(NSString *)content selectedRow:(NSInteger)row;
- (void)pickerViewRowDidChange:(DTPickerView *)pickerView content:(NSString *)content row:(NSInteger)row;
- (void)dismissPickerViewAction:(DTPickerView *)pickerView;

@end

@interface DTPickerView : UIView
@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, weak) id <DTPickerViewDelegate> delegate;
@property (nonatomic, strong) NSArray *source;
@property (nonatomic, strong) id userInfo;
@property (nonatomic, strong) NSString *title;
@property (nonatomic) BOOL needSelectedToSubmit;//提交不能为第零行

- (id)initWithDelegate:(id<DTPickerViewDelegate>)delegate selectedRow:(NSInteger)row;
- (void)showInView:(UIView *)view;
- (void)dismissPickerView;

- (void)addTitleView;

@end
