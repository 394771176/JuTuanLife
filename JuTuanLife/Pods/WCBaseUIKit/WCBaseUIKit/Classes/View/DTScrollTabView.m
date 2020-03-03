//
//  DTScrollTabView.m
//  DrivingTest
//
//  Created by cheng on 2018/8/7.
//  Copyright © 2018年 eclicks. All rights reserved.
//

#import "DTScrollTabView.h"

@interface DTScrollTabView () <UIScrollViewDelegate> {
    NSMutableArray *_itemViews;
    
    BOOL _fixedSelectLineWidth;
    BOOL _fixedSelectLineGap;
    CGFloat _selectLineGap;
    
    CGRect _markFrame;
    
    BOOL _autoFillWidth;//当前是否自动充满宽度
    CGFloat _autoFillWidthSize;
}

@end

@implementation DTScrollTabView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _fontSize = 17;
        _normalColor = [UIColor colorWithHexString:@"727272"];
        _selectColor = APP_CONST_BLUE_COLOR;
        self.backgroundColor = [UIColor whiteColor];
        
        BPOnePixLineView *line = [[BPOnePixLineView alloc] initWithFrame:CGRectMake(0, self.height-1, self.width, 1)];
        line.lineColor = [UIColor colorWithHexString:@"e5e5e5"];
        line.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
        [self addSubview:line];
        _bottomLine = line;
        
        _fixedSelectLineWidth = YES;
        
        _selectedLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-2, 13, 2)];
//        _selectedLine.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        _selectedLine.backgroundColor = _selectColor;
        _selectedLine.cornerRadius = _selectedLine.height/2;
        _selectedLine.layer.masksToBounds = YES;
        [self addSubview:_selectedLine];
        
        self.delegate = self;
        
        _itemOffset = 5;
        _itemGap = 10;
        _autoFill = YES;
        
        _zoomAnimation = YES;
        
        _selectIndex = 0;
        
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
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
    _selectedLine.backgroundColor = _selectColor;
    
    if (_selectColor) {
        for (UIButton *btn in _itemViews) {
            [btn setTitleColor:_selectColor forState:UIControlStateSelected];
        }
    }
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

- (BOOL)calAutoFillWidthWithItems:(NSArray *)items
{
    if (items.count) {
        UIFont *font = [UIFont systemFontOfSize:_fontSize];
        NSString *string = [items componentsJoinedByString:@""];
        CGFloat width = [string sizeWithFont:font].width;
        width += (_itemOffset * 2 + items.count * (_itemGap * 2));
        
        if (width < self.width) {
            CGFloat itemWidth = self.width / items.count;
            CGFloat markWidth = 0.f;
            NSInteger mark = 0;
            for (NSString * string in items) {
                CGFloat strWidth = [string sizeWithFont:font].width + _itemGap * 2;
                if (strWidth > itemWidth) {
                    markWidth += strWidth;
                    mark ++;
                }
            }
            if (mark < _items.count) {
                _autoFillWidthSize = floor((self.width - _itemOffset * 2 - markWidth) / (items.count - mark));
            } else {
                _autoFillWidthSize = itemWidth;
            }
        }
        
        return width < self.width;
    }
    return NO;
}

- (void)setItems:(NSArray *)items
{
    _items = items;
    if (_itemViews==nil) {
        _itemViews = [NSMutableArray array];
    }
    
    [_itemViews enumerateObjectsUsingBlock:^(UIView * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj) {
            [obj removeFromSuperview];
        }
    }];
    
    if (_autoFill) {
        _autoFillWidth = [self calAutoFillWidthWithItems:items];
    } else {
        _autoFillWidth = NO;
    }

    CGFloat lastOffsetX = _itemOffset;
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
        CGRect rect = [self rectWithIndex:i];
        rect.origin.x = ceilf(lastOffsetX);
        btn.frame = rect;
        btn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        btn.tag = i;
        [self setBtn:btn withIndex:i];
        [self addSubview:btn];
        lastOffsetX = btn.right;
    }
    lastOffsetX += _itemOffset;

    [self bringSubviewToFront:_selectedLine];
    
    self.contentSize = CGSizeMake(lastOffsetX, self.height);
    
    if (_selectIndex < _items.count) {
        self.selectIndex = _selectIndex;
    } else {
        self.selectIndex = 0;
    }
}

- (UIButton *)createItemWithIndex:(NSInteger)index
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:_normalColor forState:UIControlStateNormal];
    [btn setTitleColor:_selectColor forState:UIControlStateSelected];
    return btn;
}

