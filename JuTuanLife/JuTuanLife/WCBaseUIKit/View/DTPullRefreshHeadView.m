//
//  DTPullRefreshHeadView.m
//  DrivingTest
//
//  Created by Kent on 14-7-4.
//  Copyright (c) 2014年 eclicks. All rights reserved.
//

#import "DTPullRefreshHeadView.h"
#import "WCUICommon.h"
#import "DTEnrollProgressView.h"

#define PULLREFRESH_ANIMATION_NDURATION 1.f
#define PULLREFRESH_ANIMATION_VELOCITY  1.25

@interface DTPullRefreshHeadView () {
    DTPullRefreshState _state;
    UIImageView *_activeImageView;
    UIView *_activeBodyView;
    FLAnimatedImageView *_aniImageView;
    FLAnimatedImage *_aniImage;
    
    NSInteger _currentIndex;
    
    double _animationBegin;
}

@end

@implementation DTPullRefreshHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *contentView = [[UIView alloc] initWithFrame:self.bounds];
        contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        contentView.backgroundColor = [UIColor clearColor];
        [self addSubview:contentView];
        
        _activeBodyView = [[UIView alloc] initWithFrame:CGRectMake(self.width/2-60/2, 0, 60, 60)];
        _activeBodyView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [contentView addSubview:_activeBodyView];
        
//        _activeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_activeBodyView.width/2-12, _activeBodyView.height/2-12, 24, 24)];
//        _activeImageView.image = [UIImage imageNamed:@"dt_loading"];
//        [_activeBodyView addSubview:_activeImageView];
        
//        _aniImage = [DTPullRefreshImage shareInstace].aniImage;
        
        _aniImageView = [[FLAnimatedImageView alloc] initWithFrame:CGRectMake(_activeBodyView.width/2-20, _activeBodyView.height/2-20, 40, 40)];
        [_aniImageView setAnimatedImage:_aniImage];
        _aniImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_aniImageView stopAnimating];
        [_activeBodyView addSubview:_aniImageView];
        
        _needDelay = YES;
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

- (void)viewWillAppear
{
    if (_state == DTPullRefreshLoading) {
        [self startAnimation];
    }
}

- (void)startAnimation
{
    _animationBegin = CFAbsoluteTimeGetCurrent();
    [_activeImageView startRotateAnimation];
    [_aniImageView startAnimating];
}

- (void)stopAnimation
{
    [_activeImageView stopAllAnimation];
    [_aniImageView stopAnimating];
}

