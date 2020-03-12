//
//  JTDataManager.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/4.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTDataManager.h"

@implementation JTDataManager

SHARED_INSTANCE_M

+ (void)setupManager
{
    [[self sharedInstance] updateBaseConfig];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)updateBaseConfig
{
    [WCDataService async:[JTUserRequest getBaseConfig] finish:^(WCDataResult *result) {
        
    }];
}

@end
