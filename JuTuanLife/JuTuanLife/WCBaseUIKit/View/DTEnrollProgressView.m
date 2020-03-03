//
//  DTEnrollProgressView.m
//  DrivingTest
//
//  Created by PageZhang on 16/5/9.
//  Copyright © 2016年 eclicks. All rights reserved.
//

#import "DTEnrollProgressView.h"
#import "FFAnimateHelper.h"

@interface DTEnrollProgressView () {
    UIImageView *_pointerView;
}
@end

@implementation DTEnrollProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *pointerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dashboard_pointer"]];
        pointerView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:pointerView];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:pointerView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:pointerView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        _pointerView = pointerView;
        
        UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dashboard_bg"]];
        bgView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:bgView];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:bgView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:bgView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        
        [self setProgress:0];
    }
    return self;
}

- (void)setProgress:(CGFloat)progress {
    _progress = MIN(progress, 1);
    _pointerView.transform = CGAffineTransformMakeRotation(M_PI*1.5*progress);
    
    self.alpha = MIN(progress*4, 1);
    CGFloat scale = MIN(progress*2+0.4, 1);
    self.transform = CGAffineTransformMakeScale(scale, scale);
}

- (void)startAnimating {
    if ([self isAnimating]) {
        return;
    }
    if (_progress < 1) {
        [self setProgress:1];
    }
    CAAnimation *shake = FFRotateAnimation(0.25, @(M_PI*1.25), @(M_PI*1.5));
    shake.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    shake.repeatCount = HUGE_VALF;
    shake.autoreverses = YES;
    [_pointerView.layer addAnimation:shake forKey:@"shake"];
}

- (void)stopAnimating {
    [_pointerView.layer removeAllAnimations];
}

- (BOOL)isAnimating {
    return _pointerView.layer.animationKeys.count > 0;
}

@end
