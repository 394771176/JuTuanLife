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
    UIImageView *_logoView;
}

@end

@implementation JTLoginHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _bgView = [UIImageView imageViewWithImageName:@"login_header_bg.jpg"];
        _bgView.height = 204;
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

@end
