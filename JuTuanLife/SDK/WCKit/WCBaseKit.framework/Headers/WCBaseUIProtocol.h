//
//  WCBaseUIProtocol.h
//  WCBaseKit
//
//  Created by cheng on 2020/4/11.
//

#ifndef WCBaseUIProtocol_h
#define WCBaseUIProtocol_h

//@class WCBaseUIProtocol;

typedef enum {
    DTPullRefreshPulling = 0,
    DTPullRefreshNormal,
    DTPullRefreshLoading,
} DTPullRefreshState;

typedef void (^DTPullRefreshFinishBlock)(void);

@protocol WCBaseUIRefreshHeaderViewDelegate,WCBaseUIRefreshHeaderViewProtocol;

@protocol WCBaseUIRefreshHeaderViewDelegate <NSObject>

- (void)pullRefreshTableHeaderDidTriggerRefresh:(id<WCBaseUIRefreshHeaderViewProtocol>)view;
- (BOOL)pullRefreshTableHeaderDataSourceIsLoading:(id<WCBaseUIRefreshHeaderViewProtocol>)view;

@end


@protocol WCBaseUIRefreshHeaderViewProtocol <NSObject>

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

@protocol WCBaseUILoadingIndicatorProtocol <NSObject>

- (void)start;

- (void)stop;

@end

#endif /* WCBaseUIProtocol_h */