- (void)setState:(DTPullRefreshState)aState
{
    switch (aState) {
        case DTPullRefreshLoading:
            [self startAnimation];
            break;
        case DTPullRefreshNormal:
            [self stopAnimation];
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
    NSInteger index = _aniImage.frameCount-1;
    if (offset < -60) {
        _aniImageView.top = _activeBodyView.height/2-_aniImageView.height/2;
        _activeBodyView.top = (offset+60);
    } else {
        if (offset >= -40) {
            _aniImageView.top = _activeBodyView.height-_aniImageView.height;
        } else {
            _aniImageView.top = -offset/2-_aniImageView.height/2 + (60+offset);
        }
        _activeBodyView.top = 0;
    }
    
    if (_state != DTPullRefreshLoading) {
        if (offset<0) {
            CGFloat valueSet = offset + (floorf(-offset/60)*60)+60;
            index = floorf(valueSet/60.f *index);
        }
        _currentIndex = index;
        [_aniImageView setIndex:index];
    }
    
	if (_state == DTPullRefreshLoading) {
		float offset = MAX((scrollView.contentOffset.y+_defaultContentInset.top) * -1, 0);
		offset = MIN(offset, 60)+_defaultContentInset.top;
		scrollView.contentInset = UIEdgeInsetsMake(offset, _defaultContentInset.left, _defaultContentInset.bottom, _defaultContentInset.right);
	} else if (scrollView.isDragging) {
		if (_state == DTPullRefreshPulling && scrollView.contentOffset.y > -65.0f-_defaultContentInset.top && scrollView.contentOffset.y < -_defaultContentInset.top) {
            if (![self isTableModelLoading]) {
                [self setState:DTPullRefreshNormal];
            }
		} else if (_state == DTPullRefreshNormal && scrollView.contentOffset.y < -65.0f-_defaultContentInset.top) {
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
	
	BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(pullRefreshTableHeaderDataSourceIsLoading:)]) {
		_loading = [_delegate pullRefreshTableHeaderDataSourceIsLoading:self];
	}
	
	if (scrollView.contentOffset.y < -65.0f-_defaultContentInset.top && !_loading) {
		if ([_delegate respondsToSelector:@selector(pullRefreshTableHeaderDidTriggerRefresh:)]) {
			[_delegate pullRefreshTableHeaderDidTriggerRefresh:self];
		}
		[self setState:DTPullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3];
		scrollView.contentInset = UIEdgeInsetsMake(_defaultContentInset.top+60, _defaultContentInset.left, _defaultContentInset.bottom, _defaultContentInset.right);
		[UIView commitAnimations];
	} else if (_state == DTPullRefreshNormal) {
        
    }
}

- (void)didPullRefreshScrollView:(UIScrollView *)scrollView
{
    BOOL _loading = NO;
    if ([_delegate respondsToSelector:@selector(pullRefreshTableHeaderDataSourceIsLoading:)]) {
        _loading = [_delegate pullRefreshTableHeaderDataSourceIsLoading:self];
    }
    
    if (!_loading) {
        if ([_delegate respondsToSelector:@selector(pullRefreshTableHeaderDidTriggerRefresh:)]) {
            [_delegate pullRefreshTableHeaderDidTriggerRefresh:self];
        }
        scrollView.contentInset = UIEdgeInsetsMake(_defaultContentInset.top+60, _defaultContentInset.left, _defaultContentInset.bottom, _defaultContentInset.right);
        [self setState:DTPullRefreshLoading];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        scrollView.contentOffset = CGPointMake(0, -_defaultContentInset.top-60);
        [UIView commitAnimations];
    }
}

- (void)delayToNormalWithScrollView:(UIScrollView *)scrollView
{
    if (!self.delegate) return;
    
    double nowTime = CFAbsoluteTimeGetCurrent();
    if (_needDelay&&nowTime-_animationBegin<PULLREFRESH_ANIMATION_NDURATION) {
        [self performSelector:@selector(delayToNormalWithScrollView:) withObject:scrollView afterDelay:PULLREFRESH_ANIMATION_NDURATION-(nowTime-_animationBegin)];
        return;
    } else {
        [self pullRefreshViewToNormalWithScrollView:scrollView];
        return;
    }
}

- (void)pullRefreshViewToNormalWithScrollView:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:0.3f animations:^{
        [scrollView setContentInset:_defaultContentInset];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            _aniImageView.alpha = 0.f;
        } completion:^(BOOL finished) {
            _aniImageView.alpha = 1.0;
            [self setState:DTPullRefreshNormal];
        }];
    }];
    if (_needDelay&&_finishBlock) {
        _needDelay = NO;
        _finishBlock();
    }
    return;
    [self setState:DTPullRefreshNormal];
    [UIView animateWithDuration:0.5f animations:^{
        _activeImageView.alpha = 0;
    } completion:^(BOOL finished) {
        [self stopAnimation];
        [UIView animateWithDuration:0.3f animations:^{
            [scrollView setContentInset:_defaultContentInset];
        } completion:^(BOOL finished) {
            _activeImageView.alpha = 1.0f;
        }];
    }];

}

- (void)pullRefreshScrollViewDataSourceDidFinishLoading:(UIScrollView *)scrollView {
    if (_needDelay) {
        [self delayToNormalWithScrollView:scrollView];
    } else {
        [self pullRefreshViewToNormalWithScrollView:scrollView];
    }
}

@end

@implementation DTPullRefreshImage

+ (DTPullRefreshImage *)shareInstace
{
    static id instance = nil;
    @synchronized(self) {
        if (instance==nil) {
            instance = [[DTPullRefreshImage alloc] init];
        }
    }
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //bgcolor f2f2f2
        NSData *imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dt_refresh_loading@2x" ofType:@"gif"]];
        _aniImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:imageData];
        
        [self setVelocity:PULLREFRESH_ANIMATION_VELOCITY];
    }
    return self;
}

