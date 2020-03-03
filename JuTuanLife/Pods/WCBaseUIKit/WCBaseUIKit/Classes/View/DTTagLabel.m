//
//  DTTagLabel.m
//  DrivingTest
//
//  Created by cheng on 17/1/16.
//  Copyright © 2017年 eclicks. All rights reserved.
//

#import "DTTagLabel.h"
#import "WCUICommon.h"

@implementation DTTagLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textAlignment = NSTextAlignmentCenter;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.textAlignment = NSTextAlignmentCenter;
}

- (void)setGap:(CGFloat)gap
{
    _gap = gap;
    if (self.text.length) {
        self.width = [self getTextWidth] + gap * 2;
    }
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    self.width = [self getTextWidth] + _gap * 2;
}

- (void)setLabelWidthWithString:(NSString *)string
{
    self.text = string;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor cornerRadius:(CGFloat)cornerRadius
{
    [self setBackgroundColor:backgroundColor];
    self.cornerRadius = cornerRadius;
    if (cornerRadius > 0.f) {
        self.layer.masksToBounds = YES;
    }
}

- (void)setBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius
{
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = borderWidth;
    self.cornerRadius = cornerRadius;
    if (cornerRadius > 0.f) {
        self.layer.masksToBounds = YES;
    }
}

@end
