//
//  DTNoDataView.m
//  DrivingTest
//
//  Created by Huang Tao on 12/24/13.
//  Copyright (c) 2013 eclicks. All rights reserved.
//

#import "DTNoDataView.h"

#define kMaxLabelWidth    130

@implementation DTNoDataView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _imgOffset = 0;
        _btnOffset = 0;
        _labOffset = 0;
        
        self.backgroundColor = [UIColor clearColor];
        
        _imgView = [[FLAnimatedImageView alloc] initWithFrame:CGRectMake(floorf((self.width-150)/2), floorf((self.height-100)/2)-60, 150, 100)];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        _imgView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:_imgView];
        
        _msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, _imgView.bottom+20, self.width-80, 30)];
        _msgLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        _msgLabel.backgroundColor = [UIColor clearColor];
//        _msgLabel.textColor = [UIColor colorWithHexString:@"cbcbcb" alpha:1];
        _msgLabel.textColor = APP_CONST_BLUE_COLOR;
        _msgLabel.font = [UIFont systemFontOfSize:16.f];
        _msgLabel.numberOfLines = 0;
        [self addSubview:_msgLabel];
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tapGes];
    }
    return self;
}

- (void)removeFromSuperview
{
    [_imgView stopAnimating];
    [super removeFromSuperview];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize size = [_msgLabel.text sizeWithFont:_msgLabel.font constrainedToSize:CGSizeMake(_msgLabel.width, MAXFLOAT)];
    _msgLabel.height = size.height;
    
//    if (_msgLabel.height > 30) {
//        _msgLabel.textAlignment = NSTextAlignmentLeft;
//    } else {
//        _msgLabel.textAlignment = NSTextAlignmentCenter;
//    }
    _msgLabel.textAlignment = NSTextAlignmentCenter;
    
    CGFloat top = floorf((self.height-100-_labOffset-size.height)/2) - 70 + _imgOffset;
    if (top > 0) {
        NSLog(@"");
    }
    _imgView.top = top;
    _msgLabel.top = _imgView.bottom + _labOffset;
    if(_btn){
        _btn.frame = CGRectMake(80, _msgLabel.bottom + 25 + _btnOffset, self.width-160, 35);
    }
}

- (UILabel *)getMsgLabel
{
    return _msgLabel;
}

- (UIButton *)btn
{
    if(_btn == nil){
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn.frame = CGRectMake(80, _msgLabel.bottom + 25 + _btnOffset, self.width-160, 35);
        [_btn setBackgroundImage:[UIImage imageWithColor:APP_CONST_BLUE_COLOR] forState:UIControlStateNormal];
        [_btn setBackgroundImage:[UIImage imageWithColor:RGB(40,  152, 223)] forState:UIControlStateHighlighted];
        _btn.layer.cornerRadius = 5;
        _btn.layer.masksToBounds = YES;
        [_btn addTarget:self action:@selector(btnAction)];
        [self addSubview:_btn];
    }
    return _btn;
}

- (void)setBtnTitle:(NSString *)btnTitle
{
    [self.btn setTitle:btnTitle forState:UIControlStateNormal];
    [self.btn setTitleFont:FONT(16) color:[UIColor whiteColor]];
    [self layoutSubviews];
}

- (UIButton *)getBtn
{
    return _btn;
}

- (FLAnimatedImageView *)getAniImageView
{
    return _imgView;
}

- (void)setMsg:(NSString *)msg
{
    _msg = msg;
    
    _msgLabel.text = msg;

    [self layoutSubviews];
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    
    if ([image isKindOfClass:[FLAnimatedImage class]] && FLAnimatedImage.class != UIImage.class) {
        SEL sel = NSSelectorFromString(@"setAnimatedImage:");
        if ([_imgView respondsToSelector:sel]) {
            [_imgView performSelector:sel withObject:image];
        } else {
            _imgView.image = image;
        }
    } else {
        _imgView.image = image;
    }
//    _imgView.frame = CGRectMake(floorf((self.width-image.size.width)/2), floorf((self.height-image.size.height)/2)-50, image.size.width, image.size.height);
}

- (void)setImgOffset:(CGFloat)imgOffset
{
    _imgOffset = imgOffset;
    [self layoutSubviews];
}

- (void)setBtnOffset:(CGFloat)btnOffset
{
    _btnOffset = btnOffset;
    [self layoutSubviews];
}

- (void)setLabOffset:(CGFloat)labOffset
{
    _labOffset = labOffset;
    [self layoutSubviews];
}

//- (void)set

- (void)tapAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(noDataViewDidClick:)]) {
        [_delegate noDataViewDidClick:self];
    }
}

- (void)btnAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(noDataViewBtnAction:)]) {
        [_delegate noDataViewBtnAction:self];
    }
}

@end
