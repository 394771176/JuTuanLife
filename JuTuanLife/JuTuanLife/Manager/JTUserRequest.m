//
//  JTUserRequest.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/5.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTUserRequest.h"

@implementation JTUserRequest

+ (id)requestWithApi:(NSString *)api params:(NSDictionary *)params httpMethod:(NSString *)httpMethod
{
    return [self requestWithApi:api params:params httpMethod:httpMethod serverType:JTServerType1];
}

+ (JTRequest *)getBaseConfig
{
    NSArray *array = @[@"biz_conf_image", @"ios_jutuan_version", @"app_jutuan_conf"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:array forKey:@"classcode"];
    return [self requestWithApi:@"basic/get_app_config" params:params];
}

+ (JTRequest *)loginWithMobile:(NSString *)mobile password:(NSString *)password
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:mobile forKey:@"mobile"];
    [params safeSetObject:password forKey:@"password"];
    return [self requestWithApi:@"sale/user/login" params:params httpMethod:WCHTTPMethodPOST];
}

+ (JTRequest *)getSmsCodeWithMobile:(NSString *)mobile
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:mobile forKey:@"mobile"];
    return [self requestWithApi:@"sale/user/get_reset_pw_sms_code" params:params httpMethod:WCHTTPMethodPOST];
}

+ (JTRequest *)resetPasswordWithMobile:(NSString *)mobile password:(NSString *)password smsCode:(NSString *)smsCode
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:mobile forKey:@"mobile"];
    [params safeSetObject:password forKey:@"password"];
    [params safeSetObject:smsCode forKey:@"smsCode"];
    return [self requestWithApi:@"sale/user/reset_passwd" params:params httpMethod:WCHTTPMethodPOST];
}

+ (JTRequest *)refreshUserToken:(NSString *)rfToken
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:rfToken forKey:@"rf_token"];
    return [self requestWithApi:@"token/refresh_token" params:params httpMethod:WCHTTPMethodPOST];
}

+ (JTRequest *)getUserInfo
{
    return [self requestWithApi:@"sale/user/get_user_info" params:nil];
}

+ (JTRequest *)update_user_infoAvatar:(NSString *)avatar address:(NSString *)address
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:avatar forKey:@"avatar"];
    [params safeSetObject:address forKey:@"shippingAddress"];
    return [self requestWithApi:@"sale/user/update_user_info" params:params];
}

+ (JTRequest *)get_ali_verify_token
{
    return [self requestWithApi:@"user/rpcert/get_ali_verify_token" params:nil httpMethod:WCHTTPMethodPOST];
}

+ (JTRequest *)get_ali_verify_resultWithBizId:(NSString *)bizId
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:bizId forKey:@"bizId"];
    return [self requestWithApi:@"user/rpcert/get_ali_verify_result" params:params httpMethod:WCHTTPMethodPOST];
}

+ (JTRequest *)upload_auth_infoWithCert:(JTUserCert *)cert
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addEntriesFromDictionary:[cert dictItem]];
    [params removeObjectForKey:@"certAuth"];
    return [self requestWithApi:@"sale/user/upload_auth_info" params:params httpMethod:WCHTTPMethodPOST];
}

+ (JTRequest *)get_bank_cards
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    return [self requestWithApi:@"user/bankcard/get_bank_cards" params:params];
}

+ (JTRequest *)addOrUpdate_bank_cardWithBank:(JTUserBank *)bank
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:bank.itemId forKey:@"id"];
    [params safeSetObject:bank.cardNo forKey:@"cardNo"];
    [params safeSetObject:bank.bankName forKey:@"bankName"];
    [params safeSetObject:bank.bankBranch forKey:@"bankBranch"];
    [params safeSetObject:bank.holder forKey:@"holder"];
    if (bank.itemId) {
        return [self requestWithApi:@"user/bankcard/update_bank_card" params:params];
    } else {
        return [self requestWithApi:@"user/bankcard/add_bank_card" params:params];
    }
}

+ (JTRequest *)get_unsigned_contracts
{
    return [self requestWithApi:@"sale/contract/get_unsigned_contracts" params:nil];
}

