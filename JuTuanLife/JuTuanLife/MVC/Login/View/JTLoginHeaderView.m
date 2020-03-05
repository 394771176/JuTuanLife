//
//  JTLoginHeaderView.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/4.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTLoginHeaderView.h"

@interface JTLoginHeaderView () {
    UIImageView *_bgView;
    UIImageView *_bgLineImageView;
    UIImageView *_logoView;
}

@end

@implementation JTLoginHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *image = [UIImage imageNamed:@"login_header_bg"];
        
        _bgLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, SAFE_BOTTOM_VIEW_HEIGHT + 1)];
        _bgLineImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _bgLineImageView.contentMode = UIViewContentModeScaleToFill;
        _bgLineImageView.clipsToBounds = YES;
        //        _bgLineImageView.image = [image getSubImage:CGRectMake(0, 0, CGImageGetWidth(image.CGImage), 1)];
        _bgLineImageView.image = [image subImageFromRect:CGRectMake(0, 0, CGImageGetWidth(image.CGImage), 1)];;
        [self addSubview:_bgLineImageView];
        
        _bgView = [[UIImageView alloc] initWithImage:image];
        _bgView.top = SAFE_BOTTOM_VIEW_HEIGHT;
        _bgView.width = self.width;
        _bgView.contentMode = UIViewContentModeScaleAspectFill;
        _bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _bgView.clipsToBounds = YES;
        [self addSubview:_bgView];
        
        _logoView = [UIImageView imageViewWithImageName:@"logo_jtbang"];
        _logoView.center = CGPointMake(self.width / 2, _bgView.bottom - _logoView.height / 2);
        _logoView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:_logoView];
        
        UIView *logoBg = [[UIView alloc] initWithFrame:CGRectInset(_logoView.frame, -10, -10)];
        logoBg.backgroundColor = [UIColor whiteColor];
        logoBg.cornerRadius = logoBg.height / 2;
        logoBg.alpha = 0.5;
        logoBg.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        [self insertSubview:logoBg belowSubview:_logoView];
    }
    return self;
}

- (void)setScrollOffsetY:(CGFloat)scrollOffsetY
{
    _scrollOffsetY = scrollOffsetY;
    
    [self updateWallLocation];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self updateWallLocation];
}

- (void)updateWallLocation
{
    if (self.window) {
        if (_scrollOffsetY >= 0.f) {
            _bgLineImageView.frame = CGRectMake(0, 0, self.width, SAFE_BOTTOM_VIEW_HEIGHT);
        } else {
            _bgLineImageView.frame = CGRectMake(0, _scrollOffsetY, self.width, SAFE_BOTTOM_VIEW_HEIGHT-_scrollOffsetY);
        }
    }
}

@end
