//
//  JTNetManager.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/5.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WCNetKit/WCNetManager.h>
#import "JTService.h"
#import "JTUserRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface JTNetManager : WCNetManager <WCNetManagerProtocol>

+ (void)setupNetManager;

@property (nonatomic, strong) NSString *deviceModel;
@property (nonatomic, strong) NSString *osVersion;
@property (nonatomic, strong) NSString *openUDID;

@end

NS_ASSUME_NONNULL_END