+ (JTRequest *)get_signed_contracts
{
    return [self requestWithApi:@"sale/contract/get_signed_contracts" params:nil];
}

+ (JTRequest *)sign_contractsWithList:(NSArray *)array
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableArray *ids = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(JTProtorolItem *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [ids safeAddObject:obj.itemId];
    }];
//    if (ids.count) {
//        [params safeSetObject:[ids componentsJoinedByString:@","] forKey:@"contractIds"];
//    }
    [params safeSetObject:ids forKey:@"contractId"];
    return [self requestWithApi:@"sale/contract/sign_contracts" params:params httpMethod:WCHTTPMethodPOST];
}

+ (JTRequest *)get_user_deposit_logsWithPos:(NSString *)pos pageSize:(NSInteger)pageSize
{
    NSMutableDictionary *params = [self paramsWithPos:pos pageSize:pageSize];
    return [self requestWithApi:@"/sale/business/get_user_deposit_logs" params:params];
}

+ (JTRequest *)get_business_list
{
    return [self requestWithApi:@"sale/business/get_business_list" params:nil];
}

+ (JTRequest *)get_all_commission_stats
{
    return [self requestWithApi:@"sale/business/get_all_commission_stats" params:nil];
}

+ (JTRequest *)get_commission_statsWithPeriod:(NSInteger)period date:(NSString *)date pos:(NSString *)pos pageSize:(NSInteger)pageSize
{
    NSMutableDictionary *params = [self paramsWithPos:pos pageSize:pageSize];
    [params safeSetObject:STRING(period) forKey:@"dateType"];
    [params safeSetObject:date forKey:@"date"];
    [params safeSetObject:@"true" forKey:@"includePersonal"];
    return [self requestWithApi:@"sale/business/get_commission_stats" params:params];
}

+ (JTRequest *)get_biz_contrib_commissionsWithUserNo:(NSString *)userNo dateType:(NSInteger)period date:(NSString *)date
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:userNo forKey:@"byUserNo"];
    [params safeSetObject:STRING(period) forKey:@"dateType"];
    [params safeSetObject:date forKey:@"date"];
    return [self requestWithApi:@"sale/business/get_biz_contrib_commissions" params:params];
}

+ (JTRequest *)get_performance_statsWithPeriod:(NSInteger)period userNo:(NSString *)userNo
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:STRING(period) forKey:@"dateType"];
    [params safeSetObject:userNo forKey:@"forUserNo"];
    return [self requestWithApi:@"sale/business/get_performance_stats" params:params];
}

+ (JTRequest *)get_performance_detailsWithCode:(NSString *)businessCode dateType:(NSInteger)period pos:(NSString *)pos pageSize:(NSInteger)pageSize
{
    NSMutableDictionary *params = [self paramsWithPos:pos pageSize:pageSize];
    [params safeSetObject:businessCode forKey:@"businessCode"];
    [params safeSetObject:STRING(period) forKey:@"dateType"];
    return [self requestWithApi:@"sale/business/get_performance_details" params:params];
}

+ (JTRequest *)getShipListWithPos:(NSString *)pos pageSize:(NSInteger)pageSize searchText:(NSString *)searchText
{
    NSMutableDictionary *params = [self paramsWithPos:pos pageSize:pageSize];
    [params safeSetObject:searchText forKey:@"searchText"];
    return [self requestWithApi:@"sale/user/master_and_apprentices" params:params];
}

+ (JTRequest *)getShareInfo
{
    return [self requestWithApi:@"sale/user/invite_share_info" params:nil];
}

+ (JTRequest *)unread_msg_num
{
    return [self requestWithApi:@"user/message/unread_msg_num" params:@{@"userType" : @"1"}];
}
+ (JTRequest *)user_msg_listWithPos:(NSString *)pos pageSize:(NSInteger)pageSize
{
    NSMutableDictionary *params = [self paramsWithPos:pos pageSize:pageSize];
    [params safeSetObject:@"1" forKey:@"userType"];
    return [self requestWithApi:@"user/message/user_msg_list" params:params];
}

@end
