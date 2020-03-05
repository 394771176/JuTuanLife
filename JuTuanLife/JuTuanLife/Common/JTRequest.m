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

- (BPURLRequest *)makeRequest
{
    BPURLRequest *r = [super makeRequest];
    if (APP_DEBUG) {
        NSLog(@"\nURL(%@):%@\n%@", self.httpMethod, r.asiRequest.url.absoluteString, self.params);
    }
    return r;
}

- (WCDataResult *)getResultFromData:(id)data
{
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
