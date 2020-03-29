//
//  RPSDKManager.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/29.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "RPSDKManager.h"

@implementation RPSDKManager

SHARED_INSTANCE_M

+ (void)setup
{
    
}

+ (void)checkVerifyTokenWith:(DTSuccessBlock)block
{
    if ([[self sharedInstance] bizId].length && [[self sharedInstance] verifyToken].length) {
        if (block) {
            block(YES, nil);
        }
    } else {
        [JTService asyncBlock:^WCDataRequest *{
            return [JTUserRequest get_ali_verify_token];
        } finish:^(WCDataResult *result) {
            BOOL success = NO;
            NSString *error = nil;
            if (result.success && [NSDictionary validDict:result.data]) {
                NSString *bizId = [result.data objectForKey:@"bizId"];
                NSString *token = [result.data objectForKey:@"verifyToken"];
                if (bizId.length && token.length) {
                    success = YES;
                    [[self sharedInstance] setBizId:bizId];
                    [[self sharedInstance] setVerifyToken:token];
                } else {
                    error = @"服务器数据异常";
                }
            } else {
                error = result.msg?:@"服务器异常";
            }
            if (block) {
                block(success, error);
            }
        }];
    }
}

+ (void)getVerifyResultWith:(DTCommonBlock)block
{
    [JTService asyncBlock:^WCDataRequest *{
        NSString *bizId = [[self sharedInstance] bizId];
        return [JTUserRequest get_ali_verify_result:bizId];
    } finish:^(WCDataResult *result) {
        if (block) {
            block(result);
        }
    }];
}

+ (void)uploadVerifyResultWith:(DTCommonBlock)block
{
    [JTService asyncBlock:^WCDataRequest *{
        NSString *bizId = [[self sharedInstance] bizId];
        return [JTUserRequest get_ali_verify_result:bizId];
    } finish:^(WCDataResult *result) {
        if (block) {
            block(result);
        }
    }];
}

+ (void)getAndUploadVerifyResultWith:(DTCommonBlock)block
{
    [JTService addBlockOnGlobalThread:^{
        NSString *bizId = [[self sharedInstance] bizId];
        WCDataResult *result = nil;
        WCDataResult *authResult = [JTService sync:[JTUserRequest get_ali_verify_result:bizId]];
        result = authResult;
        if (result.success) {
            JTUserCert *cert = [JTUserCert itemFromVerifyData:result.data];
            if (cert) {
                WCDataResult *uploadResult = [JTService sync:[JTUserRequest upload_auth_info:cert]];
                result = uploadResult;
            }
        }
        if (block) {
            [JTService addBlockOnMainThread:^{
                block(result);
            }];
        }
    }];
}

+ (void)startAuthWithCompletion:(DTSuccessBlock)completion
{
#if !TARGET_OS_SIMULATOR
    [self checkVerifyTokenWith:^(BOOL success, NSString *error) {
        if (success) {
            NSString *token = [[self sharedInstance] verifyToken];
            [RPSDK startWithVerifyToken:token viewController:[WCControllerUtil topContainerController] completion:^(RPResult * _Nonnull result) {
                // 建议接入方调用实人认证服务端接口DescribeVerifyResult，
                // 来获取最终的认证状态，并以此为准进行业务上的判断和处理。
                NSLog(@"实人认证结果：%@", result);
                switch (result.state) {
                    case RPStatePass:
                        // 认证通过。
                        if(completion) {
                            completion(YES, result);
                        }
//                        [self startNativeWithCompletion:completion];
                        break;
                    case RPStateFail:
                        // 认证不通过。
                        if(completion) {
                            completion(NO, @"认证不通过");
                        }
                        break;
                    case RPStateNotVerify:
                        // 未认证。
                        // 通常是用户主动退出或者姓名身份证号实名校验不匹配等原因导致。
                        // 具体原因可通过 result.errorCode 和 result.message 来区分（详见错误码说明）。
                        if(completion) {
                            completion(NO, @"未认证");
                        }
                        break;
                }
            }];
        } else {
            [DTPubUtil showHUDErrorHintInWindow:error];
        }
    }];
    /*
     
     */
#endif
}

+ (void)startNativeWithCompletion:(DTSuccessBlock)completion
{
    [self checkVerifyTokenWith:^(BOOL success, id userInfo) {
        if (success) {
            NSString *token = [[self sharedInstance] verifyToken];
            [RPSDK startByNativeWithVerifyToken:token
                                 viewController:[WCControllerUtil topContainerController]
                                     completion:^(RPResult * _Nonnull result) {
                                         // 建议接入方调用实人认证服务端接口DescribeVerifyResult，
                                         // 来获取最终的认证状态，并以此为准进行业务上的判断和处理。
                                         NSLog(@"实人认证结果：%@", result);
                                         switch (result.state) {
                                             case RPStatePass:
                                                 // 认证通过。
                                                 if(completion) {
                                                     completion(YES, result);
                                                 }
                                                 break;
                                             case RPStateFail:
                                                 // 认证不通过。
                                                 if(completion) {
                                                     completion(NO, @"认证不通过");
                                                 }
                                                 break;
                                             case RPStateNotVerify:
                                                 // 未认证。
                                                 // 通常是用户主动退出或者姓名身份证号实名校验不匹配等原因导致。
                                                 // 具体原因可通过 result.errorCode 和 result.message 来区分（详见错误码说明）。
                                                 if(completion) {
                                                     completion(NO, @"未认证");
                                                 }
                                                 break;
                                         }
                                     }];
        }
    }];
}

@end
