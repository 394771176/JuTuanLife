//
//  CLTitleTabView.m
//  CLCommon
//
//  Created by cheng on 14-10-27.
//  Copyright (c) 2014年 eclicks. All rights reserved.
//

#import "CLTitleTabView.h"
#import "DTBadgeView.h"

@interface CLTitleTabView () {
    NSMutableArray *_viewItems;
}

@end

@implementation CLTitleTabView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _fontSize = 16;
        _selectFontSize = 18;
        _tabType = CLTabTypeEqualWidth;
        
        _fontColor = [UIColor colorWithHexString:@"969696"];
        _selectFontColor = APP_CONST_BLACK_COLOR;
        _onlyDot = YES;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withDelegate:(id<CLTitleTabViewDelegate>)delegate
{
    self = [self initWithFrame:frame];
    if (self) {
        _delegate = delegate;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame items:(NSArray *)items
{
    self = [self initWithFrame:frame];
    if (self) {
        self.items = items;
    }
    return self;
}

- (void)setItems:(NSArray *)items
{
    _items = items;
    if (_viewItems==nil) {
        _viewItems = [NSMutableArray array];
    }
    [_viewItems makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_viewItems removeAllObjects];
    CGFloat width = self.width/items.count;
    for (int i=0; i<items.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(width*i, 0, width, self.height);
        btn.tag = i;
        [btn setTitle:items[i] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:_selectFontSize]];
        [btn setTitleColor:_selectFontColor forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [_viewItems addObject:btn];
    }
    
    [self layoutSubviews];
}

- (UIButton *)buttonWithIndex:(NSInteger)index
{
    if (index<_viewItems.count) {
        return _viewItems[index];
    }
    return nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_viewItems.count>0) {
        CGFloat width = self.width/_viewItems.count;
        CGFloat pos_x = 0.f;
        for (int i=0; i<_viewItems.count; i++) {
            UIButton *btn = _viewItems[i];
            
            if (_tabType == CLTabTypeEqualWidth) {
                btn.frame = CGRectMake(width*i, 0, width, self.height);
            } else {
                CGFloat sum = 0.f;
                if (_tabType == CLTabTypeEqualSpace) {
                    for (int i=0; i<_viewItems.count; i++) {
                        UIButton *btn = _viewItems[i];
                        sum += [btn.titleLabel getTextWidth];
                    }
                }
                CGFloat space = (self.width - sum) / ([_viewItems count] * 2);
                
                CGFloat textWidth = [btn.titleLabel getTextWidth];
                btn.frame = CGRectMake(pos_x, 0, textWidth + space * 2, self.height);
                pos_x = btn.right;
            }
        }
    }
}

- (void)setSelectIndex:(NSInteger)selectIndex animated:(BOOL)animated
{
    _selectIndex = selectIndex;
    if (!_forbidAnimation) {
        if (animated) {
            [UIView animateWithDuration:0.25 animations:^{
                [self updateStatus];
            }];
        } else {
            [self updateStatus];
        }
    } else {
        for (UIButton *btn in _viewItems) {
            if (btn.tag==_selectIndex) {
                [btn.titleLabel setFont:[UIFont systemFontOfSize:_selectFontSize]];
                [btn setTitleColor:_selectFontColor forState:UIControlStateNormal];
            } else {
                [btn.titleLabel setFont:[UIFont systemFontOfSize:_fontSize]];
                [btn setTitleColor:_fontColor forState:UIControlStateNormal];
            }
        }
    }
}

- (void)setSelectIndex:(NSInteger)selectIndex
{
    [self setSelectIndex:selectIndex animated:YES];
}

- (void)updateStatus
{
    for (UIButton *btn in _viewItems) {
        if (btn.tag==_selectIndex) {
            [btn setTransform:CGAffineTransformIdentity];
            [btn setTitleColor:_selectFontColor forState:UIControlStateNormal];
        } else {
            [btn setTransform:CGAffineTransformMakeScale(0.88, 0.88)];
            [btn setTitleColor:_fontColor forState:UIControlStateNormal];
        }
    }
}

- (void)buttonAction:(UIButton *)sender
{
    self.selectIndex = sender.tag;
    [_delegate titleTabView:self didSelectIndex:sender.tag];
}

- (CGFloat)getOffsetWithScrollView:(UIScrollView *)scrollView
{
    CGFloat x = scrollView.contentOffset.x;
    NSInteger index = floorf(x/scrollView.width);
    CGFloat of = x - scrollView.width*index;
    if (index>=_viewItems.count-1) {
        CGFloat resultToSelf = [[self viewItemWithIndex:_viewItems.count-1] center].x;
        return [self getWindowOffsetWithCurrentOffset:resultToSelf];
    } else if (index<0) {
        index = 0;
        of = 0;
    }
    CGFloat start = [[self viewItemWithIndex:index] center].x;
    CGFloat end = [[self viewItemWithIndex:index+1] center].x;
    CGFloat resultToSelf = (of/scrollView.width>0.5f?end:start);
    return [self getWindowOffsetWithCurrentOffset:resultToSelf];
}

- (UIView *)viewItemWithIndex:(NSInteger)index
{
    return [_viewItems safeObjectAtIndex:index];
}

- (CGFloat)getOffsetWithCurrentIndex
{
    CGFloat resultToSelf = [[self viewItemWithIndex:_selectIndex] center].x;
    return [self getWindowOffsetWithCurrentOffset:resultToSelf];
}

- (CGFloat)getWindowOffsetWithCurrentOffset:(CGFloat)offset
{
    if (self.window) {
        return [[[[UIApplication sharedApplication] delegate] window] convertPoint:CGPointMake(offset, 0) fromView:self].x;
    } else {
        return [UIScreen mainScreen].bounds.size.width/2.0f-self.width/2.0f+offset;
    }
}

- (void)setBadge:(int)badge index:(int)index
{
    NSInteger tagIndex = 38028+index;
    DTBadgeView *badgeView = (id)[self viewWithTag:tagIndex];
    if (badgeView==nil) {
        if (_onlyDot) {
            badgeView = [[DTBadgeView alloc] initWithFrame:CGRectMake(0, 0, 7, 7)];
        } else {
            badgeView = [[DTBadgeView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
        }

        badgeView.onlyDot = _onlyDot;
        badgeView.tag = tagIndex;
        [self addSubview:badgeView];
    }
//    CGFloat width = self.width/_viewItems.count;
    if (index<_viewItems.count) {
        UIButton *btn = _viewItems[index];
        CGFloat textWidth = [btn.titleLabel getTextWidth];
        
        if (_onlyDot) {
            badgeView.center = CGPointMake(floorf(btn.center.x+textWidth/2-2)+badgeView.width/2, 14.5);
        } else {
            badgeView.center = CGPointMake(floorf(btn.center.x+textWidth/2-2)+badgeView.width/2-4, 14.5);
        }
    }
    
    badgeView.badge = badge;
}

@end
