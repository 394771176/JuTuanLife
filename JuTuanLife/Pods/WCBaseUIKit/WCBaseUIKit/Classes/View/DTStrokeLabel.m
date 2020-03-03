//
//  DTStrokeLabel.m
//  DrivingTest
//
//  Created by cheng on 2017/9/20.
//  Copyright © 2017年 eclicks. All rights reserved.
//

#import "DTStrokeLabel.h"
#import "WCUICommon.h"

@implementation DTStrokeLabel

- (void)drawRect:(CGRect)rect {
    CGSize shadowOffset = self.shadowOffset;
    UIColor *textColor = self.textColor;
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(c, (_strokeWidth?_strokeWidth.floatValue:1));
    CGContextSetLineJoin(c, kCGLineJoinRound);
    
    CGContextSetTextDrawingMode(c, kCGTextStroke);
    self.textColor = self.strokeColor;
    [super drawTextInRect:self.bounds];
    
    CGContextSetTextDrawingMode(c, kCGTextFill);
    self.textColor = textColor;
    self.shadowOffset = CGSizeMake(0, 0);
    [super drawTextInRect:self.bounds];
    
    self.shadowOffset = shadowOffset;
}

- (void)setStrokeColorStr:(NSString *)strokeColorStr
{
    _strokeColorStr = strokeColorStr;
    self.strokeColor = [UIColor colorWithString:strokeColorStr];
}

- (void)setStrokeColor:(UIColor *)strokeColor
{
    _strokeColor = strokeColor;
    if (self.text.length) {
        [self setNeedsDisplay];
    }
}

- (CGFloat)getTextWidth
{
    return [self textRectForBounds:CGRectMake(0, 0, FLT_MAX, self.height) limitedToNumberOfLines:1].size.width;
}

- (void)setLabelWidthWithString:(NSString *)string
{
    self.text = string;
    self.width = [self getTextWidth];
}

@end
