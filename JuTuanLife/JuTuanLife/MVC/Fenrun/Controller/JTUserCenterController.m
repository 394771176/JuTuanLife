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
}

- (DTListDataModel *)createDataModel
{
    JTUserCenterModel *model = [[JTUserCenterModel alloc] initWithDelegate:self];
    return model;
}

@end
