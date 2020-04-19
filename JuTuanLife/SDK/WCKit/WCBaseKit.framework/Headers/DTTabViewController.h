//
//  CWTabViewController.h
//  ChelunWelfare
//
//  Created by cheng on 15/1/22.
//  Copyright (c) 2015年 Wang Peng. All rights reserved.
//

#import "DTViewController.h"
#import "DTTabBarView.h"
#import "DTHorizontalScrollView.h"
#import "DTScrollTabView.h"

@protocol DTTabViewControllerDelegate <NSObject>

- (UIViewController *)currentController;

@end

@interface DTTabViewController : DTViewController
<
DTHorizontalScrollViewDataSource,
DTHorizontalScrollViewDelegate,
DTTabBarViewDelegate,
DTTabViewControllerDelegate
>
{
    @protected
    NSArray *_titleList, *_controllerList;
    
    DTHorizontalScrollView *_scrollView;
}

@property (nonatomic) id userInfo;
@property (nonatomic) NSInteger selectedIndex; //defalut is 0
@property (nonatomic) BOOL hiddenTab;
@property (nonatomic) BOOL unScroll;//禁止滚动
@property (nonatomic) CGFloat scrollGap;
@property (nonatomic) CGFloat selectedLineWidth;//default is 65, if 0 will equal btn width
@property (nonatomic, strong) NSArray *titleList, *controllerList;
@property (nonatomic) BOOL preLoad;//预加载
@property (nonatomic, strong) DTTabBarView *tabBar;
@property (nonatomic, assign) BOOL tabBarScroll;//tab 支持滚动

- (DTViewController *)currentController;
- (void)currentControllerScrollToTop:(BOOL)animation;

- (void)reloadData;
- (void)createTabView;

@end


@interface DTScrollControllerView : DTHorizontalScrollItemView

@property (nonatomic, weak) id controller;
@property (nonatomic) CGFloat gap;

@end