- (CGRect)rectWithIndex:(NSInteger)index
{
    if (_items.count<=0) {
        return CGRectZero;
    }

    NSString *string = [self titleWithIndex:index];
    CGFloat w = [string sizeWithFont:[UIFont systemFontOfSize:_fontSize]].width + _itemGap * 2;
    if (_autoFillWidth) {
        if (w > _autoFillWidthSize) {
            return CGRectMake(ceilf(w*index), 0, w, self.height);
        } else {
            return CGRectMake(ceilf(w*index), 0, _autoFillWidthSize, self.height);
        }
    } else {
        return CGRectMake(ceilf(w*index), 0, w, self.height);
    }
    return CGRectZero;
}

- (NSString *)titleWithIndex:(NSInteger)index
{
    id title = [_items safeObjectAtIndex:index];
    if ([title isKindOfClass:[NSString class]]) {
        return title;
    } else {
        if ([title respondsToSelector:@selector(title)]) {
            return [title title];
        }
    }
    return nil;
}

- (DTTabItem *)configTabItemOfIndex:(NSInteger)index
{
    if (_configDict) {
        return [_configDict objectForKey:[NSString stringWithFormat:@"%ld", index]];
    }
    return nil;
}

- (void)setBtn:(UIButton *)btn withIndex:(NSInteger)index
{
    DTTabItem *item = [self configTabItemOfIndex:index];
    if (item.icon.length) {
        [btn setTitle:nil];
        btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
//        [btn sd_setImageWithURL:[NSURL URLWithString:item.icon] forState:UIControlStateNormal placeholderImage:[UIImage imageWithColorString:@"d9d9d9"]];
//        if (item.icon_selected) {
//            [btn sd_setImageWithURL:[NSURL URLWithString:item.icon_selected] forState:UIControlStateSelected placeholderImage:[UIImage imageWithColorString:@"d9d9d9"]];
//        }
    } else {
        [btn setImageWithImageName:nil];
        [btn setTitle:[self titleWithIndex:index]];
    }
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
        return;
    }
    if (_items.count) {
        if (scrollView.contentOffset.x > (scrollView.width * _selectIndex)) {
            UIButton *btn1 = [self itemWithIndex:_selectIndex];
            CGFloat distance = 0.f;
            if (_selectIndex < _items.count - 1) {
                UIButton *btn2 = [self itemWithIndex:_selectIndex + 1];
                distance = btn2.center.x - btn1.center.x;
            } else {
                distance = btn1.width /2;
            }
            CGFloat offsetX = (scrollView.contentOffset.x - (scrollView.width * _selectIndex))/ (scrollView.width / distance);
            [self setSelectedLineCenterOffSet:offsetX];
        } else {
            UIButton *btn1 = [self itemWithIndex:_selectIndex];
            CGFloat distance = 0.f;
            if (_selectIndex > 0) {
                UIButton *btn2 = [self itemWithIndex:_selectIndex - 1];
                distance = btn1.center.x - btn2.center.x;
            } else {
                distance = btn1.width /2;
            }
            CGFloat offsetX = (scrollView.contentOffset.x - (scrollView.width * _selectIndex))/ (scrollView.width / distance);
            [self setSelectedLineCenterOffSet:offsetX];
        }
    }
}

- (void)setSelectedLineWidth:(CGFloat)width
{
    _fixedSelectLineGap = NO;
    _fixedSelectLineWidth = YES;
    _selectedLine.width = width;
    UIButton *btn = [self itemWithIndex:_selectIndex];
    if (btn) {
        _selectedLine.frame = CGRectMake(btn.left+(btn.width/2-_selectedLine.width/2), _selectedLine.top, _selectedLine.width, _selectedLine.height);
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
        
        //btn title color 变化不需要放在动画里面
        for (UIButton *btn in _itemViews) {
            btn.selected = (btn.tag == _selectIndex);
        }
        
        NSInteger showEndIndex = _selectIndex + 2;
        CGFloat rightOffset = 0;
        if (showEndIndex >= _items.count - 1) {
            rightOffset = self.contentSize.width;
        } else {
            UIButton *btn = [self itemWithIndex:showEndIndex];
            rightOffset = btn.right;
        }
        
        if (rightOffset > self.width) {
            [self setContentOffset:CGPointMake(rightOffset - self.width, 0) animated:YES];
        } else {
            [self setContentOffset:CGPointZero animated:YES];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _bottomLine.left = scrollView.contentOffset.x;
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
        } else {
            [btn setBackgroundColor:[UIColor clearColor]];
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
            _selectedLine.frame = CGRectMake(btn.centerX-_selectedLine.width/2, _selectedLine.top, _selectedLine.width, _selectedLine.height);
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
    if (_tDelegate) {
        [_tDelegate tabBarViewDidSelectIndex:sender.tag];
    }
}

@end
