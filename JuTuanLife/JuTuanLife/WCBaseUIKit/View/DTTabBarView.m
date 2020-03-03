//
//  CWTabBarView.m
//  ChelunWelfare
//
//  Created by cheng on 15/1/21.
//  Copyright (c) 2015年 Wang Peng. All rights reserved.
//

#import "DTTabBarView.h"

@interface DTTabBarView () {
    NSMutableArray *_itemViews;
    NSMutableArray *_sepLines;
    
    BOOL _fixedSelectLineWidth;
    BOOL _fixedSelectLineGap;
    CGFloat _selectLineGap;
    
    CGRect _markFrame;
}

@property (nonatomic, assign) BOOL isClick;

@end

@implementation DTTabBarView

@synthesize normalColor = _normalColor;
@synthesize selectColor = _selectColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _fontSize = 16;
        _normalColor = [UIColor colorWithHexString:@"727272"];
        _selectColor = APP_CONST_BLUE_COLOR;
        _separateLineColor = [UIColor colorWithHexString:@"b6b6b6"];
        self.backgroundColor = [UIColor whiteColor];
        
        BPOnePixLineView *line = [[BPOnePixLineView alloc] initWithFrame:CGRectMake(0, self.height-1, self.width, 1)];
        line.lineColor = [UIColor colorWithHexString:@"e5e5e5"];
        line.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
        [self addSubview:line];
        _bottomLine = line;
        
        _selectedLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-2, 0, 2)];
        _selectedLine.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        _selectedLine.backgroundColor = _selectColor;
        [self addSubview:_selectedLine];
    
        _separateLineTop = 10;
        
        _selectIndex = 0;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withItems:(NSArray *)items
{
    self = [self initWithFrame:frame];
    if (self) {
        self.items = items;
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (!CGRectEqualToRect(frame, _markFrame)) {
        _markFrame = frame;
        for (int i=0; i<_itemViews.count; i++) {
            UIButton *btn = _itemViews[i];
            btn.transform = CGAffineTransformIdentity;
            btn.frame = [self rectWithIndex:btn.tag];
            if (_showSeparateLine&&i<_sepLines.count) {
                BPOnePixLineView *line = _sepLines[i];
                line.frame = CGRectMake(btn.right-1, 8, 1, self.height-16);
            }
        }
        self.selectIndex = _selectIndex;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.needLayout) {
        for (int i=0; i<_itemViews.count; i++) {
            UIButton *btn = _itemViews[i];
            btn.transform = CGAffineTransformIdentity;
            btn.frame = [self rectWithIndex:btn.tag];
            if (_showSeparateLine&&i<_sepLines.count) {
                BPOnePixLineView *line = _sepLines[i];
                line.frame = CGRectMake(btn.right-1, 8, 1, self.height-16);
            }
        }
        self.selectIndex = _selectIndex;
    }
}

- (void)setNormalColor:(UIColor *)normalColor
{
    _normalColor = normalColor;
    if (_normalColor) {
        for (UIButton *btn in _itemViews) {
            [btn setTitleColor:_normalColor forState:UIControlStateNormal];
        }
    }
}

- (void)setSelectColor:(UIColor *)selectColor
{
    if (selectColor==nil) {
        _selectColor = _normalColor;
    } else {
        _selectColor = selectColor;
    }
    if (!_selectLineColor) {
        _selectedLine.backgroundColor = _selectColor;
    }
    
    if (_selectColor) {
        for (UIButton *btn in _itemViews) {
            [btn setTitleColor:_selectColor forState:UIControlStateSelected];
        }
    }
}

- (void)setSelectLineColor:(UIColor *)selectLineColor
{
    _selectLineColor = selectLineColor;
    _selectedLine.backgroundColor = selectLineColor;
}

- (void)setFontSize:(CGFloat)fontSize
{
    _fontSize = fontSize;
    for (UIButton *btn in _itemViews) {
        [btn setTitleFontSize:fontSize];
    }
    self.selectIndex = _selectIndex;
}

- (void)setSelectBgColor:(UIColor *)selectBgColor
{
    _selectBgColor = selectBgColor;
    self.selectIndex = _selectIndex;
}

- (void)setSeparateLineColor:(UIColor *)color
{
    _separateLineColor = color;
    for (BPOnePixLineView *view in _sepLines) {
        if ([view isKindOfClass:[BPOnePixLineView class]]) {
            view.lineColor = color;
        }
    }
}

- (void)setShowSeparateLine:(BOOL)showSeparateLine
{
    _showSeparateLine = showSeparateLine;
    self.items = _items;
}

- (void)setItems:(NSArray *)items
{
    _items = items;
    if (_itemViews==nil) {
        _itemViews = [NSMutableArray array];
    }
    if (_sepLines==nil) {
        _sepLines = [NSMutableArray array];
    }
    
    [_itemViews enumerateObjectsUsingBlock:^(UIView * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj) {
            [obj removeFromSuperview];
        }
    }];
    
    [_sepLines enumerateObjectsUsingBlock:^(UIView * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj) {
            [obj removeFromSuperview];
        }
    }];
    
    for (int i= 0; i<_items.count; i++) {
        UIButton *btn = nil;
        if (i<_itemViews.count) {
            btn = _itemViews[i];
        } else {
            btn = [self createItemWithIndex:i];
            [btn setTitleFontSize:_fontSize];
            [_itemViews addObject:btn];
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        btn.frame = [self rectWithIndex:i];
        btn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self setBtn:btn withIndex:i];
        [self addSubview:btn];
        if (_showSeparateLine&&i<items.count-1) {
            BPOnePixLineView *line;
            if (i<_sepLines.count) {
                line = _sepLines[i];
                line.frame = CGRectMake(ceilf(btn.right-1), _separateLineTop, 1, self.height-_separateLineTop*2);
            } else {
                line = [[BPOnePixLineView alloc] initWithFrame:CGRectMake(ceilf(btn.right-1), _separateLineTop, 1, self.height-_separateLineTop*2)];
                line.mode = BPOnePixLineModeVertical;
                line.lineColor = _separateLineColor;
                [_sepLines addObject:line];
            }
            [self addSubview:line];
        }
    }
    
    [self bringSubviewToFront:_selectedLine];
    
    if (_selectIndex < _items.count) {
        self.selectIndex = _selectIndex;
    } else {
        self.selectIndex = 0;
    }
}

