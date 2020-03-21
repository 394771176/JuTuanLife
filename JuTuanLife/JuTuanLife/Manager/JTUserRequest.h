//
//  JTUserRequest.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/5.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTRequest.h"
#import "JTUserManager.h"

@interface JTUserRequest : JTRequest

//MARK: - base

+ (JTRequest *)getBaseConfig;
+ (JTRequest *)getShareInfo;


//MARK: - login

+ (JTRequest *)loginWithMobile:(NSString *)mobile password:(NSString *)password;
+ (JTRequest *)getSmsCodeWithMobile:(NSString *)mobile;
+ (JTRequest *)resetPasswordWithMobile:(NSString *)mobile password:(NSString *)password smsCode:(NSString *)smsCode;

+ (JTRequest *)getUserInfo;
+ (JTRequest *)uploadUserAuthInfo:(JTUserCert *)cert;

+ (JTRequest *)get_unsigned_contracts;
+ (JTRequest *)sign_contracts:(NSArray *)array;

+ (JTRequest *)get_business_list;
+ (JTRequest *)get_all_commission_stats;
+ (JTRequest *)get_commission_stats:(NSInteger)period date:(NSString *)date pos:(NSString *)pos pageSize:(NSInteger)pageSize;

+ (JTRequest *)getShipList:(NSString *)pos pageSize:(NSInteger)pageSize;

//MARK: - Message
+ (JTRequest *)unread_msg_num;
+ (JTRequest *)user_msg_list:(NSString *)pos pageSize:(NSInteger)pageSize;

@end
