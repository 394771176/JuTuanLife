//
//  DTUISegmentView.m
//  DrivingTest
//
//  Created by Kent on 14-3-4.
//  Copyright (c) 2014年 eclicks. All rights reserved.
//

#import "DTUISegmentView.h"
#import "DTBadgeView.h"

#define DTSegTag 200

@interface DTUISegmentView () {
    
}

@end

@implementation DTUISegmentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _fontSize = 14.f;
        _selectedColor = APP_CONST_BLUE_COLOR;
        _selectedFontColor = [UIColor whiteColor];
        _unselectedFontColor = _selectedColor;
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius  = 4;
        self.layer.borderWidth   = 1;
        self.layer.borderColor   = _selectedColor.CGColor;
    }
    return self;
}

- (DTUISegmentView *)initWithFrame:(CGRect)frame delegate:(id<DTUISegmentViewDelegate>)delegate
{
    self = [self initWithFrame:frame];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (DTUISegmentView *)initWithFrame:(CGRect)frame titles:(NSArray *)titles
{
    self = [self initWithFrame:frame];
    if (self) {
        self.titles = titles;
    }
    return self;
}

- (void)setTitles:(NSArray *)titles
{
    _titles = titles;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat fwidth = self.width/titles.count;
    for (int i = 0; i < titles.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.exclusiveTouch = YES;
        btn.frame = CGRectMake(i*fwidth, 0, fwidth, self.height);
        [btn setTitle:[titles safeObjectAtIndex:i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:_fontSize];
        btn.tag = DTSegTag+i;
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:btn];
        
        if (i<titles.count-1) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(btn.right-1, 0, 1, self.height)];
            line.backgroundColor = _selectedColor;
            [self addSubview:line];
        }
    }
    self.selectedIndex = _selectedIndex;
}

- (void)setFontSize:(CGFloat)fontSize
{
    for (UIButton *btn in self.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            [btn.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
        }
    }
}

- (void)setSelectedColor:(UIColor *)selectedColor selectedFontColor:(UIColor *)selFontColor
{
    [self setSelectedColor:selectedColor selectedFontColor:selFontColor unselectedFontColor:selectedColor];
}

- (void)setSelectedColor:(UIColor *)selectedColor selectedFontColor:(UIColor *)selFontColor unselectedFontColor:(UIColor *)unselFontColor
{
    _selectedColor = selectedColor;
    _selectedFontColor = selFontColor;
    _unselectedFontColor = unselFontColor;
    [self updateColor];
}

- (void)updateColor
{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (id)view;
            [btn setBackgroundColor:(btn.tag==DTSegTag+_selectedIndex?_selectedColor:[UIColor clearColor])];
            [btn setTitleColor:(btn.tag==DTSegTag+_selectedIndex?_selectedFontColor:_unselectedFontColor) forState:UIControlStateNormal];
        } else if ([view isKindOfClass:[UIView class]]) {
            view.backgroundColor = _selectedColor;
        }
    }
    self.layer.borderColor   = _selectedColor.CGColor;
}

- (void)btnClicked:(UIButton *)btn
{
    NSInteger index = btn.tag - DTSegTag;
    self.selectedIndex = index;
    if (_delegate&&[_delegate respondsToSelector:@selector(segmentedControl:didSelectedIndex:)]) {
        [_delegate segmentedControl:self didSelectedIndex:_selectedIndex];
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    for (UIButton *btn in self.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            [btn setBackgroundColor:(btn.tag==DTSegTag+selectedIndex?_selectedColor:[UIColor clearColor])];
            [btn setTitleColor:(btn.tag==DTSegTag+selectedIndex?_selectedFontColor:_unselectedFontColor) forState:UIControlStateNormal];
        }
    }
}

- (void)setBadge:(NSInteger)badge withIndex:(NSInteger)index
{
    UIButton *button = (UIButton *)[self viewWithTag:(DTSegTag+index)];
    if (button) {
        DTBadgeView *badgeView = [button viewWithTag:888];
        if (badge>0&&badgeView==nil) {
            badgeView = [[DTBadgeView alloc] initWithFrame:CGRectMake(button.width-8, 2, 8, 8)];
            badgeView.tag = 888;
            badgeView.onlyDot = YES;
            badgeView.left = [button.titleLabel getTextWidth]/2+button.width/2;
            if (badgeView.right>button.width) badgeView.right = button.width;
            [button addSubview:badgeView];
        }
        badgeView.badge = badge;
    }
}

@end
