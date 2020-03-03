 //
//  CWTabBarView.h
//  ChelunWelfare
//
//  Created by cheng on 15/1/21.
//  Copyright (c) 2015年 Wang Peng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BPOnePixLineView.h"
#import "DTBadgeView.h"

@class DTTabBarView;

@protocol DTTabBarViewDelegate <NSObject>

- (void)tabBarViewDidSelectIndex:(NSInteger)index;

@end

@interface DTTabBarView : UIView

@property (nonatomic, weak) id<DTTabBarViewDelegate>delegate;
@property (nonatomic, strong) NSArray *items;//title array
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) UIView *selectedLine;
@property (nonatomic, strong) BPOnePixLineView *bottomLine;

@property (nonatomic, strong) UIColor *selectColor, *normalColor, *selectBgColor;
@property (nonatomic, strong) UIColor *selectLineColor;//默认nil,如果nil用selectColor
@property (nonatomic) CGFloat fontSize;
@property (nonatomic, assign) BOOL selectFontBlod;//选中字体加粗
@property (nonatomic) BOOL showSeparateLine;// default is NO separate
@property (nonatomic) CGFloat separateLineTop;//default is 10
@property (nonatomic, strong) UIColor *separateLineColor;//default is b6b6b6
@property (nonatomic) BOOL zoomAnimation;//缩放动画， default is NO
@property (nonatomic, strong) UIColor *badgeColor;
//@property (nonatomic) CGFloat zoomScale;//default is 0.92;

@property (nonatomic, assign)BOOL needLayout; //是否需要二次刷新视图位置

- (id)initWithFrame:(CGRect)frame withItems:(NSArray *)items;
- (UIButton *)itemWithIndex:(NSInteger)index;
- (UIButton *)createItemWithIndex:(NSInteger)index;
- (void)setItemTitle:(NSString *)title withIndex:(NSInteger)index;

- (void)setBtn:(UIButton *)btn withIndex:(NSInteger)index;

- (void)setSelectedLineOffSet:(CGFloat)offsetX;
- (void)setSelectedLineWidth:(CGFloat)width;//固定宽度
- (void)setSelectedLineGap:(CGFloat)gap;//固定间隙

- (void)setSelectedLineCenterOffSet:(CGFloat)offsetX;
- (void)setSelectedLineMoveWithScorllView:(UIScrollView *)scrollView;

- (void)setSelectIndex:(NSInteger)selectIndex animation:(BOOL)animation;

- (void)btnAction:(UIButton *)sender;

- (void)setBadge:(NSInteger)badge withIndex:(NSInteger)index;
- (void)setBadge:(NSInteger)badge withIndex:(NSInteger)index onlyDot:(BOOL)onlyDot;
- (void)setBadge:(NSInteger)badge withIndex:(NSInteger)index onlyDot:(BOOL)onlyDot rightPos:(BOOL)rightPos;

- (DTBadgeView *)badgeViewWithIndex:(NSUInteger)index;

@end
