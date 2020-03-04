//
//  JTUserManager.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/4.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WCBaseUIKit.h"
#import "JTUser.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JTLoginType) {
    JTLoginTypeLoginedBefore = 0,//之前已经登录
    JTLoginTypeLoginNow,//现在登录
    JTLoginTypeRegister,//首次注册
};

@interface JTUserManager : NSObject

@property (nonatomic, strong) NSString *ac_token;
@property (nonatomic, strong) JTUser *user;

SHARED_INSTANCE_H

- (BOOL)isLogined;

+ (void)loginAuth:(DTIntBlock)block;

@end

NS_ASSUME_NONNULL_END
