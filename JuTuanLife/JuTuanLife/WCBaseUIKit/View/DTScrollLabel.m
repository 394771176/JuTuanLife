//
//  DTScrollLabel.m
//  DrivingTest
//
//  Created by cheng on 2017/10/24.
//  Copyright © 2017年 eclicks. All rights reserved.
//

#import "DTScrollLabel.h"
#import "WCUICommon.h"

@interface DTScrollLabel () {
    UILabel *_label1, *_label2;
    
    BOOL _isAnimation;
    BOOL _stopAnimation;
    
    CGFloat _duration;
}

@end

@implementation DTScrollLabel

- (void)dealloc
{
    [self stopAnimation];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        _scrollGap = 32;
    }
    return self;
}

- (UILabel *)getSubLabel
{
    UILabel *label = [UILabel labelWithFrame:self.bounds font:self.font color:self.textColor];
    label.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;;
    label.textAlignment = self.textAlignment;
    label.adjustsFontSizeToFitWidth = YES;
    [self addSubview:label];
    return label;
}

- (NSString *)text
{
    return _label1.text;
}

- (void)setText:(NSString *)text
{
    if (!_label1) {
        _label1 = [self getSubLabel];
    }
    [_label1 setText:text];
    CGFloat width = [_label1 getTextWidth];
    if (width > self.width + 5) {
        if (!_label2) {
            _label2 = [self getSubLabel];
        }
        _label2.text = text;
        _label1.width = _label2.width = width;
        _label1.left = 0;
        _label2.left = _label1.right + _scrollGap;
        _duration = (_label1.width + _scrollGap)/100 * 3.5;
        [self beginAnimation];
    } else {
        _label1.left = 0;
        _label1.width = self.width;
        [self stopAnimation];
        if (_label2) {
            [_label2 removeFromSuperview];
            _label2 = nil;
        }
    }
}

- (void)beginAnimation
{
    _stopAnimation = NO;
    if (!_isAnimation) {
        [self beginAnimationWithDelay:2];
    }
}

- (void)beginAnimationWithDelay:(CGFloat)delay
{
    if (!_stopAnimation) {
        _isAnimation = YES;
        [UIView animateWithDuration:_duration delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
            _label1.right = - _scrollGap;
            _label2.left = 0;
        } completion:^(BOOL finished) {
            if (_label2) {
                UILabel *label = _label1;
                _label1 = _label2;
                _label2 = label;
            }
            _label1.left = 0;
            _label2.left = _label1.right + _scrollGap;
            _isAnimation = NO;
            if (!_stopAnimation) {
                [self beginAnimationWithDelay:0.f];
            }
        }];
    }
}

- (void)stopAnimation
{
    _stopAnimation = YES;
    [_label1.layer removeAllAnimations];
    [_label2.layer removeAllAnimations];
    _label1.left = 0;
    if (_label2) {
        _label2.left = _label1.right + _scrollGap;
    }
}

- (void)setTextColor:(UIColor *)textColor
{
    [super setTextColor:textColor];
    _label1.textColor = textColor;
    _label2.textColor = textColor;
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    _label1.font = font;
    _label2.font = font;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    [super setTextAlignment:textAlignment];
    _label1.textAlignment = textAlignment;
    _label2.textAlignment = textAlignment;
}

@end