- (UIButton *)createItemWithIndex:(NSInteger)index
{
    return [UIButton buttonWithType:UIButtonTypeCustom];
}

- (CGRect)rectWithIndex:(NSInteger)index
{
    if (_items.count<=0) {
        return CGRectZero;
    }
    CGFloat w = self.width/_items.count;
    return CGRectMake(ceilf(w*index), 0, w, self.height);
}

- (void)setBtn:(UIButton *)btn withIndex:(NSInteger)index
{
    btn.tag = index;
    [btn setTitle:[_items safeObjectAtIndex:index]];
    [btn setTitleColor:_normalColor forState:UIControlStateNormal];
    [btn setTitleColor:_selectColor forState:UIControlStateSelected];
}

- (UIButton *)itemWithIndex:(NSInteger)index
{
    if (index<_itemViews.count) {
        return _itemViews[index];
    }
    return nil;
}

- (void)setItemTitle:(NSString *)title withIndex:(NSInteger)index
{
    UIButton *btn = [self itemWithIndex:index];
    if (btn) {
        [btn setTitle:title];
    }
}

- (void)setSelectedLineOffSet:(CGFloat)offsetX
{
    _selectedLine.left += offsetX;
}

- (void)setSelectedLineCenterOffSet:(CGFloat)offsetX
{
    UIButton *btn = [self itemWithIndex:_selectIndex];
    _selectedLine.center = CGPointMake(btn.center.x + offsetX, _selectedLine.center.y);
}

- (void)setSelectedLineMoveWithScorllView:(UIScrollView *)scrollView
{
    if (scrollView.isDragging || scrollView.isTracking) {
        _isClick = NO;
    }

    if (_isClick) {
        //点击的时候自动画，不需要根据scorllview 来移动
        return;
    }
    if (_items.count) {
        CGFloat offsetX = (scrollView.contentOffset.x - (scrollView.width * _selectIndex))/ _items.count;
        [self setSelectedLineCenterOffSet:offsetX];
    }
}

- (void)setSelectedLineWidth:(CGFloat)width
{
    _fixedSelectLineGap = NO;
    _fixedSelectLineWidth = YES;
    _selectedLine.width = width;
    UIButton *btn = [self itemWithIndex:_selectIndex];
    if (btn) {
        _selectedLine.frame = CGRectMake(btn.width/2-_selectedLine.width/2+btn.left, _selectedLine.top, _selectedLine.width, _selectedLine.height);
    }
}

- (void)setSelectedLineGap:(CGFloat)gap
{
    _fixedSelectLineWidth = NO;
    _fixedSelectLineGap = YES;
    UIButton *btn = [self itemWithIndex:_selectIndex];
    if (btn) {
        _selectedLine.frame = CGRectMake(btn.left + _selectLineGap, _selectedLine.top, btn.width-_selectLineGap*2, _selectedLine.height);
    }
}

