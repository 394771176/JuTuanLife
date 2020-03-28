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

//用户信息
+ (JTRequest *)getUserInfo;
+ (JTRequest *)uploadUserAuthInfo:(JTUserCert *)cert;

//协议
+ (JTRequest *)get_unsigned_contracts;
+ (JTRequest *)sign_contracts:(NSArray *)array;

//用户押金
+ (JTRequest *)get_user_deposit_logs;

//首页产品业务列表
+ (JTRequest *)get_business_list;

//首页用户分润
+ (JTRequest *)get_all_commission_stats;
+ (JTRequest *)get_commission_stats:(NSInteger)period date:(NSString *)date pos:(NSString *)pos pageSize:(NSInteger)pageSize;

//用户分润，按业务统计
+ (JTRequest *)get_biz_contrib_commissions:(NSString *)userNo dateType:(NSInteger)period date:(NSString *)date;

//个人主页业绩列表
+ (JTRequest *)get_performance_stats:(NSInteger)period userNo:(NSString *)userNo;
//用户业绩明细
+ (JTRequest *)get_performance_details:(NSString *)businessCode dateType:(NSInteger)period pos:(NSString *)pos pageSize:(NSInteger)pageSize;

//师徒列表
+ (JTRequest *)getShipList:(NSString *)pos pageSize:(NSInteger)pageSize;
+ (JTRequest *)getShipList:(NSString *)pos pageSize:(NSInteger)pageSize searchText:(NSString *)searchText;

//MARK: - Message
+ (JTRequest *)unread_msg_num;
+ (JTRequest *)user_msg_list:(NSString *)pos pageSize:(NSInteger)pageSize;

@end
