//
//  SCLoginPhoneCell.m
//  SuperCoach
//
//  Created by cheng on 17/4/27.
//  Copyright © 2017年 Lin Feihong. All rights reserved.
//

#import "SCLoginTextFieldCell.h"

#define SC_LOGIN_CODE_TIME_COUNT 60

@interface SCLoginTextFieldCell () {
    
}

@end

@implementation SCLoginTextFieldCell

@synthesize text = _text;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _bodyView = [[UIView alloc] initWithFrame:CGRectMake(40, self.contentView.height - 40, self.contentView.width - 40 * 2, 40)];
        _bodyView.backgroundColor = [UIColor clearColor];
        _bodyView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [self.contentView addSubview:_bodyView];
        
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, _bodyView.height)];
        _iconView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _iconView.contentMode = UIViewContentModeCenter;
        [_bodyView addSubview:_iconView];
        
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(_iconView.right + 12, 0, _bodyView.width - _iconView.right - 12, _bodyView.height)];
        _textField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _textField.font = [UIFont systemFontOfSize:15];
        [_textField setTextColor:[UIColor colorWithHexString:@"333333"]];
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.delegate = self;
        [_textField addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
        [_bodyView addSubview:_textField];
        
        [self setSeparatorLineWithLeft:40];
        
        [self setSelectionStyleNone];
    }
    return self;
}

- (void)setIcon:(UIImage *)icon
{
    _icon = icon;
    _iconView.image = icon;
}

- (void)setIconWithName:(NSString *)iconName
{
    [_iconView setImageWithName:iconName];
}

- (void)setleftGap:(CGFloat)leftGap textHeight:(CGFloat)textHeight
{
    [self setSeparatorLineWithLeft:leftGap];
    if (textHeight > self.contentView.height) {
        self.height = self.contentView.height = textHeight + 1;
    }
    _bodyView.frame = CGRectMake(leftGap, self.contentView.height - textHeight, self.contentView.width - leftGap * 2, textHeight);
}

- (void)hiddenIcon:(BOOL)hidden
{
    _iconView.hidden = hidden;
    if (hidden) {
        _textField.frame = CGRectMake(0, _textField.top, _textField.right, _textField.height);
    } else {
        _textField.frame = CGRectMake(_iconView.right + 12, _textField.top, _textField.right - _iconView.right - 12, _textField.height);
    }
}

- (void)setType:(SCLoginTextFieldType)type
{
    _type = type;
    
    [_textField setSecureTextEntry:NO];
    switch (type) {
        case SCLoginTextFieldTypePhone:
        {
            self.maxTextLength = 11;
            [self setPlacehloderWithDefault:@"请输入手机号"];
            _textField.keyboardType = UIKeyboardTypePhonePad;
            if (!_icon) {
                [self setIconWithName:@"login_icon_phone"];
            }
        }
            break;
        case SCLoginTextFieldTypeCode:
        {
            //目前4位，支持到6位
            self.maxTextLength = 6;
            [self setPlacehloderWithDefault:@"请输入验证码"];
//            _textField.keyboardType = UIKeyboardTypeNumberPad;
            //这样会调用系统键盘，才能自动识别短信验证码
//            _textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            _textField.keyboardType = UIKeyboardTypePhonePad;
            if (!_icon) {
                [self setIconWithName:@"login_icon_code"];
            }
        }
            break;
        case SCLoginTextFieldTypePassword:
        {
            self.maxTextLength = 16;
            [self setPlacehloderWithDefault:@"请输入密码"];
            _textField.keyboardType = UIKeyboardTypeASCIICapable;
            
            [_textField setSecureTextEntry:YES];
            if (!_icon) {
                [self setIconWithName:@"login_icon_code"];
            }
        }
            break;
        default:
        {
            self.maxTextLength = 0;
            self.placehloder = @"";
            _textField.keyboardType = UIKeyboardTypeDefault;
        }
            break;
    }
}

- (void)setPlacehloderWithDefault:(NSString *)placehloder
{
    if (!_placehloder.length) {
        [self setPlacehloder:placehloder];
    }
}

- (void)setPlacehloder:(NSString *)placehloder
{
    _placehloder = placehloder;
    _textField.placeholder = placehloder;
}

- (void)setText:(NSString *)text
{
    _textField.text = text;
}

- (NSString *)text
{
    return _textField.text;
}

