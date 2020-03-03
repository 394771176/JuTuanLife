//
//  DTLoadMoreRoundCell.h
//  DrivingTest
//
//  Created by Kent on 14-3-4.
//  Copyright (c) 2014年 eclicks. All rights reserved.
//

#import "DTTableCustomCell.h"

typedef enum {
    DTTableLoadMoreNormal,
    DTTableLoadMoreLoading,
    DTTableLoadMoreFailed
} DTTableLoadMoreState;

@class DTLoadMoreCommonCell;

@protocol DTLoadMoreRoundCellDelegate <NSObject>

- (void)loadMoreCellDidStartLoad:(DTLoadMoreCommonCell *)cell;

@end

@interface DTLoadMoreCommonCell : DTTableCustomCell

@property (nonatomic, weak) id<DTLoadMoreRoundCellDelegate> delegate;
@property (nonatomic) DTTableLoadMoreState state;

- (void)startIndicator;
- (void)stopIndicator;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)startLoad;

- (UILabel *)loadingLabel;

@end
