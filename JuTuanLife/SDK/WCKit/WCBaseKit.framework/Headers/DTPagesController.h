//
//  DTPagesController.h
//  DrivingTest
//
//  Created by cheng on 16/10/28.
//  Copyright © 2016年 eclicks. All rights reserved.
//

#import "DTViewController.h"

@class DTPagesController, DTPagesView;

@protocol DTPagesControllerDataSource <NSObject>

@optional
- (NSInteger)numberOfPageViewCount;
- (DTPagesView *)createPageView;
- (void)updatePageView:(DTPagesView *)view withIndex:(NSInteger)index;

@end

@protocol DTPagesControllerDelegate <NSObject>

@optional
- (void)pagesControllerWillBeginMove;
- (void)pagesControllerDidMoveEnd;
- (void)pagesControllerDidTheLastOneMoveToNext;
- (void)pagesControllerDidTheFirstOneMoveToPrevious;

@end


@interface DTPagesController : DTViewController <DTPagesControllerDataSource, DTPagesControllerDelegate, UIGestureRecognizerDelegate> {
@protected
    UIView *_contentView;
    DTPagesView *_centerView, *_leftView, *_rightView;
    
    BOOL _moveNext;
}

@property (nonatomic, weak) id<DTPagesControllerDelegate> delegate;
@property (nonatomic, weak) id<DTPagesControllerDataSource> dataSource;

@property (nonatomic) NSInteger currentIndex;

@property (nonatomic) CGFloat moveDuration;//default is 0.25;
@property (nonatomic) CGFloat validMoveDistance;//default is 40

@property (nonatomic) BOOL pageLoop;//循环翻页，default is NO
@property (nonatomic) BOOL disablePan;//禁止滑动，default is NO

- (void)reloadData;
- (void)updateView;
- (void)updateContentView;//配置contentView frame 等

- (NSInteger)numberOfCount;
//- (void)checkUpdateView;

- (BOOL)canMove;

- (void)moveToPrevious;
- (void)moveToCurrent;
- (void)moveToNext;

- (void)moveToIndex:(NSInteger)index;

- (void)panAction:(UIPanGestureRecognizer *)gesture;

//加入手势 防止冲突
- (BOOL)addGestureAfterPan:(UIGestureRecognizer *)gesture;

@end

@interface DTPagesView : UIView

@property (nonatomic) NSInteger index;
@property (nonatomic, readonly) BOOL showing;

- (void)viewDidShow;
- (void)viewDidHidden;

- (void)prepareForReuse;

@end
