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
    return [self requestWithApi:@"basic/get_app_config" params:nil];
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

+ (JTRequest *)getUserInfo
{
    return [self requestWithApi:@"sale/user/get_user_info" params:nil];
}

+ (JTRequest *)uploadUserAuthInfo:(JTUserCert *)cert
{
    /*certType *
     integer
     (query)
     证件类型, 1: 身份证
     
     certNo *
     string
     (query)
     证件号
     
     certAddress
     string
     (query)
     证件地址
     
     certExpire
     string
     (query)
     证件有效期
     
     certIssuer
     string
     (query)
     证件签发机构
     
     certFront *
     string
     (query)
     证件正面图片
     
     certBack *
     string
     (query)
     证件反面图片
     
     faceImg *
     string
     (query)
     人脸图片
     
     name *
     string
     (query)
     姓名
     
     birthday
     string
     (query)
     生日，格式: 1983-03-02
     
     nation
     string
     (query)
     民族
     
     gender
     integer
     (query)
     */
    return nil;
}

+ (JTRequest *)get_unsigned_contracts
{
    return [self requestWithApi:@"sale/contract/get_unsigned_contracts" params:nil];
}

+ (JTRequest *)sign_contracts:(NSArray *)array
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableArray *ids = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(JTProtorolItem *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [params safeSetObject:obj.itemId forKey:[NSString stringWithFormat:@"contractId[%zd]", idx]];
        [ids safeAddObject:obj.itemId];
    }];
    if (ids.count) {
        [params safeSetObject:[ids componentsJoinedByString:@","] forKey:@"contractIds"];
    }
    return [self requestWithApi:@"sale/contract/sign_contracts" params:params httpMethod:WCHTTPMethodPOST];
}

+ (JTRequest *)getShipList:(NSString *)pos pageSize:(NSInteger)pageSize
{
    NSMutableDictionary *params = [self paramsWithPos:pos pageSize:pageSize];
    return [self requestWithApi:@"sale/user/master_and_apprentices" params:params];
}

+ (JTRequest *)getShareInfo
{
    return [self requestWithApi:@"sale/user/invite_share_info" params:nil];
}

@end