- (BOOL)becomeFirstResponder
{
    return [self.textField becomeFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (self.maxTextLength > 0) {
        return text.length <= self.maxTextLength;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (_delegate && [_delegate respondsToSelector:@selector(loginTextFieldCell:textFieldDidReturn:)]) {
        [_delegate loginTextFieldCell:self textFieldDidReturn:textField];
    }
    return YES;
}

- (void)textDidChange:(UITextField *)textField
{
    if (_delegate && [_delegate respondsToSelector:@selector(loginTextFieldCell:textFieldDidChange:)]) {
        [_delegate loginTextFieldCell:self textFieldDidChange:textField];
    }
}

- (UIView *)bodyView
{
    return _bodyView;
}

+ (CGFloat)cellHeightWithItem:(id)item tableView:(UITableView *)tableView
{
    return 50;
}

@end

@interface SCLoginPhoneCell () {
    UIButton *_downArrowImage;
}

@end

@implementation SCLoginPhoneCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _phoneTextStyle = NO;
        self.type = SCLoginTextFieldTypePhone;
    }
    return self;
}

- (void)setPhoneTextStyle:(BOOL)phoneTextStyle
{
    _phoneTextStyle = phoneTextStyle;
    self.type = self.type;
}

- (void)setType:(SCLoginTextFieldType)type
{
    [super setType:type];
    if (self.phoneTextStyle) {
        self.maxTextLength = 13;
    } else {
        self.maxTextLength = 11;
    }
}

- (void)setShowListDownArrow:(BOOL)showListDownArrow
{
    _showListDownArrow = showListDownArrow;
    if (_showListDownArrow && !_downArrowImage) {
        _downArrowImage = [UIButton buttonWithType:UIButtonTypeCustom];
        _downArrowImage.frame = CGRectMake(_bodyView.width - 40, 0, 40, _bodyView.height);
        _downArrowImage.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
        [_downArrowImage setImageWithImageName:@"arrow_gray_down"];
        [_downArrowImage addTarget:self action:@selector(downArrowAction:)];
        [_bodyView addSubview:_downArrowImage];
        
        self.textField.width = _downArrowImage.left - self.textField.left;
    }
    
    _downArrowImage.hidden = !showListDownArrow;
}

- (NSString *)text
{
    if (_phoneTextStyle) {
        return [self.textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    } else {
        return self.textField.text;
    }
}

- (void)setText:(NSString *)text
{
    if (_phoneTextStyle) {
        [super setText:[self.class phoneStyleText:text]];
    } else {
        [super setText:text];
    }
}

+ (NSString *)checkText:(NSString *)text index:(NSInteger)index
{
    if (text.length >= index + 1) {
        if (![[text substringWithRange:NSMakeRange(index, 1)] isEqualToString:@" "]) {
            return [NSString stringWithFormat:@"%@ %@", [text substringToIndex:index], [text substringFromIndex:index]];
        }
    }
    return nil;
}

+ (NSString *)phoneStyleText:(NSString *)text
{
    int i = 0;
    while (i<2) {
        int index = 3 + i * 5;
        NSString *t = [self checkText:text index:index];
        if (t) {
            text = t;
        }
        i++;
    }
    return text;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (_phoneTextStyle) {
        if (text.length && [[text substringFromIndex:text.length - 1] isEqualToString:@" "]) {
            text = [text substringToIndex:text.length - 1];
        }
        
        text = [self.class phoneStyleText:text];
        
        if (text.length > self.maxTextLength) {
            text = [text substringToIndex:self.maxTextLength];
        }
        
        textField.text = text;
        [self textDidChange:textField];
        return NO;
    } else {
        return [super textField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
}

- (void)downArrowAction:(UIButton *)sender
{
    self.isShowList = !_isShowList;
    [DTPubUtil sendTagert:self.delegate action:@selector(loginTextFieldCell:didDownArrowBtn:) object:self object2:sender];
}

- (void)setIsShowList:(BOOL)isShowList
{
    _isShowList = isShowList;
    if (!_downArrowImage) {
        return;
    }
    UIButton *sender = _downArrowImage;
    [UIView animateWithDuration:0.25 animations:^{
        if (_isShowList) {
            sender.imageView.transform = CGAffineTransformMakeRotation(M_PI);
        } else {
            sender.imageView.transform = CGAffineTransformIdentity;
        }
    } completion:^(BOOL finished) {
        if (_isShowList) {
            sender.imageView.transform = CGAffineTransformMakeRotation(M_PI);
        } else {
            sender.imageView.transform = CGAffineTransformIdentity;
        }
    }];
}

@end


@interface SCLoginPhoneCodeCell () {
    
}

@end

@implementation SCLoginPhoneCodeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _codeBtn = [SCCodeBtn buttonWithType:UIButtonTypeCustom];
        _codeBtn.frame = CGRectMake(_bodyView.width - 86, 0, 86, _bodyView.height);
        _codeBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
        [_codeBtn addTarget:self action:@selector(codeBtnAction:)];
        [_bodyView addSubview:_codeBtn];
        
        self.textField.width = _codeBtn.left - self.textField.left;
        
        _codeBtn.status = SCCodeBtnStatusNormal;
        
        self.type = SCLoginTextFieldTypeCode;
    }
    return self;
}

- (void)codeBtnAction:(UIButton *)sender
{
    if (_codeBtn.status == SCCodeBtnStatusWait || _codeBtn.status == SCCodeBtnStatusRequest) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(loginTextFieldCell:didCodeBtn:)]) {
        [self.delegate loginTextFieldCell:self didCodeBtn:_codeBtn];
    }
}

