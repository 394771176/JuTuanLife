//
//  DTHttpRefreshLoadMoreTableController.h
//  DrivingTest
//
//  Created by Kent on 14-7-4.
//  Copyright (c) 2014年 eclicks. All rights reserved.
//

#import "DTHttpRefreshTableController.h"
#import "DTLoadMoreCommonCell.h"

@interface DTHttpRefreshLoadMoreTableController : DTHttpRefreshTableController <DTLoadMoreRoundCellDelegate>

@property (nonatomic, strong, readonly) DTLoadMoreCommonCell *loadMoreCell;

- (DTLoadMoreCommonCell *)createLoadMoreCell;

@end
