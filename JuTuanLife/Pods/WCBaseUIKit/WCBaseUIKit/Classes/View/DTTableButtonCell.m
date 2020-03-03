//
//  DTTableButtonCell.m
//  ChelunWelfare
//
//  Created by cheng on 15/1/8.
//  Copyright (c) 2015年 Wang Peng. All rights reserved.
//

#import "DTTableButtonCell.h"
#import "CWStaticImageManager.h"

@interface DTTableButtonCell () {

}

@end

@implementation DTTableButtonCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyleClear];
        
        _corner = 5.f;
        
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitBtn.frame = CGRectMake(30, self.contentView.height/2-20, self.contentView.width-60, 40);
        [_submitBtn addTarget:self action:@selector(submitBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _submitBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _submitBtn.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.contentView addSubview:_submitBtn];
    }
    return self;
}

- (void)setCorner:(CGFloat)corner
{
    _corner = corner;
    self.style = _style;
}

- (void)setStyle:(DTTableButtonStyle)style
{
    _style = style;
    if (style==DTTableButtonStyleGray) {
        _submitBtn.userInteractionEnabled = NO;
        [self setButtonTitleColor:[UIColor whiteColor]];
        [self setButtonBorderColor:nil withBgColorStr:@"d9d9d9"];
    } else if (style==DTTableButtonStyleGrayWhite) {
        _submitBtn.userInteractionEnabled = NO;
        [self setButtonTitleColor:[UIColor colorWithHexString:@"969696"]];
        [self setButtonBorderColor:[UIColor colorWithHexString:@"e5e5e5"] withBgColorStr:@"ffffff"];
    } else {
        _submitBtn.userInteractionEnabled = YES;
        if (style==DTTableButtonStyleRed) {
            [self setButtonTitleColor:[UIColor whiteColor]];
            [self setButtonBorderColor:nil withBgColorStr:APP_CONST_RED_STRING];//f34a2e
            [_submitBtn setBackgroundImage:[[CWStaticImageManager sharedInstance] imageWithColorHex:@"d94f4f" size:_submitBtn.size corner:_corner] forState:UIControlStateHighlighted];
        } else if (style==DTTableButtonStyleGreen) {
            [self setButtonTitleColor:[UIColor whiteColor]];
            [self setButtonBorderColor:nil withBgColorStr:@"27b83b"];
            [_submitBtn setBackgroundImage:[[CWStaticImageManager sharedInstance] imageWithColorHex:@"39961c" size:_submitBtn.size corner:_corner] forState:UIControlStateHighlighted];
        } else if (style==DTTableButtonStyleBlue) {
            [self setButtonTitleColor:[UIColor whiteColor]];
            [self setButtonBorderColor:nil withBgColorStr:APP_CONST_BLUE_STRING];
            [_submitBtn setBackgroundImage:[[CWStaticImageManager sharedInstance] imageWithColorHex:@"2898df" size:_submitBtn.size corner:_corner] forState:UIControlStateHighlighted];
        } else if (style==DTTableButtonStyleRedWhite) {
            [self setButtonTitleColor:[UIColor colorWithHexString:@"f34a2e"]];
            [self setButtonBorderColor:[UIColor colorWithHexString:@"f34a2e"] withBgColorStr:@"ffffff"];
            [_submitBtn setBackgroundImage:[[CWStaticImageManager sharedInstance] imageWithColorHex:@"e5e5e5" size:_submitBtn.size corner:_corner] forState:UIControlStateHighlighted];
        } else if (style==DTTableButtonStyleGreenWhite) {
            [self setButtonTitleColor:[UIColor colorWithHexString:@"27b83b"]];
            [self setButtonBorderColor:[UIColor colorWithHexString:@"27b83b"] withBgColorStr:@"ffffff"];
            [_submitBtn setBackgroundImage:[[CWStaticImageManager sharedInstance] imageWithColorHex:@"e5e5e5" size:_submitBtn.size corner:_corner] forState:UIControlStateHighlighted];
        } else if (style==DTTableButtonStyleBlueWhite) {
            [self setButtonTitleColor:APP_CONST_BLUE_COLOR];
            [self setButtonBorderColor:APP_CONST_BLUE_COLOR withBgColorStr:@"ffffff"];
            [_submitBtn setBackgroundImage:[[CWStaticImageManager sharedInstance] imageWithColorHex:@"e5e5e5" size:_submitBtn.size corner:_corner] forState:UIControlStateHighlighted];
        }
    }
}

- (void)setButtonTop:(CGFloat)top
{
    _submitBtn.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _submitBtn.top = top;
}

- (void)setButtonTitleColor:(UIColor *)color
{
    [_submitBtn setTitleColor:color forState:UIControlStateNormal];
}

- (void)setButtonImage:(UIImage *)image
{
    [_submitBtn setImage:image forState:UIControlStateNormal];
}

- (void)setButtonTitle:(NSString *)title
{
    [_submitBtn setTitle:title forState:UIControlStateNormal];
}

- (void)setButtonBgColor:(UIColor *)color
{
    [_submitBtn setBackgroundImage:[UIImage imageWithColor:color cornerRadius:_corner withSize:_submitBtn.size] forState:UIControlStateNormal];
}

- (void)setButtonBgColorStr:(NSString *)colorStr
{
    [_submitBtn setBackgroundImage:[[CWStaticImageManager sharedInstance] imageWithColorHex:colorStr size:_submitBtn.size corner:_corner] forState:UIControlStateNormal];
}

- (void)setButtonTitle:(NSString *)title withBgColorStr:(NSString *)colorStr
{
    [self setButtonTitle:title];
    [self setButtonBgColorStr:colorStr];
}

- (void)setButtonTitle:(NSString *)title withTitleColor:(UIColor *)color
{
    [self setButtonTitle:title];
    [self setButtonTitleColor:color];
}

- (void)setButtonBorderColor:(UIColor *)color withBgColorStr:(NSString *)colorStr
{
    if (color) {
        _submitBtn.layer.borderColor = color.CGColor;
        _submitBtn.layer.borderWidth = 1;
        _submitBtn.layer.cornerRadius = _corner;
        _submitBtn.layer.masksToBounds = YES;
    } else {
        _submitBtn.layer.borderWidth = 0.f;
    }
    if (colorStr) {
        [self setButtonBgColorStr:colorStr];
    }
}

- (void)setButtonHorGap:(CGFloat)gap
{
    _submitBtn.left = gap;
    _submitBtn.right = self.contentView.width-2*gap;
}

- (void)submitBtnAction
{
    [_delegate tableButtonCellDidClickAction:self];
}

@end
