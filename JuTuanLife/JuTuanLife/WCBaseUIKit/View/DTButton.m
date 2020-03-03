//
//  DTButton.m
//  DrivingTest
//
//  Created by cheng on 16/9/8.
//  Copyright © 2016年 eclicks. All rights reserved.
//

#import "DTButton.h"

static NSString *const DTButtonPropertyImage = @"image";
static NSString *const DTButtonPropertyTitle = @"title";
static NSString *const DTButtonPropertyTitleColor = @"title_color";
static NSString *const DTButtonPropertyBgImage = @"bg_image";
static NSString *const DTButtonPropertyBgColor = @"bg_color";

@interface DTButton () {
    
    NSMutableDictionary *_propertyDict;
    
    UIFont *_font;
    
    CGFloat _imageSize, _titleSize;
    CGFloat _autoImageSize, _autoTitleSize;
    
  
    CGRect _markRect;
}

@end

@implementation DTButton

+ (instancetype)buttonWithStyle:(DTButtonStyle)style
{
    return [self buttonWithStyle:style mode:DTButtonModeImageTitle];
}

+ (instancetype)buttonWithMode:(DTButtonMode)mode
{
    return [self buttonWithStyle:DTButtonStyleHorizontal mode:mode];
}

+ (instancetype)buttonWithStyle:(DTButtonStyle)style mode:(DTButtonMode)mode
{
    DTButton *btn = [self buttonWithType:UIButtonTypeCustom];
    btn.style = style;
    btn.mode = mode;
    btn.frame = CGRectMake(0, 0, 44, 44);
    return btn;
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = _font;
        [_contentView addSubview:_titleLabel];
        if (!_autoSize) {
            [self updateContentFrame];
        }
    }
    return _titleLabel;
}

- (UIImageView *)imageView
{
    if (_imageView == nil) {
        _imageView  = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeCenter;
        [_contentView addSubview:_imageView];
        if (!_autoSize) {
            [self updateContentFrame];
        }
    }
    return _imageView;
}

- (FLAnimatedImageView *)aniImageView
{
    if (_aniImageView == nil) {
        _aniImageView  = [[FLAnimatedImageView alloc] init];
        _aniImageView.contentMode = UIViewContentModeCenter;
        _aniImageView.hidden = YES;
        [_contentView addSubview:_aniImageView];
        if (!_autoSize) {
            [self updateContentFrame];
        }
    }
    return _aniImageView;
}

- (UIView *)contentView
{
    return _contentView;
}

- (UIImageView *)bgImageView
{
    return _bgImageView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.gap = 3;
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        _font = [UIFont systemFontOfSize:16];
        _edgeInset = UIEdgeInsetsMake(0, 0, 0, 0);

        _contentView = [[UIView alloc] initWithFrame:self.bounds];
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _contentView.backgroundColor = [UIColor clearColor];
        _contentView.userInteractionEnabled = NO;
        [self addSubview:_contentView];
        
        _autoSize = YES;
        
        [self addTarget:self action:@selector(downAction) forControlEvents:UIControlEventTouchDown|UIControlEventTouchDragEnter];
        [self addTarget:self action:@selector(upAction) forControlEvents:UIControlEventTouchDragExit|UIControlEventTouchUpInside|UIControlEventTouchUpOutside|UIControlEventTouchCancel];
    }
    return self;
}

- (void)downAction
{
    self.alpha = 0.6;
}

- (void)upAction
{
    self.alpha = 1.0;
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state
{
    if (self.state==state) {
        self.titleLabel.textColor = color;
    }
    [self setObject:color forState:state withType:DTButtonPropertyTitleColor];
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    if (self.state==state || !self.titleLabel.text) {
        self.titleLabel.text = title;
        [self checkTextSize];
    }
    [self setObject:title forState:state withType:DTButtonPropertyTitle];
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    if (self.state==state || !self.imageView.image) {
        self.imageView.image = image;
        [self checkImageSize];
    }
    [self setObject:image forState:state withType:DTButtonPropertyImage];
}

- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state
{
    if (_bgImageView==nil) {
        _bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _bgImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self insertSubview:_bgImageView belowSubview:_contentView];
    }
    if (self.state==state || !_bgImageView.image) {
        _bgImageView.image = image;
    }
    [self setObject:image forState:state withType:DTButtonPropertyBgImage];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [self updateState];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    [self updateState];
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    [self updateState];
}

- (void)updateState
{
    if (_titleLabel) {
        [_titleLabel setTextColor:[self currentObjectForType:DTButtonPropertyTitleColor]];
        [_titleLabel setText:[self currentObjectForType:DTButtonPropertyTitle]];
    }
    if (_imageView) {
        [_imageView setImage:[self currentObjectForType:DTButtonPropertyImage]];
    }
    if (_bgImageView) {
        [_bgImageView setImage:[self currentObjectForType:DTButtonPropertyBgImage]];
    }
    
    UIColor *color = [self currentObjectForType:DTButtonPropertyBgColor];
    if (color) {
        self.backgroundColor = color;
    }
    if (_style == DTButtonStyleHorizontal && _alignment == DTButtonAlignmentCenter) {
        [self checkTextSize];
    }
}