@end

@interface SCCodeBtn () {
    NSTimer *_timer;
}

@end

@implementation SCCodeBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _timeCount = SC_LOGIN_CODE_TIME_COUNT;
        
//        self.layer.masksToBounds = YES;
//        self.layer.borderWidth = 0.5;
//        self.layer.borderColor = [UIColor colorWithHexString:@"e4e4e4"].CGColor;
//        self.layer.cornerRadius = 2.f;
        
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        [self setTitleFontSize:14 colorString:@"333333"];
    }
    return self;
}

- (void)setNormalColor:(UIColor *)normalColor
{
    _normalColor = normalColor;
    self.status = _status;
}

- (void)setStatus:(SCCodeBtnStatus)status
{
    _status = status;
//    self.enabled = (status != SCCodeBtnStatusRequest);
//    self.userInteractionEnabled = (status != SCCodeBtnStatusRequest && status != SCCodeBtnStatusWait);
    
    switch (status) {
        case SCCodeBtnStatusRequest:
        {
            [self setTitleColor:[UIColor colorWithString:@"494949" alpha:0.5]];
        }
            break;
        case SCCodeBtnStatusWait:
        {
//            self.layer.borderWidth = 0.f;
//            [self setBackgroundImage:[UIImage imageWithColorString:@"cecece"] forState:UIControlStateNormal];
            [self setTitleColor:[UIColor colorWithString:@"494949" alpha:0.5]];
            [self beginTimer];
        }
            break;
        case SCCodeBtnStatusReset:
        {
//            self.layer.borderWidth = 0.5f;
            [self setTitle:@"重新发送"];
            [self setTitleColorString:@"e8430f"];// ff9137
//            [self setBackgroundImageAndHightlightWithColorHex:@"ffffff"];
        }
            break;
        default:
        {
//            self.layer.borderWidth = 0.5f;
            [self setTitle:@"获取验证码"];
//            [self setBackgroundImageAndHightlightWithColorHex:@"ffffff"];
            if (_normalColor) {
                [self setTitleColor:_normalColor];
            } else {
                [self setTitleColorString:@"e3bb67"];
            }
        }
            break;
    }
}

- (void)beginTimer
{
    _time = _timeCount;
    [self updateTime];
    
    if (_timer == nil) {
        _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

- (void)updateTime
{
    if (_time <= 0) {
        if (_timer) {
            [_timer invalidate];
            _timer = nil;
        }
        self.status = SCCodeBtnStatusReset;
        return;
    }
    [self setTitle:[NSString stringWithFormat:@"%ld s", _time]];
    
    _time --;
}

- (void)stopTimer
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

@end

@interface SCLoginPasswordCell () {
    UIButton *_secureBtn;
}

@end

@implementation SCLoginPasswordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _secureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _secureBtn.frame = CGRectMake(_bodyView.width - 26, self.textField.top, 26, self.textField.height);
        _secureBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        [_secureBtn addTarget:self action:@selector(secureBtnAction:)];
        [_bodyView addSubview:_secureBtn];
        
        self.textField.width = _secureBtn.left - self.textField.left - 5;

        self.type = SCLoginTextFieldTypePassword;
        self.isSecure = YES;
    }
    return self;
}

- (void)setIsSecure:(BOOL)isSecure
{
    _isSecure = isSecure;
    [self.textField setSecureTextEntry:isSecure];
    
    [self updatePasswrodViewIcon];
}

- (void)updatePasswrodViewIcon
{
    if (self.textField.text.length) {
        NSString *image = (_isSecure ? @"login_password_see" : @"login_password_close");
        [_secureBtn setImageWithImageName:image];
    } else {
        [_secureBtn setImageWithImageName:@"login_password_unsee"];
    }
}

- (void)secureBtnAction:(UIButton *)sender
{
    if (self.textField.text.length <= 0) {
        return;
    }
    self.isSecure = !_isSecure;
}

- (void)textDidChange:(UITextField *)textField
{
    [super textDidChange:textField];
    [self updatePasswrodViewIcon];
}

@end
