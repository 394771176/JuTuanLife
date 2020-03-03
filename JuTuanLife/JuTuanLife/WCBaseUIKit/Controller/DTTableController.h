//
//  DTTableController.h
//  DrivingTest
//
//  Created by Kent on 14-2-25.
//  Copyright (c) 2014年 eclicks. All rights reserved.
//

#import "DTViewController.h"
#import "DTNoDataView.h"

@class DTTableController;

@protocol DTTableControllerScrollDelegate <NSObject>

@optional

- (void)tableController:(DTTableController *)controller scrollViewDidScroll:(UIScrollView *)scrollView;

@end

@interface DTTableController : DTViewController <UITableViewDelegate, UITableViewDataSource, DTNoDataViewDelegate> {
@protected
    DTNoDataView *_noDataView;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString *noDataMsg;
@property (nonatomic, assign) CGFloat noDataImgTopOff;//gif图片 top 的偏移量
@property (nonatomic, assign) CGFloat noDataLabTopOff;//label top 的偏移量
@property (nonatomic, assign) CGFloat noDataBtnTopOff;//btn top 的偏移量
@property (nonatomic, strong) UIImage *noDataImg;
@property (nonatomic, strong) NSString *noDataBtnTitle;
@property (nonatomic, strong) NSString *failBtnTitle;

@property (nonatomic, assign) CGFloat noDataViewTopOff;//noDataView top 的偏移量
@property (nonatomic, strong) id userInfo;
@property (nonatomic, assign) UITableViewStyle tableViewStyle;

@property (nonatomic, weak) id<DTTableControllerScrollDelegate> tableScrollDelegate;

//当有superController时，父类进行刷新
@property (nonatomic, assign) BOOL needSuperReload;

- (void)reloadTableView;

- (instancetype)initWithTableStyle:(UITableViewStyle)tableViewStyle;

// 无数据情况
- (void)showNoDataViewWithType:(int)type msg:(NSString *)msg gifImageName:(NSString *)gifName btnTitle:(NSString *)btnTitle;
- (void)showNoDataViewWithType:(int)type msg:(NSString *)msg image:(UIImage *)image;
- (void)showNoDataViewWithTop:(float)top msg:(NSString *)msg image:(UIImage *)image;
- (void)showNoDataView;
- (void)hideNoDataView;

- (void)setTableViewScrollToTop:(BOOL)top;
- (void)scrollToTop:(BOOL)animated;

- (BOOL)isViewRealAppear;
- (void)didViewRealAppear;

- (CGFloat)tableHeightForIndexPath:(NSIndexPath *)indexPath;

@end