- (void)setObject:(id)anObject forState:(UIControlState)state withType:(NSString *)type
{
    [self setObject:anObject forKey:@(state) withType:type];
}

- (void)setObject:(id)anObject forKey:(id)aKey withType:(NSString *)type
{
    if (_propertyDict==nil) _propertyDict = [NSMutableDictionary dictionary];
    if (type) {
        NSMutableDictionary *dict = [_propertyDict objectForKey:type];
        if (anObject&&aKey) {
            if (dict==nil) {
                dict = [NSMutableDictionary dictionary];
            }
            [dict setObject:anObject forKey:aKey];
        } else if (aKey) {
            [dict removeObjectForKey:aKey];
        }
        [_propertyDict safeSetObject:dict forKey:type];
    }
}

- (id)currentObjectForType:(NSString *)type
{
    id obj = [self objectForKey:@(self.state) withType:type];
    if (obj==nil&&self.state!=UIControlStateNormal) {
        return [self objectForKey:@(UIControlStateNormal) withType:type];
    }
    return obj;
}

- (id)objectForKey:(id)key withType:(NSString *)type
{
    if (type) {
        NSMutableDictionary *dict = [_propertyDict objectForKey:type];
        if (dict&&key) return [dict objectForKey:key];
    }
    return nil;
}

- (void)checkTextSize
{
    if (_autoSize || _titleSize < 0.01) {
        CGFloat titleSize = 0.f;
        if (_style == DTButtonStyleVertical) {
            if (_titleLabel.text) {
                titleSize = [_titleLabel getTextHeight];
            }
        } else {
            if (_titleLabel.text) {
                titleSize = [_titleLabel getTextWidth];
            }
        }
        
        if (_autoTitleSize != titleSize) {
            _autoTitleSize = titleSize;
            [self updateContentFrame];
        }
    }
}

- (void)checkImageSize
{
    if (_autoSize || _imageSize < 0.01) {
        CGFloat imageSize = 0.f;
        if (_style == DTButtonStyleVertical) {
            
            if (_imageView.image) {
                imageSize = _imageView.image.size.height;
            }
        } else {
            
            if (_imageView.image) {
                imageSize = _imageView.image.size.width;
            }
        }
        
        if (_autoImageSize != imageSize) {
            _autoImageSize = imageSize;
            [self updateContentFrame];
        }
    }
}

#pragma mark - additional action

