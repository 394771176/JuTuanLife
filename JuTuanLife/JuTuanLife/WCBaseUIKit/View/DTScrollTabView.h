//
//  DTScrollTabView.h
//  DrivingTest
//
//  Created by cheng on 2018/8/7.
//  Copyright © 2018年 eclicks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTTabBarView.h"
#import "DTTabItem.h"

@class DTScrollTabView;

@protocol DTScrollTabViewDataSource <NSObject>

- (NSString *)title;

@end

@interface DTScrollTabView : UIScrollView

@property (nonatomic, weak) id<DTTabBarViewDelegate> tDelegate;
@property (nonatomic, strong) NSArray *items;//title array
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) UIView *selectedLine;
@property (nonatomic, strong) BPOnePixLineView *bottomLine;
@property (nonatomic, strong) UIColor *selectColor, *normalColor, *selectBgColor;
@property (nonatomic) CGFloat fontSize;//default is 17
@property (nonatomic) BOOL zoomAnimation;//缩放动画， default is yes

//自动充满
@property (nonatomic, assign) BOOL autoFill;//default is yes
@property (nonatomic, assign) CGFloat itemGap;//default is 10
@property (nonatomic, assign) CGFloat itemOffset;//default is 5

@property (nonatomic, assign) BOOL isClick;

@property (nonatomic, strong) NSDictionary *configDict;

- (id)initWithFrame:(CGRect)frame withItems:(NSArray *)items;
- (UIButton *)itemWithIndex:(NSInteger)index;
- (UIButton *)createItemWithIndex:(NSInteger)index;
- (void)setItemTitle:(NSString *)title withIndex:(NSInteger)index;

- (NSString *)titleWithIndex:(NSInteger)index;

- (void)setBtn:(UIButton *)btn withIndex:(NSInteger)index;

- (void)setSelectedLineOffSet:(CGFloat)offsetX;
- (void)setSelectedLineWidth:(CGFloat)width;//固定宽度
- (void)setSelectedLineGap:(CGFloat)gap;//固定间隙

- (void)setSelectedLineCenterOffSet:(CGFloat)offsetX;
- (void)setSelectedLineMoveWithScorllView:(UIScrollView *)scrollView;

- (void)setSelectIndex:(NSInteger)selectIndex animation:(BOOL)animation;

- (void)btnAction:(UIButton *)sender;

@end
