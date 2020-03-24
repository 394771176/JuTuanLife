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
//第一列回调，一般适用于单列
- (void)pickerViewSelectedRow:(DTPickerView *)pickerView content:(NSString *)content selectedRow:(NSInteger)row;
- (void)pickerViewRowDidChange:(DTPickerView *)pickerView content:(NSString *)content row:(NSInteger)row;

//多列回调
- (void)pickerViewSelectedRow:(DTPickerView *)pickerView contents:(NSArray *)contents selectedRows:(NSArray *)rows;
- (void)pickerViewRowDidChange:(DTPickerView *)pickerView content:(NSString *)content row:(NSInteger)row component:(NSInteger)component;

- (void)pickerViewDidCancelAction:(DTPickerView *)pickerView;

- (void)pickerViewDidDismissAction:(DTPickerView *)pickerView;

@end

@interface DTPickerView : UIView
@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, weak) id <DTPickerViewDelegate> delegate;
@property (nonatomic, strong) NSArray<NSString *> *source;//单列
@property (nonatomic, strong) NSArray<NSArray *> *componentSource; //多列
@property (nonatomic, strong) id userInfo;
@property (nonatomic, strong) NSString *title;
@property (nonatomic) BOOL needSelectedToSubmit;//提交不能为第零行，适用于单列

@property (nonatomic, assign) CGFloat bgAlpha;
@property (nonatomic, assign) BOOL tapDismiss;//default is YES;

- (id)initWithDelegate:(id<DTPickerViewDelegate>)delegate selectedRow:(NSInteger)row;
- (void)showInView:(UIView *)view;
- (void)dismissPickerView;

- (void)setSelectedContents:(NSArray *)selectedContents;

- (void)addTitleView;

@end
