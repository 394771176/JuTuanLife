//
//  DTTableRefreshHeaderView.m
//  JuTuanLife
//
//  Created by cheng on 2020/4/5.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "DTTableRefreshHeaderView.h"

const NSTimeInterval MIN_Duration = 0.67;

@interface DTTableRefreshHeaderView () {
    DTPullRefreshState _state;
    LQHeaderView *_bodyView;
    NSTimeInterval _animationBegin;
    CGFloat _minGapY;
}

@end

@implementation DTTableRefreshHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _minOffsetY = 60;
        _needDelay = YES;
        
        _bodyView = [[LQHeaderView alloc] initWithFrame:CGRectMake(0, self.height - 60, self.width, 60)];
        _bodyView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:_bodyView];
    }
    return self;
}

- (void)setDelegate:(id<DTPullRefreshHeadViewDelegate>)delegate
{
    _delegate = delegate;
    
    if (!_delegate) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    }
}

- (void)setState:(DTPullRefreshState)aState
{
    switch (aState) {
        case DTPullRefreshLoading:
            _animationBegin = CFAbsoluteTimeGetCurrent();
            [_bodyView startAnimation];
            break;
        case DTPullRefreshNormal:
            [_bodyView stopAnimation];
            break;
        case DTPullRefreshPulling:
            
            break;
        default:
            break;
    }
    
    _state = aState;
}

- (BOOL)isTableModelLoading
{
    BOOL _loading = NO;
    if ([_delegate respondsToSelector:@selector(pullRefreshTableHeaderDataSourceIsLoading:)]) {
        _loading = [_delegate pullRefreshTableHeaderDataSourceIsLoading:self];
    }
    return _loading;
}

- (void)pullRefreshScrollViewDidScroll:(UIScrollView *)scrollView
{
    float offset = scrollView.contentOffset.y;
    
    if (_state != DTPullRefreshLoading) {
        CGFloat progress = 0.f;
        if (offset<-_minOffsetY / 3 && _minOffsetY > 0) {
            progress = (-offset - _minOffsetY / 3) / (_minOffsetY / 3 * 2);
        } else {
            progress = 0.f;
        }
        [_bodyView setProgress:progress];
    }
    
    if (_state == DTPullRefreshLoading) {
        float offset = MAX((scrollView.contentOffset.y+_defaultContentInset.top) * -1, 0);
        offset = MIN(offset, _minOffsetY)+_defaultContentInset.top;
        scrollView.contentInset = UIEdgeInsetsMake(offset, _defaultContentInset.left, _defaultContentInset.bottom, _defaultContentInset.right);
    } else if (scrollView.isDragging) {
        CGFloat minOffset = _minGapY + _minOffsetY;
        if (_state == DTPullRefreshPulling && scrollView.contentOffset.y > -minOffset-_defaultContentInset.top && scrollView.contentOffset.y < -_defaultContentInset.top) {
            if (![self isTableModelLoading]) {
                [self setState:DTPullRefreshNormal];
            }
        } else if (_state == DTPullRefreshNormal && scrollView.contentOffset.y < -minOffset-_defaultContentInset.top) {
            if (![self isTableModelLoading]) {
                [self setState:DTPullRefreshPulling];
            }
        }
        
        if (scrollView.contentInset.top != _defaultContentInset.top) {
            scrollView.contentInset = _defaultContentInset;
        }
    }
}

- (void)pullRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < -_minOffsetY - _minGapY -_defaultContentInset.top) {
        if (![self isTableModelLoading]) {
            if ([_delegate respondsToSelector:@selector(pullRefreshTableHeaderDidTriggerRefresh:)]) {
                [_delegate pullRefreshTableHeaderDidTriggerRefresh:self];
            }
            [self setState:DTPullRefreshLoading];
            CGPoint offset = scrollView.contentOffset;
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.3];
            scrollView.contentInset = UIEdgeInsetsMake(_defaultContentInset.top+_minOffsetY, _defaultContentInset.left, _defaultContentInset.bottom, _defaultContentInset.right);
            scrollView.contentOffset = offset;
            [UIView commitAnimations];
        }
    } else if (_state == DTPullRefreshNormal) {
        
    }
}

