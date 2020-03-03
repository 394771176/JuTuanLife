//
//  DTGradientLabel.m
//  DrivingTest
//
//  Created by cheng on 2018/12/11.
//  Copyright © 2018 eclicks. All rights reserved.
//

#import "DTGradientLabel.h"
#import "WCUICommon.h"

@interface DTGradientLabel () {
    UILabel *_textLabel;
    
    CAGradientLayer *_gradientLayer;
}

@end

@implementation DTGradientLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _textLabel = [UILabel labelWithFrame:self.bounds fontSize:16 colorString:@"000000"];
        _textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview:_textLabel];
    }
    return self;
}

- (void)setFromColor:(UIColor *)fromColor
{
    _fromColor = fromColor;
    if (_textLabel.text.length) {
        self.text = _textLabel.text;
    }
}

- (void)setToColor:(UIColor *)toColor
{
    _toColor = toColor;
    if (_textLabel.text.length) {
        self.text = _textLabel.text;
    }
}

- (void)setFont:(UIFont *)font
{
    _textLabel.font = font;
}

- (void)setTextColor:(UIColor *)textColor
{
    _textLabel.textColor = textColor;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    _textLabel.textAlignment = textAlignment;
}

- (void)setText:(NSString *)text
{
    if (self.fromColor && self.toColor) {
        if (_gradientLayer) {
            [_gradientLayer removeFromSuperlayer];
            _gradientLayer = nil;
        }
        
        if (_textLabel.superview) {
            [_textLabel removeFromSuperview];
        }
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];//
        gradientLayer.colors = @[(__bridge id)self.fromColor.CGColor,(__bridge id)self.toColor.CGColor];
        gradientLayer.locations = @[@0.0, @1.0];
        gradientLayer.startPoint = CGPointMake(0.5, 0);
        //            CGFloat ras = cos((M_PI/180 * 75));
        //            gradientLayer.endPoint = CGPointMake(1 * ras, 0);
        gradientLayer.endPoint = CGPointMake(0.5, 1);
        gradientLayer.frame = self.bounds;
        [self.layer insertSublayer:gradientLayer atIndex:0];
        _gradientLayer = gradientLayer;
        
        _gradientLayer.mask = _textLabel.layer;
    } else {
        
    }
    
    if ([text isKindOfClass:[NSAttributedString class]]) {
        _textLabel.attributedText = (id)text;
        return;
    }
    
    _textLabel.text = text;
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    _textLabel.attributedText = attributedText;
}

- (CGFloat)getTextWidth
{
    return [_textLabel getTextWidth];
}

- (void)setLabelWidthWithString:(NSString *)string
{
    _textLabel.text = string;
    self.width = [_textLabel getTextWidth];
}

@end