- (void)setVelocity:(CGFloat)velocity
{
    NSMutableArray *array = [NSMutableArray array];
    //for (int i=0; i<_aniImage.delayTimes.count; i++) {
    //    float time = [_aniImage.delayTimes[i] floatValue]/velocity;
      //  [array addObject:@(time)];
    //}
    [_aniImage setValue:array forKey:@"_delayTimes"];
}

@end


@implementation FLAnimatedImageView (DTPullRefresh)

- (void)setIndex:(NSInteger)index
{
    if (self.animatedImage) {
        [self setValue:@(index) forKey:@"_currentFrameIndex"];
      //  float time = [self.animatedImage.delayTimes[index] floatValue];
        //[self setValue:@(time) forKey:@"_accumulator"];
        [self setValue:[self.animatedImage imageLazilyCachedAtIndex:index] forKey:@"_currentFrame"];
        [self.layer setNeedsDisplay];
    }
}



@end

@interface DTPushRefreshHeadView () {
    DTPullRefreshState _state;
    UIView *_activeBodyView;
    DTEnrollProgressView *_progressView;
    
    double _animationBegin;
    
    CGFloat _minGapY;
}

@end

@implementation DTPushRefreshHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        _activeBodyView = [[UIView alloc] initWithFrame:self.bounds];
//        _activeBodyView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//        _activeBodyView.backgroundColor = [UIColor clearColor];
//        [self addSubview:_activeBodyView];
        
        _minOffsetY = 60.f;
        
        DTEnrollProgressView *progressView = [DTEnrollProgressView new];
        progressView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:progressView];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:progressView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:progressView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:progressView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:36]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:progressView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:progressView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
        
        _progressView = progressView;
        
        _needDelay = YES;
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

- (void)viewWillAppear
{
    if (_state == DTPullRefreshLoading) {
        [self startAnimation];
    }
}

- (void)startAnimation
{
    _animationBegin = CFAbsoluteTimeGetCurrent();
    [_progressView startAnimating];
}

- (void)stopAnimation
{
    [_progressView stopAnimating];
}

- (void)setState:(DTPullRefreshState)aState
{
    switch (aState) {
        case DTPullRefreshLoading:
            [self startAnimation];
            break;
        case DTPullRefreshNormal:
            [self stopAnimation];
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
    
    if (offset<-_minOffsetY) {
        _activeBodyView.top = offset+_minOffsetY;
    } else {
        _activeBodyView.top = 0;
    }
    
    if (_state != DTPullRefreshLoading) {
        CGFloat progress;
        if (offset<-_minOffsetY / 2 && _minOffsetY > 0) {
            progress = (-offset-_minOffsetY)/_minOffsetY+0.5;
        } else {
            progress = 0.f;
        }
        
        _progressView.progress = MIN(progress, 1.f);
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

- (void)delayToNormalWithScrollView:(UIScrollView *)scrollView
{
    if (!self.delegate) return;
    
    double nowTime = CFAbsoluteTimeGetCurrent();
    if (_needDelay&&nowTime-_animationBegin<PULLREFRESH_ANIMATION_NDURATION) {
        [self performSelector:@selector(delayToNormalWithScrollView:) withObject:scrollView afterDelay:PULLREFRESH_ANIMATION_NDURATION-(nowTime-_animationBegin)];
        return;
    } else {
        [self pullRefreshViewToNormalWithScrollView:scrollView];
        return;
    }
}

- (void)pullRefreshViewToNormalWithScrollView:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:0.3f animations:^{
        [scrollView setContentInset:_defaultContentInset];
    } completion:^(BOOL finished) {
        [self setState:DTPullRefreshNormal];
        [UIView animateWithDuration:0.3 animations:^{
            _progressView.progress = 0;
        } completion:^(BOOL finished) {
            
        }];
    }];
    if (_needDelay&&_finishBlock) {
        _needDelay = NO;
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

@end
