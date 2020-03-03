//
//  DTHorizontalScrollViewCell.h
//  DrivingTest
//
//  Created by cheng on 16/12/15.
//  Copyright © 2016年 eclicks. All rights reserved.
//

#import "DTTableCustomCell.h"
#import "DTControllerListView.h"
#import "DTHorizontalScrollView.h"

@interface DTScrollListViewCell : DTTableCustomCell

@property (nonatomic, strong) DTControllerListView *scrollView;
@property (nonatomic, weak) id <DTControllerListViewDelegate> delegate;

@end

@interface DTHorizontalScrollViewCell : DTTableCustomCell

@property (nonatomic, strong) DTHorizontalScrollView *scrollView;
@property (nonatomic, weak) id<DTHorizontalScrollViewDelegate, DTHorizontalScrollViewDataSource> delegate;

@end
