//
//  JTRequest.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/5.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTRequest.h"

@implementation JTRequest

- (void)setServerType:(JTServerType)serverType
{
    _serverType = serverType;
    switch (serverType) {
        case JTServerType1:
        {
            self.serverUrl = APP_JT_SERVER;
            self.signKey = APP_JT_SIGN;
        }
            break;
        case JTServerType2:
        {
            
        }
            break;
        case JTServerType3:
        {
            
        }
            break;
        default:
            break;
    }
}

- (NSString *)urlCodeValueForKey:(NSString *)key params:(NSDictionary *)params
{
    id obj = [params valueForKey:key];
    if (obj) {
        if (([obj isKindOfClass:[UIImage class]])
            ||([obj isKindOfClass:[NSData class]])) {
            return nil;
        } else if ([obj isKindOfClass:[NSNumber class]]) {
            obj = [(NSNumber *)obj stringValue];
        }
        
        NSString *code = [NSString stringWithFormat:@"%@=%@", key, [obj urlEncoded]];
        return code;
    } else {
        return nil;
    }
}

- (NSString *)requestUrl
{
    NSString *url = [super requestUrl];
    NSMutableArray *pairs = [NSMutableArray array];
    if (self.needSystemParams) {
        NSDictionary *system = [WCNetManager systemParams];
        [pairs safeAddObject:[self urlCodeValueForKey:@"_platform" params:system]];
        [pairs safeAddObject:[self urlCodeValueForKey:@"_os" params:system]];
        [pairs safeAddObject:[self urlCodeValueForKey:@"_sysVersion" params:system]];
        [pairs safeAddObject:[self urlCodeValueForKey:@"_model" params:system]];
        [pairs safeAddObject:[self urlCodeValueForKey:@"_appVersion" params:system]];
        [pairs safeAddObject:[self urlCodeValueForKey:@"_openUDID" params:system]];
        [pairs safeAddObject:[self urlCodeValueForKey:@"_appChannel" params:system]];
        [pairs safeAddObject:[self urlCodeValueForKey:@"_caller" params:system]];
    }
    
    [pairs safeAddObject:[NSString stringWithFormat:@"_t=%.0f", WCTimeIntervalWithSecondsSince1970()]];
    
    //有就带上
    if ([JTUserManager sharedInstance].ac_token) {
        [pairs safeAddObject:[NSString stringWithFormat:@"_ac_token=%@", FFURLEncode([JTUserManager sharedInstance].ac_token)]];
    }
    
    NSString* queryPrefix = ([url rangeOfString:@"?"].length ? @"&" : @"?");
    
    return [NSString stringWithFormat:@"%@%@%@", url, queryPrefix, [pairs componentsJoinedByString:@"&"]];
}

- (NSMutableDictionary *)requestParams
{
    if ([self.params isKindOfClass:NSMutableDictionary.class]) {
        return (id)self.params;
    } else {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        if (self.params.count) {
            [dict addEntriesFromDictionary:self.params];
        }
        return dict;
    }
}

- (BPURLRequest *)makeRequest
{
    BPURLRequest *r = [super makeRequest];
    if (APP_DEBUG) {
        NSLog(@"\nURL(%@):\n%@\n%@", self.httpMethod, r.asiRequest.url.absoluteString, self.params);
    }
    return r;
}

- (WCDataResult *)parseData:(id)data;
{
    if (APP_DEBUG) {
        NSLog(@"\nData:\b%@", data);
    }
    return [JTDataResult itemFromDict:data];
}

+ (id)requestWithApi:(NSString *)api params:(NSDictionary *)params
{
    return [self requestWithApi:api params:params httpMethod:WCHTTPMethodGET];
}

+ (id)requestWithApi:(NSString *)api params:(NSDictionary *)params httpMethod:(NSString *)httpMethod
{
    return [self requestWithApi:api params:params httpMethod:httpMethod serverType:JTServerType1];
}

+ (id)requestWithApi:(NSString *)api params:(NSDictionary *)params httpMethod:(NSString *)httpMethod serverType:(JTServerType)serverType
{
    JTRequest *request = [self requestWithUrl:nil api:api params:params httpMethod:httpMethod];
    request.serverType = serverType;
    return request;
}

@end
