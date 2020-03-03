//
//  DTBadgeView.m
//  DrivingTest
//
//  Created by kent on 10/10/14.
//  Copyright (c) 2014 eclicks. All rights reserved.
//

#import "DTBadgeView.h"

@interface DTBadgeView () {
    UILabel *_label;
    UIImageView *_bgView;
}

@end

@implementation DTBadgeView

@dynamic font;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
        
        _bgView = [[UIImageView alloc] initWithFrame:self.bounds];
        _bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview:_bgView];
        
        _label = [[UILabel alloc] initWithFrame:self.bounds];
        _label.backgroundColor = [UIColor clearColor];
        _label.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont systemFontOfSize:12];
        _label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        [self addSubview:_label];
        
        _maxBadge = 99;
        _badgeHeight = self.height;
        self.dotWidth = MIN(8, _badgeHeight);
//        self.badgeColor = [UIColor redColor];
        self.badgeColor = APP_CONST_PINK_COLOR;
        
        _bgView.image = [UIImage imageWithColor:_badgeColor cornerRadius:self.height/2 withSize:self.size];
        
        self.hidden = YES;
    }
    return self;
}

- (void)setFont:(UIFont *)font
{
    _label.font = font;
    if (font.pointSize>_badgeHeight) {
        self.badgeHeight = font.pointSize+2;
    }
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    _label.textColor = textColor;
}

- (void)setBadgeHeight:(CGFloat)badgeHeight
{
    _badgeHeight = badgeHeight;
}

- (void)setBadgeColor:(UIColor *)badgeColor
{
    _badgeColor = badgeColor;
    
    _bgView.image = [UIImage imageWithColor:_badgeColor cornerRadius:self.height/2 withSize:self.size];
}

- (void)setOnlyDot:(BOOL)onlyDot
{
    _onlyDot = onlyDot;
    if (_onlyDot) {
        
    } else {
//        self.layer.shadowOffset = CGSizeMake(0, 2);
//        self.layer.shadowColor = APP_CONST_PINK_COLOR.CGColor;
//        self.layer.shadowOpacity = 0.5;
    }
}

- (void)setBadge:(NSUInteger)badge
{
    _badge = badge;
    [self updateTextAndSize];
}

- (NSString *)badgeText
{
    if (_onlyDot) {
        return @"";
    } else {
        if (_translateNum) {
            return [NSString formatNum1W:_badge];
        } else {
            if (_badge>_maxBadge) {
                if (_badgeTrail.length) {
                    return [NSString stringWithFormat:@"%zd%@", _maxBadge, _badgeTrail];
                } else {
                    return STRING(_maxBadge);
                }
            } else {
                return [NSString stringWithFormat:@"%ld", _badge];
            }
        }
    }
}

- (void)updateTextAndSize
{
    CGSize size = CGSizeZero;
    if (_badge>0) {
        NSString *text = [self badgeText];
        if (_onlyDot) {
            size.width = size.height = _dotWidth;
        } else {
            size.height = _badgeHeight;
            CGFloat width = [text sizeWithFont:_label.font].width+_badgeHeight / 2;
            if (width < _badgeHeight + 3) {
                //修正，宽度只比高度大一点点，还是维持圆形
                size.width = _badgeHeight;
            } else {
                size.width = width;
            }
        }
        if (!CGSizeEqualToSize(self.size, size)) {
            self.size = size;
            _bgView.image = [UIImage imageWithColor:_badgeColor cornerRadius:size.height/2 withSize:size];
        }
        _label.text = text;
        self.hidden = NO;
    } else {
        self.hidden = YES;
    }
}

@end
