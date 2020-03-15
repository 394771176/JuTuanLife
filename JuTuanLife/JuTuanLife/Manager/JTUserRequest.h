//
//  JTUserRequest.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/5.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTRequest.h"
#import "JTUserManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface JTUserRequest : JTRequest

//MARK: - base

+ (JTRequest *)getBaseConfig;

//MARK: - login

+ (JTRequest *)loginWithMobile:(NSString *)mobile password:(NSString *)password;
+ (JTRequest *)getSmsCodeWithMobile:(NSString *)mobile;
+ (JTRequest *)resetPasswordWithMobile:(NSString *)mobile password:(NSString *)password smsCode:(NSString *)smsCode;

+ (JTRequest *)getUserInfo;
+ (JTRequest *)uploadUserAuthInfo:(JTUserCert *)cert;

+ (JTRequest *)get_unsigned_contracts;
+ (JTRequest *)sign_contracts:(NSArray *)array;

+ (JTRequest *)getShipList;

+ (JTRequest *)getShareInfo;

@end

NS_ASSUME_NONNULL_END
