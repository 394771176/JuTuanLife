//
//  JTShipHomeController.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/8.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JTShipHomeController : DTHttpRefreshLoadMoreTableController

@property (nonatomic, strong) NSString *searchText;
@property (nonatomic, assign) BOOL isSearch;

@end