- (void)didPullRefreshScrollView:(UIScrollView *)scrollView
{
    if (![self isTableModelLoading]) {
        if ([_delegate respondsToSelector:@selector(pullRefreshTableHeaderDidTriggerRefresh:)]) {
            [_delegate pullRefreshTableHeaderDidTriggerRefresh:self];
        }
        scrollView.contentInset = UIEdgeInsetsMake(_defaultContentInset.top+_minGapY, _defaultContentInset.left, _defaultContentInset.bottom, _defaultContentInset.right);
        [self setState:DTPullRefreshLoading];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        scrollView.contentOffset = CGPointMake(0, -_defaultContentInset.top-_minOffsetY);
        [UIView commitAnimations];
    }
}

- (void)pullRefreshViewToNormalWithScrollView:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:0.3f animations:^{
        [scrollView setContentInset:_defaultContentInset];
    } completion:^(BOOL finished) {
        [self setState:DTPullRefreshNormal];
        _bodyView.progress = 0.f;
    }];
    if (_needDelay) {
        _needDelay = NO;
    }
    if (_finishBlock) {
        _finishBlock();
    }
}

- (void)pullRefreshScrollViewDataSourceDidFinishLoading:(UIScrollView *)scrollView {
    if (_needDelay) {
        [self delayToNormalWithScrollView:scrollView];
    } else {
        [self pullRefreshViewToNormalWithScrollView:scrollView];
    }
}

- (void)delayToNormalWithScrollView:(UIScrollView *)scrollView
{
    if (!self.delegate) return;
    
    NSTimeInterval duration = CFAbsoluteTimeGetCurrent() - _animationBegin;
    if (_needDelay&&duration<MIN_Duration) {
        [self performSelector:@selector(delayToNormalWithScrollView:) withObject:scrollView afterDelay:MIN_Duration-duration];
    } else {
        [self pullRefreshViewToNormalWithScrollView:scrollView];
    }
}

@end

@interface LQHeaderView()

@end

@implementation LQHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _ballSize = 10;
        _ballDistance = 30;
        
        _leftView = [self quanView];
        _leftView.backgroundColor = [UIColor colorWithRed:54/255.0 green:136/255.0 blue:250/255.0 alpha:1];
        
        _rightView = [self quanView];
        _rightView.backgroundColor = [UIColor colorWithRed:234/255.0 green:67/255.0 blue:69/255.0 alpha:1];
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (UIView *)quanView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(self.width/2 - _ballSize/ 2, self.height/2 - _ballSize/2, _ballSize, _ballSize)];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = _ballSize/2;
    [self addSubview:view];
    return view;
}

- (void)setProgress:(CGFloat)progress
{
    if (progress < 0.f) {
        progress = 0.f;
    } else if (progress > 1.f) {
        progress = 1.f;
    }
    if (progress < 0.5) {
        _leftView.center = CGPointMake(self.width / 2, self.height / 2);
        _leftView.transform = CGAffineTransformMakeScale(progress * 2, progress * 2);
        
        _rightView.center = CGPointMake(self.width / 2, self.height / 2);
        _rightView.transform = CGAffineTransformMakeScale(progress * 2, progress * 2);
    } else {
        _leftView.transform = CGAffineTransformIdentity;
        _rightView.transform = CGAffineTransformIdentity;
        
        CGFloat realProgress = (progress - 0.5) * 2;
        _leftView.center = CGPointMake(self.width / 2 - _ballDistance / 2 * realProgress, self.height / 2);
        _rightView.center = CGPointMake(self.width / 2 + _ballDistance / 2 * realProgress, self.height / 2);
    }
}

- (void)startAnimation
{
    [self animation:_leftView withStartAngle:M_PI];
    [self animation:_rightView withStartAngle:0];
}

- (void)stopAnimation
{
    [_leftView.layer removeAllAnimations];
    [_rightView.layer removeAllAnimations];
}

- (void)animation:(UIView *)view withStartAngle:(CGFloat)startAngle
{
    UIBezierPath *arcPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.width/2, self.height /2) radius:_ballDistance / 2 startAngle:startAngle endAngle:startAngle+M_PI*2 clockwise:YES];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = arcPath.CGPath;
    animation.duration = 0.66;
    animation.repeatCount = HUGE_VALF;
    animation.removedOnCompletion = NO;
    
    [view.layer addAnimation:animation forKey:@"animation"];
}

@end
