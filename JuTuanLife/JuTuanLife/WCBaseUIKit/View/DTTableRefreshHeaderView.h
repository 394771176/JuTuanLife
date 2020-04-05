//
//  DTTableRefreshHeaderView.h
//  JuTuanLife
//
//  Created by cheng on 2020/4/5.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTPullRefreshHeadView.h"

@interface DTTableRefreshHeaderView : UIView

@property (nonatomic, weak) id <DTPullRefreshHeadViewDelegate> delegate;
@property (nonatomic) UIEdgeInsets defaultContentInset;
@property (nonatomic, strong) DTPullRefreshFinishBlock finishBlock;

@property (nonatomic) BOOL needDelay;//是否需要延迟，保证动画达到一定时间

@property (nonatomic, assign) CGFloat minOffsetY;

- (void)setState:(DTPullRefreshState)aState;

- (void)pullRefreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)pullRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)pullRefreshScrollViewDataSourceDidFinishLoading:(UIScrollView *)scrollView;
- (void)didPullRefreshScrollView:(UIScrollView *)scrollView;

@end

@interface LQHeaderView : UIView

@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView * rightView;

@property (nonatomic, assign) CGFloat ballSize;//default is 10
@property (nonatomic, assign) CGFloat ballDistance;//default is 24

@property (nonatomic, assign) CGFloat progress;

- (void)startAnimation;
- (void)stopAnimation;

@end
