//
//  DTPagesController.m
//  DrivingTest
//
//  Created by cheng on 16/10/28.
//  Copyright © 2016年 eclicks. All rights reserved.
//

#import "DTPagesController.h"

@interface DTPagesController () {
    
    UIPanGestureRecognizer *_pan;
    BOOL _moveFinish;
    
    CGFloat _oneDirectionMoveDistance;
    BOOL _lastMoveDirection;
    BOOL _lastValidMoveDirection;
}

@end

@implementation DTPagesController

- (void)dealloc
{
    self.dataSource = nil;;
    self.delegate = nil;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _currentIndex = 0;
        
        _moveDuration = 0.25;
        _validMoveDistance = 40;
        
        _pageLoop = NO;
        _disablePan = NO;
        
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _contentView = [[UIView alloc] initWithFrame:self.view.bounds];
    _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _contentView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_contentView];
    
    [self updateContentView];
    
    _centerView = [self createTheView];
    _leftView   = [self createTheView];
    _rightView  = [self createTheView];
    
    [self prepareMove];
    
//    [self reloadData];
    
    _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    _pan.delegate = self;
    [self.view addGestureRecognizer:_pan];
    
    [self setDisablePan:_disablePan];
}

- (void)setDisablePan:(BOOL)disablePan
{
    _disablePan = disablePan;
    _pan.enabled = !disablePan;
}

- (BOOL)addGestureAfterPan:(UIGestureRecognizer *)gesture
{
    if (_pan) {
        [gesture requireGestureRecognizerToFail:_pan];
        return YES;
    }
    return NO;
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    if (currentIndex >= [self numberOfCount]) {
        return;
    }
    _currentIndex = currentIndex;
}

#pragma mark - public method

- (DTPagesView *)createTheView
{
    DTPagesView *view = nil;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(createPageView)]) {
        view = [self.dataSource createPageView];
    }
    if (!view) {
        view = [[DTPagesView alloc] initWithFrame:_contentView.bounds];
    }
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [_contentView addSubview:view];
    return view;
}

- (NSInteger)numberOfCount
{
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfPageViewCount)]) {
        return [self.dataSource numberOfPageViewCount];
    }
    return 0;
}

- (void)reloadData
{
    self.currentIndex = _currentIndex;
    
    [self updateView];
}

- (void)updateView
{
    [self setPageView:_centerView withIndex:_currentIndex];
    [self setPageView:_leftView   withIndex:_currentIndex-1];
    [self setPageView:_rightView  withIndex:_currentIndex+1];
    
    [_leftView   viewDidHidden];
    [_rightView  viewDidHidden];
    [_centerView   viewDidShow];
    _leftView.hidden = _rightView.hidden = YES;
}

- (void)updateContentView
{
    //do in subclass
}

- (void)checkUpdateView
{
    if (_centerView.index != _currentIndex) {
        [self setPageView:_centerView withIndex:_currentIndex];
    }
    if (_leftView.index != _currentIndex-1) {
        [self setPageView:_leftView withIndex:_currentIndex-1];
    }
    if (_rightView.index != _currentIndex+1) {
        [self setPageView:_rightView withIndex:_currentIndex+1];
    }
}

- (void)setPageView:(DTPagesView *)view withIndex:(NSInteger)index
{
    view.index = index;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(updatePageView:withIndex:)]) {
        [self.dataSource updatePageView:view withIndex:index];
    }
}

#pragma mark - private method

- (DTPagesView *)moveView
{
    if (_moveNext) {
        return _centerView;
    } else {
        return _leftView;
    }
}

- (BOOL)canMove
{
    if (self.pageLoop) {
        return [self numberOfCount] > 1;
    } else {
        if (_moveNext) {
            return _currentIndex < [self numberOfCount] - 1;
        } else {
            return _currentIndex > 0;
        }
    }
}

- (BOOL)moveValid
{
    if (_moveNext) {
        return _centerView.left <= - self.validMoveDistance;
    } else {
        return _leftView.right >= self.validMoveDistance;
    }
}

- (BOOL)checkMoveOffset:(CGFloat)offset
{
    if (_moveNext) {
        return offset < 0.f;
    } else {
        return offset > - self.view.width;
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == _pan) {
        return _moveFinish;
    }
    return YES;
}

