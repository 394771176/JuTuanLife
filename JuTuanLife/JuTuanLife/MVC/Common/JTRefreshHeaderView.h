//
//  JTRefreshHeaderView.h
//  JuTuanLife
//
//  Created by cheng on 2020/4/11.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JTRefreshHeaderView : UIView<WCBaseUIRefreshHeaderViewProtocol>

@property (nonatomic, weak) id <WCBaseUIRefreshHeaderViewDelegate> delegate;
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
