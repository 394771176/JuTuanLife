//
//  DTUISegmentView.h
//  DrivingTest
//
//  Created by Kent on 14-3-4.
//  Copyright (c) 2014年 eclicks. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DTUISegmentView;

@protocol DTUISegmentViewDelegate <NSObject>

- (void)segmentedControl:(DTUISegmentView *)segmentedView didSelectedIndex:(NSUInteger)index;

@end

@interface DTUISegmentView : UIView

@property (nonatomic, weak) id <DTUISegmentViewDelegate> delegate;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic) CGFloat fontSize;
@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, strong) UIColor *selectedFontColor, *unselectedFontColor;

- (DTUISegmentView *)initWithFrame:(CGRect)frame delegate:(id<DTUISegmentViewDelegate>)delegate;
- (DTUISegmentView *)initWithFrame:(CGRect)frame titles:(NSArray *)titles;
- (void)setBadge:(NSInteger)badge withIndex:(NSInteger)index;

- (void)setSelectedColor:(UIColor *)selectedColor selectedFontColor:(UIColor *)selFontColor;
- (void)setSelectedColor:(UIColor *)selectedColor selectedFontColor:(UIColor *)selFontColor unselectedFontColor:(UIColor *)unselFontColor;
- (void)updateColor;

@end
