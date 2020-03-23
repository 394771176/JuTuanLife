//
//  JTUserCenterController.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/22.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTUserCenterController.h"
#import "JTUserCenterModel.h"

@interface JTUserCenterController ()
{
    
}

@end

@implementation JTUserCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人主页";
    
    [self reloadData];
    
    if (APP_DEBUG) {
        self.noDataMsg = @"敬请期待，马上就做";
        [self showNoDataView];
    }
}

- (DTListDataModel *)createDataModel
{
    JTUserCenterModel *model = [[JTUserCenterModel alloc] initWithDelegate:self];
    [model loadCache];
    return model;
}

- (WCTableSourceData *)setupTableSourceData
{
    WCTableSourceData *source = [WCTableSourceData new];
    
    
    
    return source;
}

@end