- (void)setTitleFont:(UIFont *)font
{
    _font = font;
    self.titleLabel.font = font;
    [self checkTextSize];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state
{
    if (self.state==state) {
        [self setBackgroundColor:backgroundColor];
    }
    [self setObject:backgroundColor forState:state withType:DTButtonPropertyBgColor];
}

#pragma mark - dtbutton

- (void)setStyle:(DTButtonStyle)style
{
    _style = style;
    [self checkTextSize];
}

- (void)setEdgeInset:(UIEdgeInsets)edgeInset
{
    _edgeInset = edgeInset;
    _contentView.frame = CGRectMake(_edgeInset.left, _edgeInset.top, self.width - _edgeInset.left - _edgeInset.right, self.height - _edgeInset.top - _edgeInset.bottom);
}

- (void)setGap:(CGFloat)gap
{
    _gap = gap;
    [self updateContentFrame];
}

- (void)setLeftOrTop:(CGFloat)leftOrTop
{
    _leftOrTop = leftOrTop;
    [self updateContentFrame];
}

- (void)setImageSize:(CGFloat)imageSize titleSize:(CGFloat)titleSize
{
    _autoSize = NO;
    
    _imageSize = imageSize;
    _titleSize = titleSize;
    [self updateContentFrame];
}

- (void)setLeftOrTop:(CGFloat)leftOrTop gap:(CGFloat)gap
{
    _gap = gap;
    _leftOrTop = leftOrTop;
    [self updateContentFrame];
}

- (void)setLeftOrTop:(CGFloat)leftOrTop imageSize:(CGFloat)imageSize titleSize:(CGFloat)titleSize
{
    [self setLeftOrTop:leftOrTop imageSize:imageSize titleSize:titleSize gap:_gap];
}

- (void)setLeftOrTop:(CGFloat)leftOrTop imageSize:(CGFloat)imageSize titleSize:(CGFloat)titleSize gap:(CGFloat)gap
{
    _gap = gap;
    _leftOrTop = leftOrTop;
    [self setImageSize:imageSize titleSize:titleSize];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if (_markRect.size.width != frame.size.width && _style == DTButtonStyleHorizontal) {
        [self updateContentFrame];
    } else if (_markRect.size.height != frame.size.height && _style == DTButtonStyleVertical) {
        [self updateContentFrame];
    }
    _markRect = frame;
}

- (void)updateContentFrame
{
    UIView *firstView = (_mode == DTButtonModeImageTitle ? _imageView  : _titleLabel);
    UIView *lastView =  (_mode == DTButtonModeImageTitle ? _titleLabel : _imageView);
    if (firstView == nil && lastView == nil) {
        return;
    }
    
    CGFloat imageSize = ((_autoSize || _imageSize < 0.01) ? _autoImageSize : _imageSize);
    CGFloat titleSize = ((_autoSize || _titleSize < 0.01) ? _autoTitleSize : _titleSize);
    
    CGFloat gap = (imageSize <=0.f || titleSize <= 0.f) ? 0 : _gap;
    
    CGFloat firstSize = (_mode == DTButtonModeImageTitle ? imageSize  : titleSize);
    CGFloat lastSize =  (_mode == DTButtonModeImageTitle ? titleSize  : imageSize);
    
    CGRect firstRect, lastRect;
    
    if (_style == DTButtonStyleHorizontal) {
        if (_alignment == DTButtonAlignmentCenter) {
            CGFloat contentSize = imageSize + gap + titleSize;
            firstRect = CGRectMake(_contentView.width/2 - contentSize/2, 0, firstSize, _contentView.height);
            lastRect  = CGRectMake(CGRectGetMaxX(firstRect) + gap, 0, lastSize, _contentView.height);
        } else if (_alignment == DTButtonAlignmentLeftOrTop) {
            firstRect = CGRectMake(_leftOrTop, 0, firstSize, _contentView.height);
            lastRect  = CGRectMake(CGRectGetMaxX(firstRect) + gap, 0, lastSize, _contentView.height);
        } else if (_alignment == DTButtonAlignmentRightOrBottom) {
            lastRect  = CGRectMake(_contentView.width - lastSize - _leftOrTop, 0, lastSize, _contentView.height);
            firstRect = CGRectMake(CGRectGetMinX(lastRect) - firstSize - gap, 0, firstSize, _contentView.height);
        } else if (_alignment == DTButtonAlignmentFixCenter) {
            firstRect = CGRectMake(_fixFirstCenter - firstSize / 2, 0, firstSize, _contentView.height);
            lastRect  = CGRectMake(_fixLastCenter - lastSize / 2, 0, lastSize, _contentView.height);
        } else {
            if (_mode == DTButtonModeTitleImage) {
                firstRect = CGRectMake(0, 0, _contentView.width - lastSize, _contentView.height);
                lastRect  = CGRectMake(_contentView.width - lastSize, 0, lastSize, _contentView.height);
                _titleLabel.textAlignment = NSTextAlignmentLeft;
            } else {
                firstRect = CGRectMake(0, 0, firstSize, _contentView.height);
                lastRect  = CGRectMake(firstSize, 0, _contentView.width - firstSize, _contentView.height);
                _titleLabel.textAlignment = NSTextAlignmentRight;
            }
        }
        firstView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        lastView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    } else {
        if (_alignment == DTButtonAlignmentCenter) {
            CGFloat contentSize = imageSize + gap + titleSize;
            firstRect = CGRectMake(0, _contentView.height/2 - contentSize/2, _contentView.width, firstSize);
            lastRect  = CGRectMake(0, CGRectGetMaxY(firstRect) + gap, _contentView.width, lastSize);
        } else if (_alignment == DTButtonAlignmentLeftOrTop) {
            firstRect = CGRectMake(0, _leftOrTop, _contentView.width, firstSize);
            lastRect  = CGRectMake(0, CGRectGetMaxY(firstRect) + gap, _contentView.width, lastSize);
        } else if (_alignment == DTButtonAlignmentRightOrBottom) {
            lastRect  = CGRectMake(0, _contentView.height - lastSize - _leftOrTop, _contentView.width, lastSize);
            firstRect = CGRectMake(0, CGRectGetMinY(lastRect) - firstSize - gap, _contentView.width, firstSize);
        } else if (_alignment == DTButtonAlignmentFixCenter) {
            firstRect = CGRectMake(0, _fixFirstCenter - firstSize / 2, _contentView.width, firstSize);
            lastRect  = CGRectMake(0, _fixLastCenter - lastSize / 2, _contentView.width, lastSize);
        } else {
            firstRect = CGRectMake(0, 0, _contentView.width, firstSize);
            lastRect  = CGRectMake(0, _contentView.height - lastSize, _contentView.width, lastSize);
        }
        firstView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        lastView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    
    firstView.frame = firstRect;
    lastView.frame = lastRect;
}

- (CGSize)getContentRealSize
{
    CGSize size = self.size;
    if (_style == DTButtonStyleHorizontal) {
        CGFloat width = _edgeInset.left + _edgeInset.right;
        if (_titleLabel) {
            width += _titleLabel.width;
        }
        if (_imageView) {
            width += _imageView.width;
        }
        if (_titleLabel && _imageView) {
            width += _gap;
        }
        size.width = width;
    } else if (_style == DTButtonStyleVertical) {
        CGFloat height = _edgeInset.top + _edgeInset.bottom;
        if (_titleLabel) {
            height += _titleLabel.height;
        }
        if (_imageView) {
            height += _imageView.height;
        }
        if (_imageView && _titleLabel) {
            height += _gap;
        }
        size.height = height;
    }
    return size;
}


- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    if (self.tag==7890) {
       NSLog(@"DTButton:%d",hidden);
    }
   
}

@end
