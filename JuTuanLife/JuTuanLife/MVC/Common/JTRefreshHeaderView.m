//
//  JTRefreshHeaderView.m
//  JuTuanLife
//
//  Created by cheng on 2020/4/11.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTRefreshHeaderView.h"

const NSTimeInterval MIN_Duration = 0.67;

@interface JTRefreshHeaderView () {
    DTPullRefreshState _state;
    UIImageView *_bodyView;
    NSTimeInterval _animationBegin;
    CGFloat _minGapY;
    NSMutableArray *_images;
}

@end

@implementation JTRefreshHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _minOffsetY = 60;
        _needDelay = YES;
        
        _bodyView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.height - 60, self.width, 60)];
        _bodyView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
        _bodyView.contentMode = UIViewContentModeCenter;
        _bodyView.animationDuration = MIN_Duration;
        [self addSubview:_bodyView];
        
        NSMutableArray *images = [NSMutableArray array];
        for (NSInteger i = 0; i < 12; i++) {
            [images safeAddObject:[self imageWithIndex:i]];
        }
        _images = images;
    }
    return self;
}

- (void)setDelegate:(id<WCBaseUIRefreshHeaderViewDelegate>)delegate
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
            [self start];
            break;
        case DTPullRefreshNormal:
            [_bodyView stopAnimating];
            break;
        case DTPullRefreshPulling:
            
            break;
        default:
            break;
    }
    
    _state = aState;
}

- (UIImage *)imageWithIndex:(NSInteger)index
{
    //1 ~ 12
    NSInteger n = index + 1;
    if (n < 1) {
        n = 1;
    } else if (n > 12){
        n = 12;
    }
    NSString *name = [NSString stringWithFormat:@"jt_loading_%zd", n];
    return [UIImage imageNamed:name];
}

- (void)setProgress:(CGFloat)progress
{
    NSInteger index = (NSInteger)(progress * 10 * 12);
//    NSLog(@"%f, %zd", progress, index);
    index = index / 12;
    _bodyView.animationImages = nil;
    _bodyView.image = [self imageWithIndex:index];
}

- (void)start
{
    _bodyView.animationImages = _images;
    [_bodyView startAnimating];
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
        [self setProgress:progress];
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
        [self setProgress:0.f];
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
