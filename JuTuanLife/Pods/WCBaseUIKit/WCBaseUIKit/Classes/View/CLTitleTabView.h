//
//  CLTitleTabView.h
//  CLCommon
//
//  Created by cheng on 14-10-27.
//  Copyright (c) 2014年 eclicks. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    CLTabTypeEqualWidth,//等宽
    CLTabTypeEqualSpace,//等间距
} CLTabType;

@class CLTitleTabView;

@protocol CLTitleTabViewDelegate <NSObject>

- (void)titleTabView:(CLTitleTabView *)view didSelectIndex:(NSInteger)index;

@end

@interface CLTitleTabView : UIView

@property (nonatomic, weak) id<CLTitleTabViewDelegate> delegate;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic) CGFloat fontSize,selectFontSize;//default is 16 and 18
@property (nonatomic, strong) UIColor *fontColor, *selectFontColor;
@property (nonatomic) BOOL forbidAnimation;//禁掉动画，default is NO
@property (nonatomic) NSInteger selectIndex;
@property (nonatomic, assign) CLTabType tabType;
@property (nonatomic) BOOL onlyDot;//default is Yes;

- (id)initWithFrame:(CGRect)frame items:(NSArray *)items;
- (id)initWithFrame:(CGRect)frame withDelegate:(id<CLTitleTabViewDelegate>)delegate;
- (void)setSelectIndex:(NSInteger)selectIndex animated:(BOOL)animated;
- (CGFloat)getOffsetWithScrollView:(UIScrollView *)scrollView;
- (CGFloat)getOffsetWithCurrentIndex;

- (void)setBadge:(int)badge index:(int)index;

- (UIButton *)buttonWithIndex:(NSInteger)index;

@end
