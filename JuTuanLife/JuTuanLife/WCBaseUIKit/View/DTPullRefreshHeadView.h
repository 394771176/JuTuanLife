//
//  DTPullRefreshHeadView.h
//  DrivingTest
//
//  Created by Kent on 14-7-4.
//  Copyright (c) 2014年 eclicks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCUICommon.h"

typedef enum {
    DTPullRefreshPulling = 0,
    DTPullRefreshNormal,
    DTPullRefreshLoading,
} DTPullRefreshState;

typedef void (^DTPullRefreshFinishBlock)(void);

@class DTPullRefreshHeadView, DTPushRefreshHeadView;

@protocol DTPullRefreshHeadViewDelegate <NSObject>

- (void)pullRefreshTableHeaderDidTriggerRefresh:(UIView *)view;
- (BOOL)pullRefreshTableHeaderDataSourceIsLoading:(UIView *)view;

@end

@interface DTPullRefreshHeadView : UIView

@property (nonatomic, weak) id <DTPullRefreshHeadViewDelegate> delegate;
@property (nonatomic) UIEdgeInsets defaultContentInset;
@property (nonatomic) BOOL needDelay;//是否需要延迟， 目前gif动画 default is YES
@property (nonatomic, copy) DTPullRefreshFinishBlock finishBlock;

- (void)viewWillAppear;

- (void)setState:(DTPullRefreshState)aState;

- (void)pullRefreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)pullRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)pullRefreshScrollViewDataSourceDidFinishLoading:(UIScrollView *)scrollView;
- (void)didPullRefreshScrollView:(UIScrollView *)scrollView;

@end

@interface DTPullRefreshImage : NSObject

@property (nonatomic, strong) FLAnimatedImage *aniImage;

+ (DTPullRefreshImage *)shareInstace;
- (void)setVelocity:(CGFloat)velocity;//动画速度倍率， 原始速度就是一倍，

@end


@interface FLAnimatedImageView (DTPullRefresh)

- (void)setIndex:(NSInteger)index;

@end

@interface DTPushRefreshHeadView : UIView

@property (nonatomic, weak) id <DTPullRefreshHeadViewDelegate> delegate;
@property (nonatomic) UIEdgeInsets defaultContentInset;
@property (nonatomic) BOOL needDelay;//是否需要延迟， 目前gif动画 default is YES
@property (nonatomic, strong) DTPullRefreshFinishBlock finishBlock;

@property (nonatomic, assign) CGFloat minOffsetY;

- (void)viewWillAppear;

- (void)setState:(DTPullRefreshState)aState;

- (void)pullRefreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)pullRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)pullRefreshScrollViewDataSourceDidFinishLoading:(UIScrollView *)scrollView;
- (void)didPullRefreshScrollView:(UIScrollView *)scrollView;

@end
