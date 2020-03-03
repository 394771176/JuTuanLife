//
//  DTHorizontalScrollView.m
//  YHHB
//
//  Created by Hunter Huang on 11/30/11.
//  Copyright (c) 2011 vge design. All rights reserved.
//

#import "DTHorizontalScrollView.h"
#import "WCUICommon.h"

static const NSInteger preloadanswerNum = 1;

@interface DTHorizontalScrollView () <UIScrollViewDelegate> {
    CGFloat _panEdge;
}

@property (nonatomic, strong) NSMutableDictionary *reusableIdViews;
@property (nonatomic, strong) NSMutableSet *reusableViews;
@property (nonatomic, assign) int firstVisibleIndex;
@property (nonatomic, assign) int lastVisibleIndex;

@end

@implementation DTHorizontalScrollView

@synthesize horizontalDelegate, horizontalDataSource, currentIndex;
@synthesize reusableViews;
@synthesize firstVisibleIndex, lastVisibleIndex, viewPadding;

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@ dealloc", NSStringFromClass(self.class));
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.pagingEnabled = YES;
        self.scrollsToTop = NO;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.reusableViews = [NSMutableSet set];
        self.delegate = self;
        
        firstVisibleIndex = NSIntegerMax;
        lastVisibleIndex  = NSIntegerMin;
        
        _panEdge = 20.f/320*SCREEN_WIDTH;
        if (_panEdge>25) {
            _panEdge = 25;
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}

- (void)applicationDidEnterBackground:(id)notification {
    DTHorizontalScrollItemView *itemView = [self findViewWithTag:1000+currentIndex];
    if (itemView) {
        [itemView viewDidHidden];
    }
}
- (void)applicationWillEnterForeground:(id)notification {
    DTHorizontalScrollItemView *itemView = [self findViewWithTag:1000+currentIndex];
    if (itemView) {
        [itemView viewDidShow];
    }
}

- (void)clearMemory {
    [reusableViews removeAllObjects];
    reusableViews = [NSMutableSet set];
    [_reusableIdViews removeAllObjects];
}

- (DTHorizontalScrollItemView *)dequeueReusableItemView {
    return [self dequeueReusableItemViewWithId:nil];
}

- (DTHorizontalScrollItemView *)dequeueReusableItemViewWithId:(NSString *)identifier {
    if (_nonreusable) {
        return nil;
    }
    if (!identifier) {
        DTHorizontalScrollItemView *view = [reusableViews anyObject];
        if (view) {
            [reusableViews removeObject:view];
            [view prepareForReuse];
        }
        return view;
    } else {
        NSMutableArray *array = [_reusableIdViews objectForKey:identifier];
        if (array.count) {
            DTHorizontalScrollItemView *view = [array firstObject];
            if (view) {
                [array removeObject:view];
                [view prepareForReuse];
            }
            return view;
        }
    }
    return nil;
}

- (void)enqueueReusableItemViews {
    for (UIView *view in [self subviews]) {
        if ([view isKindOfClass:[DTHorizontalScrollItemView class]]) {
            [self addReusableItemView:(id)view];
        }
    }
    
    firstVisibleIndex = NSIntegerMax;
    lastVisibleIndex  = NSIntegerMin;
}

- (void)addReusableItemView:(DTHorizontalScrollItemView *)view
{
    if (_nonreusable) {
        [view removeFromSuperview];
        return;
    }
    if ([view isKindOfClass:[DTHorizontalScrollItemView class]]) {
        if (!view.identifier) {
            [reusableViews addObject:view];
            [view removeFromSuperview];
        } else {
            if (!_reusableIdViews) {
                _reusableIdViews = [NSMutableDictionary dictionary];
            }
            NSMutableArray *array = [_reusableIdViews objectForKey:view.identifier];
            if (!array) {
                array = [NSMutableArray arrayWithObject:view];
                [_reusableIdViews safeSetObject:array forKey:view.identifier];
            } else {
                [array safeAddObject:view];
            }
            [view removeFromSuperview];
        }
    }
}