- (void)panAction:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [gesture translationInView:self.view];
        _moveNext = (point.x<0);
        _leftView.hidden = _moveNext;
        _rightView.hidden = !_moveNext;
        _lastMoveDirection = _moveNext;
        _lastValidMoveDirection = _moveNext;
        _oneDirectionMoveDistance = 0;
        [self prepareMove];
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [gesture translationInView:self.view];
        if (fabs(point.x) >= 0.1) {
            BOOL validMove = (point.x < 0);
            if (_lastMoveDirection != validMove) {
                _lastMoveDirection = validMove;
                _oneDirectionMoveDistance = point.x;
            } else {
                _oneDirectionMoveDistance += point.x;
            }
            
            if (_lastValidMoveDirection != _lastMoveDirection && fabs(_oneDirectionMoveDistance) >= self.validMoveDistance * 1.2) {
                _lastValidMoveDirection = _lastMoveDirection;
            }
        }
        
        if ([self canMove]) {
            CGFloat left = [self moveView].left + point.x;
            if ([self checkMoveOffset:left]) {
                [self moveView].left = left;
            } else {
                [self resetMoveNext:!_moveNext];
                [self prepareMove];
            }
        } else {
            BOOL moveNext = (point.x < 0);
            [self resetMoveNext:moveNext];
            [self prepareMove];
        }
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        if (_lastValidMoveDirection != _moveNext) {
            [self moveToCurrent];
            return;
        }
        if ([self canMove]) {
            [self move:[self moveValid]];
        } else {
            if (_moveNext) {
                [self theLastOneMoveToNext];
            } else {
                [self theFirstOneMoveToPrevious];
            }
        }
    } else {
        [self moveToCurrent];
    }
    [gesture setTranslation:CGPointZero inView:self.view];
}

- (void)resetMoveNext:(BOOL)moveNext
{
    if (_moveNext != moveNext) {
        _moveNext = moveNext;
        _leftView.hidden = _moveNext;
        _rightView.hidden = !_moveNext;
    }
}

- (void)prepareMove
{
    _moveFinish = YES;
    _centerView.hidden = NO;
    _leftView.right = _rightView.left = _centerView.left = 0;
    [_contentView insertSubview:_leftView aboveSubview:_centerView];
    [_contentView insertSubview:_rightView belowSubview:_centerView];
}

- (void)willBeginMove
{
    _moveFinish = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(pagesControllerWillBeginMove)]) {
        [self.delegate pagesControllerWillBeginMove];
    }
}

- (void)didMoveEnd
{
    [self prepareMove];
    _leftView.hidden = _rightView.hidden = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(pagesControllerDidMoveEnd)]) {
        [self.delegate pagesControllerDidMoveEnd];
    }
}

- (void)move:(BOOL)valid
{
    if (valid) {
        if (_moveNext) {
            [self moveToNext];
        } else {
            [self moveToPrevious];
        }
    } else {
        [self moveToCurrent];
    }
}

- (void)moveToNext
{
    @synchronized (self) {
        if (_currentIndex == [self numberOfCount]-1) {
            [self moveToCurrent];
            return;
        }
        
        [self willBeginMove];
        
        DTPagesView *view = _leftView;
        _leftView = _centerView;
        _centerView = _rightView;
        _rightView = view;
        
        _leftView.hidden = _centerView.hidden = NO;
        
        _currentIndex ++;
//        CGFloat duration = _moveDuration * fabs(_leftView.right) / self.view.width;
        [UIView animateWithDuration:_moveDuration animations:^{
            _leftView.right = 0.f;
        } completion:^(BOOL finished) {
            [_leftView viewDidHidden];
            [_centerView viewDidShow];
            self.currentIndex = _currentIndex;
            [self checkUpdateView];
            [self didMoveEnd];
        }];
    }
}

- (void)moveToPrevious
{
    @synchronized (self) {
        if (_currentIndex == 0) {
            [self moveToCurrent];
            return;
        }
        
        [self willBeginMove];
        
        DTPagesView *view = _rightView;
        _rightView = _centerView;
        _centerView = _leftView;
        _leftView = view;
        
        _rightView.hidden = _centerView.hidden = NO;
        
        _currentIndex --;
//        CGFloat duration = _moveDuration * fabs(_centerView.left) / self.view.width;
        [UIView animateWithDuration:_moveDuration animations:^{
            _centerView.left = 0.f;
        } completion:^(BOOL finished) {
            [_rightView viewDidHidden];
            [_centerView viewDidShow];
            self.currentIndex = _currentIndex;
            [self checkUpdateView];
            [self didMoveEnd];
        }];
    }
}

- (void)moveToCurrent
{
    [UIView animateWithDuration:0.25 animations:^{
        _leftView.right = _rightView.left = _centerView.left = 0;
    } completion:^(BOOL finished) {
        _leftView.hidden = _rightView.hidden = YES;
    }];
}

- (void)moveToIndex:(NSInteger)index
{
    if (_currentIndex < index) {
        _currentIndex = index-1;
        [self setPageView:_rightView withIndex:index];
        [self moveToNext];
    } else if (_currentIndex > index) {
        _currentIndex = index+1;
        [self setPageView:_leftView withIndex:index];
        [self moveToPrevious];
    } else {
        [self moveToCurrent];
    }
}

- (void)theFirstOneMoveToPrevious
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pagesControllerDidTheFirstOneMoveToPrevious)]) {
        [self.delegate pagesControllerDidTheFirstOneMoveToPrevious];
    }
}

- (void)theLastOneMoveToNext
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pagesControllerDidTheLastOneMoveToNext)]) {
        [self.delegate pagesControllerDidTheLastOneMoveToNext];
    }
}

@end

@implementation DTPagesView

- (void)viewDidShow
{
    _showing = YES;
}

- (void)viewDidHidden
{
    _showing = NO;
}

- (void)prepareForReuse
{
    
}

@end
