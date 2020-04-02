//
//  RPSDKManager.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/29.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <Foundation/Foundation.h>

#if !TARGET_OS_SIMULATOR // 由于安全原因，实人认证不支持模拟器调试。
#import <RPSDK/RPSDK.h>
#endif



@interface RPSDKManager : NSObject

SHARED_INSTANCE_H

@property (nonatomic, strong) NSString *bizId;
@property (nonatomic, strong) NSString *verifyToken;

+ (void)setup;

+ (void)checkVerifyTokenWith:(DTSuccessBlock)block;

+ (void)getAndUploadVerifyResultWith:(DTCommonBlock)block;

//实人认证
+ (void)startAuthWithCompletion:(DTSuccessBlock)completion;
+ (void)startNativeWithCompletion:(DTSuccessBlock)completion;

@end
