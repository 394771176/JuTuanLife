//
//  DTDrivingLoadingView.m
//  DrivingTest
//
//  Created by kent on 15/3/12.
//  Copyright (c) 2015年 eclicks. All rights reserved.
//

#import "DTDrivingLoadingView.h"

@interface DTDrivingLoadingView () {
    UIImageView *_loadingView;
    NSLayoutConstraint *_loadingViewConstraintY;
}
@end

@implementation DTDrivingLoadingView

+ (instancetype)loadingInView:(UIView *)view {
    if (view == nil) {
        return nil;
    }
    DTDrivingLoadingView *loadingView = [DTDrivingLoadingView new];
    loadingView.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:loadingView];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[loadingView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(loadingView)]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[loadingView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(loadingView)]];
    return loadingView;
}
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *imv = [UIImageView new];
        imv.translatesAutoresizingMaskIntoConstraints = NO;
        NSUInteger imageCount = 12;
        NSMutableArray *images = [NSMutableArray arrayWithCapacity:imageCount];
        for (int i = 1; i <= imageCount; i++) {
            [images safeAddObject:[UIImage imageNamed:[NSString stringWithFormat:@"driving_loading%d",i]]];
        }
        imv.animationImages = images;
        imv.animationDuration = 1.5;
        [self addSubview:imv];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:imv attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        _loadingViewConstraintY = [NSLayoutConstraint constraintWithItem:imv attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:0.85 constant:0];
        [self addConstraint:_loadingViewConstraintY];
        _loadingView = imv;
        
        UILabel *label = [UILabel new];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = APP_CONST_BLUE_COLOR;
        label.font = FONT(14);
        label.text = @"加载中..";
        [self addSubview:label];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:imv attribute:NSLayoutAttributeBottom multiplier:1 constant:12]];
        
    }
    return self;
}

- (void)startAnimating {
    self.alpha = 1;
    [_loadingView startAnimating];
}

- (void)stopAnimating {
    [_loadingView stopAnimating];
    self.alpha = 0;
}

- (BOOL)isAnimating {
    return [_loadingView isAnimating];
}

- (void)setOffsetY:(CGFloat)offsetY
{
    _loadingViewConstraintY.constant = offsetY;
    [self setNeedsLayout];
}

@end
