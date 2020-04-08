//
//  RPResult.h
//  ALRealIdentity
//
//  Created by  Hank Zhang on 2019/10/14.
//  Copyright © 2019 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class RPResult;

/**
 NS_ENUM(NSInteger, RPState)
 实人认证结果状态
 */
typedef NS_ENUM(NSInteger, RPState) {
    
    /**
     未认证
     */
    RPStateNotVerify = -1,
    
    /**
     认证通过
     */
    RPStatePass = 1,
    
    /**
     认证失败
     */
    RPStateFail = 2,
};

/**
 `RPCompletion` 实人认证结果回调。
 
 @param result 实人认证结果。
 */
typedef void (^RPCompletion)(RPResult *result);

/**
 `RPResult` 实人认证结果
 */
NS_SWIFT_NAME(RPResult)
@interface RPResult : NSObject

/**
 实人认证结果状态
 */
@property (nonatomic, assign) RPState state;

/**
 实人认证结果错误代码，可选值
 */
@property (nonatomic, copy, nullable) NSString *errorCode;

/**
 实人认证结果信息，可选值
 */
@property (nonatomic, copy, nullable) NSString *message;

@end

NS_ASSUME_NONNULL_END
