//
//  DTControllerListView.h
//  DrivingTest
//
//  Created by cheng on 16/11/7.
//  Copyright © 2016年 eclicks. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DTControllerListView;

@protocol DTControllerListViewDelegate <NSObject>
/**
 *  代理方法
 *
 *  @param currentView 当前的UIview
 *  @param index       当前view的索引
 */
- (void)controllerListView:(DTControllerListView *)view didSelectedIndex:(NSInteger)selectedIndex;

@optional
- (void)controllerListView:(DTControllerListView *)view didScrollView:(UIScrollView *)scrollView;
- (void)controllerListView:(DTControllerListView *)view reloadSelectedIndex:(NSInteger)selectedIndex;
- (UIViewController *)controllerListView:(DTControllerListView *)view controllerForIndex:(NSInteger)selectedIndex;

@end

@interface DTControllerListView : UIView

- (instancetype)initWithFrame:(CGRect)frame controllerList:(NSArray *)controllerList selectedIndex:(NSInteger)selectedIndex;
- (instancetype)initWithFrame:(CGRect)frame ViewList:(NSArray *)viewList selectedIndex:(NSInteger)selectedIndex;

@property (nonatomic ,weak) id<DTControllerListViewDelegate> delegate;
@property (nonatomic, assign)  BOOL isView;;
@property (nonatomic) NSInteger selectedIndex;
//以下数据 二选一
@property (nonatomic, strong) NSArray *controllerList;
@property (nonatomic, strong) NSArray *viewList;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) NSInteger num;

- (void)reloadData;
- (void)prepareControllerList;// is controller need
- (id)itemWithIndex:(NSInteger)index;
//- (void)changeToSelectedIndex:(NSInteger)selectedIndex;


@end

@interface DTCollectionListView : UICollectionView

@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic, strong) NSArray *controllerList;

@end

@interface DTListScrollView : UIScrollView

@end
