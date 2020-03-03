//
//  DTControllerListView.m
//  DrivingTest
//
//  Created by cheng on 16/11/7.
//  Copyright © 2016年 eclicks. All rights reserved.
//

#import "DTControllerListView.h"
//#import "DTViewController.h"
#import "WCUICommon.h"

@interface DTControllerListView () <UIScrollViewDelegate>
{
    CGRect _markRect;
    BOOL _prepare;
    
    NSMutableSet *_visibleControllers;
    
     id _lastController;
    
  
}

@property (nonatomic, readonly) NSInteger count;

@end

@implementation DTControllerListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIScrollView *scrollView = [[DTListScrollView alloc] initWithFrame:self.bounds];
        scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        scrollView.pagingEnabled = YES;
        scrollView.bounces = NO;
        scrollView.scrollsToTop = NO;
#ifdef __IPHONE_11_0
        if (AvailableiOS(11.0)) {
            [scrollView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        }
#endif
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        self.scrollView.delegate = self;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator   = NO;
        
        _selectedIndex = 0;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame controllerList:(NSArray *)controllerList selectedIndex:(NSInteger)selectedIndex
{
    if (self = [self initWithFrame:frame]) {
        
        _isView = NO;

        _selectedIndex = 0;
        if (selectedIndex < controllerList.count && selectedIndex >= 0) {
            _selectedIndex = selectedIndex;
        }
        
        self.controllerList = controllerList;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame ViewList:(NSArray *)viewList selectedIndex:(NSInteger)selectedIndex
{
    if (self = [self initWithFrame:frame]) {
        
        _isView = YES;
        
        _selectedIndex = 0;
        if (selectedIndex < viewList.count && selectedIndex >= 0) {
            _selectedIndex = selectedIndex;
        }
        self.viewList = viewList;
    }
    return self;
}

- (NSInteger)count
{
    return _num;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (!CGSizeEqualToSize(frame.size, _markRect.size)) {
        _markRect = frame;
        _scrollView.contentSize = CGSizeMake(self.width * self.count, self.height);
        if ([self currentView]) {
            [[self currentView] setFrame:[self frameWithIndex:_selectedIndex]];
        }
        [_scrollView setContentOffset:CGPointMake(self.width * _selectedIndex, 0)];
    }
}

- (CGRect)frameWithIndex:(NSInteger)index
{
    return CGRectMake(self.width * index, 0, self.width, self.height);
}

- (void)setDelegate:(id<DTControllerListViewDelegate>)delegate
{
    _delegate = delegate;
    [self setControllerListSuperController];
}

- (void)setControllerListSuperController
{
//    if (_controllerList.count && _delegate && [_delegate isKindOfClass:[DTViewController class]]) {
//        for (DTViewController *vc in _controllerList) {
//            if ([vc isKindOfClass:[DTViewController class]]) {
//                [vc setSuperDTController:_delegate];
//            }
//        }
//    }
}

- (void)setControllerList:(NSArray *)controllerList
{
    _isView = NO;
    
    if (_controllerList.count) {
        for (UIViewController *vc in _controllerList) {
            if (vc.viewLoaded) {
                [vc.view removeFromSuperview];
            }
        }
        [self setControllerListSuperController];
    }
    
    _controllerList = controllerList;
    
    self.num = _controllerList.count;
    
    [self reloadData];
}

- (void)setViewList:(NSArray *)viewList
{
    _isView = YES;
    if (_viewList) {
        for (UIView *view in _viewList) {
            [view removeFromSuperview];
        }
    }
    _viewList = viewList;
    
    self.num = _viewList.count;
    
    [self reloadData];
}

- (void)setNum:(NSInteger)num
{
    _num = num;
    _scrollView.contentSize = CGSizeMake(self.width * _num, self.height);
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    
    [self reloadData];
}

- (void)reloadData
{
    if (_selectedIndex >= self.count) {
        _selectedIndex = 0;
    }
    UIView *view = [self currentView];
    [view setFrame:[self frameWithIndex:_selectedIndex]];
    [_scrollView addSubview:view];
    
    [_scrollView setContentOffset:CGPointMake(self.width * _selectedIndex, 0) animated:YES];
    
    [self checkPreView];
}

- (UIView *)currentView
{
    if (_isView) {
        return [self itemWithIndex:_selectedIndex];
    } else {
        UIViewController *vc = [self itemWithIndex:_selectedIndex];
        if (vc) {
            return [vc view];
        }
    }
    return nil;
}

- (id)currentItem
{
    return [self itemWithIndex:_selectedIndex];
}

- (id)itemWithIndex:(NSInteger)index
{
    if (index < 0) {
        return nil;
    }
    id item = nil;
    if (_isView) {
        item = [_viewList safeObjectAtIndex:index];
    } else {
        item = [_controllerList safeObjectAtIndex:index];
    }
    if (!item && _delegate && [_delegate respondsToSelector:@selector(controllerListView:controllerForIndex:)]) {
        item = [_delegate controllerListView:self controllerForIndex:index];
    }
    return item;
}

- (void)prepareControllerList
{
    if (!_prepare) {
        _prepare = YES;
        [self checkPreView];
    }
}

- (void)checkPreView
{
    //预加载
    if (_prepare && !_isView) {
        [[self itemWithIndex:_selectedIndex - 1] view];
        [[self itemWithIndex:_selectedIndex + 1] view];
    }
}

#pragma mark - scrollView代理

- (NSInteger)calCurrentIndex
{
    NSInteger index = floorf((_scrollView.contentOffset.x-_scrollView.width/2)/_scrollView.width)+1;
    if (index < 0) {
        index = 0;
    }
    return index;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSMutableSet *removeSet = [NSMutableSet set];
    for (id item in _visibleControllers) {
        UIView *view = item;
        if (!_isView) {
            view = [item view];
        }
        if (view.right <= scrollView.contentOffset.x || view.left >= scrollView.contentOffset.x + scrollView.width) {
            [view removeFromSuperview];
            [removeSet addObject:item];
        }
    }
    
    if (_visibleControllers == nil) {
        _visibleControllers = [NSMutableSet setWithCapacity:self.count];
    }
    
    if ((scrollView.isDragging || scrollView.isTracking)) {
   
        for (NSInteger i=0; i < self.count; i++) {
            CGRect rect = CGRectMake(self.width * i, 0, self.width, self.height);
            if (CGRectGetMinX(rect) >= scrollView.contentOffset.x + scrollView.width) {
                break;
            } else if (CGRectGetMaxX(rect) > scrollView.contentOffset.x) {
                id item = [self itemWithIndex:i];
                if (![_visibleControllers containsObject:item]) {
                    UIView *view = item;
                    if (!_isView) {
                        view = [item view];
                    }
                    [view setFrame:rect];
                    [_scrollView addSubview:view];
                    [_visibleControllers addObject:item];
                }
            }
        }
    }
    
    [_visibleControllers minusSet:removeSet];
    [removeSet removeAllObjects];
    removeSet = nil;
    
//    if ((scrollView.isDragging || scrollView.isTracking) && _delegate && [_delegate respondsToSelector:@selector(controllerListView:didScrollView:)]){
//        [_delegate controllerListView:self didScrollView:scrollView];
//    }
    if (_delegate && [_delegate respondsToSelector:@selector(controllerListView:didScrollView:)]){
        [_delegate controllerListView:self didScrollView:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = [self calCurrentIndex];
    [self changeSelectedIdnex:index];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSInteger index = [self calCurrentIndex];
    [self changeSelectedIdnex:index];
    
    if (_lastController && _lastController != [self currentItem]) {
        UIView *view = _lastController;
        if (!_isView) {
            view = [_lastController view];
        }
        [view removeFromSuperview];
    }
    
    _lastController = [self currentItem];
}

- (void)changeSelectedIdnex:(NSInteger)selectedIndex
{
    if (_selectedIndex != selectedIndex) {
        _selectedIndex = selectedIndex;
        
        [self checkPreView];
    }
    if(_delegate && [_delegate respondsToSelector:@selector(controllerListView:didSelectedIndex:)]){
        [_delegate controllerListView:self didSelectedIndex:selectedIndex];
    }
}

@end

@interface DTCollectionListView () <UICollectionViewDataSource, UICollectionViewDelegate> {
    
}

@end

@implementation DTCollectionListView

+ (NSString *)cellId
{
    static NSString *cellId = @"DTCollectionListViewCell";
    return cellId;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self = [self initWithFrame:frame collectionViewLayout:flowLayout];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [UIColor clearColor];
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.pagingEnabled = NO;
        self.dataSource = self;
        self.delegate = self;
        
        [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:[[self class] cellId]];
    }
    return self;
}

- (void)setControllerList:(NSArray *)controllerList
{
    _controllerList = controllerList;
    [self reloadData];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    [self scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

- (UIViewController *)currentController
{
    return [self controllerWithIndex:_selectedIndex];
}

- (UIViewController *)controllerWithIndex:(NSInteger)index
{
    if (index < 0) {
        return nil;
    }
    return [_controllerList safeObjectAtIndex:index];
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return _controllerList.count;
            break;
        default:
            break;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[[self class] cellId] forIndexPath:indexPath];
    if (cell == nil) {
        cell = [UICollectionViewCell new];
    }
    [cell.contentView addSubview:[self controllerWithIndex:indexPath.item].view];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return collectionView.size;
}

@end

@implementation DTListScrollView

- (void)setContentOffset:(CGPoint)contentOffset
{
    [super setContentOffset:contentOffset];
}

@end
