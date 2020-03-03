//
//  DTHttpRefreshInsetTabController.h
//  DrivingTest
//
//  Created by cheng on 2020/2/4.
//  Copyright © 2020 eclicks. All rights reserved.
//

#import "DTHttpRefreshTableController.h"
#import "DTScrollTabView.h"
#import "DTControllerListView.h"

@interface DTHttpRefreshInsetTabController : DTHttpRefreshTableController <DTTabBarViewDelegate, DTControllerListViewDelegate>

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *controllers;

@property (nonatomic, assign) NSInteger selectedIndex;

//if controllers 不传时，可以通过下面方法返回；
- (UIViewController *)createControllerForIndex:(NSInteger)index;

@end
