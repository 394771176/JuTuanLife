//
//  DTHorizontalScrollView.h
//  YHHB
//
//  Created by Hunter Huang on 11/30/11.
//  Copyright (c) 2011 vge design. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DTHorizontalScrollViewDataSource;
@protocol DTHorizontalScrollViewDelegate;
@class DTHorizontalScrollItemView;

@interface DTHorizontalScrollView : UIScrollView

@property (nonatomic, weak) id<DTHorizontalScrollViewDataSource> horizontalDataSource;
@property (nonatomic, weak) id<DTHorizontalScrollViewDelegate> horizontalDelegate;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) CGFloat viewPadding;
@property (nonatomic) BOOL respondent;
@property (nonatomic) BOOL nonreusable;//无需重用
@property (nonatomic) BOOL alwaysPanBack;//滑动返回始终有效
@property (nonatomic) BOOL canPanBack;

@property (nonatomic) BOOL noChangeWhenDrag;//default is NO

@property (nonatomic) CGFloat gap;

- (DTHorizontalScrollItemView *)dequeueReusableItemView;
- (DTHorizontalScrollItemView *)dequeueReusableItemViewWithId:(NSString *)identifier;

- (void)clearMemory;
- (void)moveToNext;
- (void)reloadData;

- (void)resizeToFrame:(CGRect)rect animated:(BOOL)animated;

- (void)setCurrentIndex:(NSInteger)index animated:(BOOL)animated;
- (void)setCurrentIndex:(NSInteger)index animated:(BOOL)animated event:(BOOL)event;

- (DTHorizontalScrollItemView *)itemViewAtIndex:(NSUInteger)index;

@end

@protocol DTHorizontalScrollViewDataSource <NSObject>

- (NSInteger)numberOfItems;
- (DTHorizontalScrollItemView *)horizontalScrollView:(DTHorizontalScrollView *)scroller itemViewForIndex:(NSInteger)index;

@end

@protocol DTHorizontalScrollViewDelegate <NSObject>

@optional
- (void)horizontalScrollView:(DTHorizontalScrollView *)scroller didSelectIndex:(NSInteger)index;
- (void)horizontalScrollViewDidFinishedAnimation:(DTHorizontalScrollView *)scroller;
- (void)horizontalScrollViewDidScrollToTheLastItem:(DTHorizontalScrollView *)scroller;
- (void)horizontalScrollViewDidScroll:(DTHorizontalScrollView *)scroller;

@end


@interface DTHorizontalScrollItemView : UIView

@property (nonatomic) NSInteger index;
@property (nonatomic) BOOL showing;

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, assign) BOOL autoClassIdentifier;//default is NO

+ (NSString *)identifier;

- (void)viewDidShow;
- (void)viewDidHidden;

- (void)prepareForReuse;

@end