- (void)reloadData {
    DTHorizontalScrollItemView *itemView = [self findViewWithTag:1000+currentIndex];
    if (itemView) {
        [itemView viewDidHidden];
    }
    [self enqueueReusableItemViews];
    // force to call layoutSubviews
    [self layoutSubviews];
    itemView = [self findViewWithTag:1000+currentIndex];
    if (itemView) {
        [itemView viewDidShow];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect visibleBounds = [self bounds];
    CGFloat visibleWidth = visibleBounds.size.width;
    CGFloat visibleHeight = visibleBounds.size.height;
    
    NSInteger answerNum = horizontalDataSource?[horizontalDataSource numberOfItems]:0;
    self.contentSize = CGSizeMake(answerNum*visibleWidth, visibleHeight);
    
    CGFloat leftDelta = visibleBounds.origin.x-visibleWidth*preloadanswerNum;
    CGFloat extendedVisibleWidth = (preloadanswerNum*2+1)*visibleWidth;
    if (leftDelta < 0) {
        extendedVisibleWidth += leftDelta;
    }
    CGRect extendedVisibleBounds = CGRectMake(MAX(0, visibleBounds.origin.x-preloadanswerNum*visibleWidth), 0, extendedVisibleWidth, visibleHeight);
    // Recycle all views that are no longer visible
    for (UIView *view in [self subviews]) {
        if ([view isKindOfClass:[DTHorizontalScrollItemView class]]) {
            CGRect viewFrame = [view frame];
            // If the view doesn't intersect, it's not visible, so we can recycle it
            if (! CGRectIntersectsRect(viewFrame, extendedVisibleBounds)) {
                [self addReusableItemView:(id)view];
//                NSLog(@"reusableViews enque:%i", reusableViews.count);
            }
        }
    }
    
    int startIndex = MAX(0, floorf((extendedVisibleBounds.origin.x)/visibleWidth));
    int endIndex = MIN(answerNum, ceilf((extendedVisibleBounds.origin.x+extendedVisibleBounds.size.width)/visibleWidth));// 预加载2张
    
    for (int index = startIndex; index < endIndex; index++) {
        BOOL isItemViewMissing = index < firstVisibleIndex || index >= lastVisibleIndex;
        if (isItemViewMissing) {
            DTHorizontalScrollItemView *itemView = nil;
            if (horizontalDataSource) {
                itemView = [horizontalDataSource horizontalScrollView:self itemViewForIndex:index];
            }
            // Set the frame so the view is inserted into the correct position.
            itemView.index = index;
            itemView.tag = index+1000;
            [itemView setFrame:CGRectMake(index*visibleWidth+viewPadding, 0, visibleWidth-viewPadding*2, visibleHeight)];
            [self addSubview:itemView];
        }
    }
    
    // Remember which thumb view indexes are visible.
    firstVisibleIndex = startIndex;
    lastVisibleIndex  = endIndex;
}

- (void)setCurrentIndex:(NSInteger)index
{
    if (index<0) {
        return;
    }
    [self setCurrentIndex:index animated:NO];
    DTHorizontalScrollItemView *itemView = [self findViewWithTag:1000+currentIndex];
    if (itemView) {
        [itemView viewDidShow];
    }
}

- (void)setCurrentIndex:(NSInteger)index animated:(BOOL)animated
{
    [self setCurrentIndex:index animated:animated event:NO];
}

- (void)setCurrentIndex:(NSInteger)index animated:(BOOL)animated event:(BOOL)event
{
    if (index<0) {
        return;
    }
    DTHorizontalScrollItemView *itemView = [self findViewWithTag:1000+currentIndex];
    [itemView viewDidHidden];
    currentIndex = index;
    CGRect rect = self.bounds;
    rect.origin.x = rect.size.width * currentIndex;
    if (animated) {
        [UIView animateWithDuration:0.3f animations:^{
            [self scrollRectToVisible:rect animated:NO];
        } completion:^(BOOL finished){
            if (finished&&event) {
                if ([horizontalDelegate respondsToSelector:@selector(horizontalScrollViewDidFinishedAnimation:)]) {
                    [horizontalDelegate horizontalScrollViewDidFinishedAnimation:self];
                }
            }
            DTHorizontalScrollItemView *itemView = [self findViewWithTag:1000+currentIndex];
            if (itemView) {
                [itemView viewDidShow];
            }
        }];
    } else {
        [self scrollRectToVisible:rect animated:animated];
        [self layoutSubviews];
        DTHorizontalScrollItemView *itemView = [self findViewWithTag:1000+currentIndex];
        if (itemView) {
            [itemView viewDidShow];
        }
    }
}

- (DTHorizontalScrollItemView *)itemViewAtIndex:(NSUInteger)index
{
    return [self findViewWithTag:1000+index];
}

- (DTHorizontalScrollItemView *)findViewWithTag:(NSUInteger)tag
{
    for (UIView *sub in self.subviews) {
        if ([sub isKindOfClass:[DTHorizontalScrollItemView class]] && sub.tag==tag) {
            return (DTHorizontalScrollItemView *)sub;
        }
    }
    return nil;
}

- (void)updateCurrentIndex
{
//    int index = floorf(self.bounds.origin.x/self.bounds.size.width);
    int index = floorf((self.bounds.origin.x-self.bounds.size.width/2)/self.bounds.size.width)+1;
    if (index != currentIndex && index >= 0) {
        DTHorizontalScrollItemView *itemView = [self findViewWithTag:1000+currentIndex];
        if (itemView) {
            [itemView viewDidHidden];
        }
        currentIndex = index;
        itemView = [self findViewWithTag:1000+currentIndex];
        if (itemView) {
            [itemView viewDidShow];
        }
        if ([horizontalDelegate respondsToSelector:@selector(horizontalScrollView:didSelectIndex:)]) {
            [horizontalDelegate horizontalScrollView:self didSelectIndex:currentIndex];
        }
        
        // 统计信息
        if (_respondent) {
            static BOOL isReportScroll = NO;
            if (!isReportScroll) {
                isReportScroll = YES;
                
            }
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    if (scrollView.isDragging && !_noChangeWhenDrag) {
//        [self updateCurrentIndex];
//    }
    if ([self.horizontalDelegate respondsToSelector:@selector(horizontalScrollViewDidScroll:)]) {
        [self.horizontalDelegate horizontalScrollViewDidScroll:self];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
//    if (!decelerate) {
//        [self updateCurrentIndex];
//    }
    if (scrollView.contentOffset.x+scrollView.frame.size.width > scrollView.contentSize.width + 30) {
        if ([horizontalDelegate respondsToSelector:@selector(horizontalScrollViewDidScrollToTheLastItem:)]) {
            [horizontalDelegate horizontalScrollViewDidScrollToTheLastItem:self];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updateCurrentIndex];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self updateCurrentIndex];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)moveToNextDelay
{
    NSInteger itemNum = horizontalDataSource?[horizontalDataSource numberOfItems]:0;
    if (currentIndex+1<itemNum) {
        [self setCurrentIndex:currentIndex+1 animated:YES];
        if ([horizontalDelegate respondsToSelector:@selector(horizontalScrollView:didSelectIndex:)]) {
            [horizontalDelegate horizontalScrollView:self didSelectIndex:currentIndex];
        }
    } else if (itemNum > 0) {
        if ([horizontalDelegate respondsToSelector:@selector(horizontalScrollViewDidScrollToTheLastItem:)]) {
            [horizontalDelegate horizontalScrollViewDidScrollToTheLastItem:self];
        }
    }
}

- (void)moveToNext
{
    if (IS_IPHONE) {
        [self performSelector:@selector(moveToNextDelay) withObject:nil afterDelay:0.6f];
    } else {
        [self performSelector:@selector(moveToNextDelay) withObject:nil afterDelay:0.5f];
    }
}

- (void)resizeToFrame:(CGRect)rect animated:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:0.3f animations:^{
            self.frame = rect;
        }];
    } else {
        self.frame = rect;
        
    }

    self.contentOffset = CGPointMake(currentIndex*self.width, 0);
    
    for (NSInteger i=0, c=[self.subviews count]; i<c; i++) {
        DTHorizontalScrollItemView *view = [self.subviews safeObjectAtIndex:i];
        if ([view isKindOfClass:[DTHorizontalScrollItemView class]]) {
            [view setLeft:[view index]*self.width];
            if ([view index]==currentIndex) {
                if (animated) {
                    [UIView animateWithDuration:0.3f animations:^{
                        [view setFrame:CGRectMake([view index]*self.width, 0, self.width, self.height)];
                    }];
                } else {
                    [view setFrame:CGRectMake([view index]*self.width, 0, self.width, self.height)];
                }
            } else {
                [view setFrame:CGRectMake([view index]*self.width, 0, self.width, self.height)];
            }
        }
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (_canPanBack) {
        if (self.contentOffset.x<1.f||_alwaysPanBack) {
            if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
                UIPanGestureRecognizer *pan = (id)gestureRecognizer;
                CGPoint location = [pan locationInView:self];
                if (_alwaysPanBack) {
                    location.x -= self.contentOffset.x;
                }
                if (location.x<=_panEdge+_gap) {
                    return NO;
                }
            }
        }    
    }
    return [super gestureRecognizerShouldBegin:gestureRecognizer];
}

@end

@implementation DTHorizontalScrollItemView

- (void)dealloc
{
    NSLog(@"%@ dealloc", NSStringFromClass(self.class));
}

+ (NSString *)identifier
{
    return NSStringFromClass(self);
}

- (NSString *)identifier
{
    if (_autoClassIdentifier) {
        if (!_identifier) {
            return [self.class identifier];
        }
    }
    return _identifier;
}

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