- (void)setSelectIndex:(NSInteger)selectIndex
{
    [self setSelectIndex:selectIndex animation:YES];
}

- (void)setSelectIndex:(NSInteger)selectIndex animation:(BOOL)animation
{
    _selectIndex = selectIndex;
    
    if (_itemViews.count) {
        if (animation) {
            [UIView animateWithDuration:0.25 animations:^{
                [self updateBtnItem];
                [self updateSelectedLine];
            }];
        } else {
            [self updateBtnItem];
            [self updateSelectedLine];
        }
        
        for (UIButton *btn in _itemViews) {
            btn.selected = (btn.tag == _selectIndex);
        }
    }
}

- (void)updateBtnItem
{
    for (UIButton *btn in _itemViews) {
        if (btn.tag==_selectIndex) {
            if (self.selectBgColor) {
                [btn setBackgroundColor:self.selectBgColor];
            }
            if (_zoomAnimation) {
                [btn setTransform:CGAffineTransformIdentity];
            }
            if (_selectFontBlod) {
                [btn setTitleFont:[UIFont boldSystemFontOfSize:_fontSize]];
            }
        } else {
            [btn setBackgroundColor:[UIColor clearColor]];
            if (_selectFontBlod) {
                [btn setTitleFont:[UIFont systemFontOfSize:_fontSize]];
            }
            if (_zoomAnimation) {
                [btn setTransform:CGAffineTransformMakeScale(0.92, 0.92)];
            }
        }
    }
}
- (void)updateSelectedLine
{
    UIButton *btn = [self itemWithIndex:_selectIndex];
    if (btn) {
        if (_fixedSelectLineWidth) {
            _selectedLine.frame = CGRectMake(btn.left+(btn.width/2-_selectedLine.width/2), _selectedLine.top, _selectedLine.width, _selectedLine.height);
        } else if (_fixedSelectLineGap) {
            _selectedLine.frame = CGRectMake(btn.left+_selectLineGap, _selectedLine.top, btn.width-_selectLineGap*2, _selectedLine.height);
        } else {
            _selectedLine.frame = CGRectMake(btn.left, _selectedLine.top, btn.width, _selectedLine.height);
        }
    }
}

- (void)btnAction:(UIButton *)sender
{
    _isClick = YES;
    self.selectIndex = sender.tag;
    if (_delegate) {
        [_delegate tabBarViewDidSelectIndex:sender.tag];
    }
}

- (void)setBadge:(NSInteger)badge withIndex:(NSInteger)index
{
    [self setBadge:badge withIndex:index onlyDot:NO];
}

- (void)setBadge:(NSInteger)badge withIndex:(NSInteger)index onlyDot:(BOOL)onlyDot
{
    [self setBadge:badge withIndex:index onlyDot:onlyDot rightPos:YES];
}

- (void)setBadge:(NSInteger)badge withIndex:(NSInteger)index onlyDot:(BOOL)onlyDot rightPos:(BOOL)rightPos
{
    NSInteger tagIndex = 888+index;
    DTBadgeView *badgeView = (id)[self viewWithTag:tagIndex];
    UIButton *btn = [self itemWithIndex:index];
    if (badgeView==nil) {
        if (onlyDot) {
            badgeView = [[DTBadgeView alloc] initWithFrame:CGRectMake(0, 0, 7, 7)];
        } else {
            badgeView = [[DTBadgeView alloc] initWithFrame:CGRectMake(0, 0, 14, 14)];
        }
        if (_badgeColor) {
            badgeView.badgeColor = _badgeColor;
        }
        badgeView.onlyDot = onlyDot;
        badgeView.tag = tagIndex;
        btn.transform = CGAffineTransformIdentity;
        [btn addSubview:badgeView];
    }
    
    badgeView.badge = badge;
    
    if (btn) {
        btn.transform = CGAffineTransformIdentity;
        CGSize size = [btn.titleLabel.text sizeWithFont:btn.titleLabel.font];
        CGFloat textWidth = size.width;
        if (rightPos) {
            badgeView.center = CGPointMake(ceilf(btn.width/2+textWidth/2+badgeView.width/2 + 2), ceilf(btn.center.y));
        } else {
            badgeView.center = CGPointMake(ceilf(btn.width/2+textWidth/2+badgeView.width/2 + 2), ceil((btn.height - size.height)/2));
        }
    }
    if (_zoomAnimation) {
        //因为缩放，需要复原算frame
        [self setSelectIndex:_selectIndex];
    }
}

- (DTBadgeView *)badgeViewWithIndex:(NSUInteger)index
{
    NSInteger tagIndex = 888+index;
    DTBadgeView *badgeView = (id)[self viewWithTag:tagIndex];
    return badgeView;
}

@end
