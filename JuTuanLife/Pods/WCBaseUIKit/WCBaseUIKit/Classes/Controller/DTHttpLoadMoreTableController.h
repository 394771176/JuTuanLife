//
//  DTLoadMoreTableController.h
//  DrivingTest
//
//  Created by Kent on 14-3-4.
//  Copyright (c) 2014年 eclicks. All rights reserved.
//

#import "DTHttpTableController.h"
#import "DTLoadMoreCommonCell.h"

@interface DTHttpLoadMoreTableController : DTHttpTableController <DTLoadMoreRoundCellDelegate>

@property (nonatomic, strong, readonly) DTLoadMoreCommonCell *loadMoreCell;

/**
 * return DTLoadMoreCommonCell for default, cell height 52
 * 子类可以重写
 */
- (DTLoadMoreCommonCell *)createLoadMoreCell;

@end
