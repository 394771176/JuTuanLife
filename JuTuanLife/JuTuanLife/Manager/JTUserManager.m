//
//  JTUserManager.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/4.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTUserManager.h"

#define JTUserManager_ACTOKEN_KEY      @"JTUserManager_ACTOKEN.KEY"

@implementation JTUserManager

SHARED_INSTANCE_M

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.ac_token = [[BPAppPreference sharedInstance] stringForKey:JTUserManager_ACTOKEN_KEY];
    }
    return self;
}

- (BOOL)isLogined
{
    return self.ac_token.length > 0;
}

+ (void)loginAuth:(DTIntBlock)block
{
    if (block) {
        if ([[self sharedInstance] isLogined]) {
            block(JTLoginTypeLoginedBefore);
        } else {
            
        }
    }
}

@end
