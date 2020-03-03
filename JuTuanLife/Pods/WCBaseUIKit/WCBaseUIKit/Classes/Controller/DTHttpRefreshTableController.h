//
//  DTHttpRefreshTableController.h
//  DrivingTest
//
//  Created by Kent on 14-7-4.
//  Copyright (c) 2014年 eclicks. All rights reserved.
//

#import "DTHttpTableController.h"
#import "DTPullRefreshHeadView.h"

@interface DTHttpRefreshTableController : DTHttpTableController <DTPullRefreshHeadViewDelegate> {
    @protected
    DTPushRefreshHeadView *_refreshHeadView;
}

- (void)didPullRefresh;

@end
