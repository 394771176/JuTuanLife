//
//  DTURLWhiteList.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/26.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "DTURLWhiteList.h"

@implementation DTURLWhiteList

+ (BOOL)isWhiteUrl:(NSURL *)url matchWhiteDomain:(NSString *__autoreleasing *)whiteDomain
{
    if (!url) {
        return NO;
    }
    
    const NSArray *whiteUrlStrList = @[@"jutuanlife.com", @"jutuibang.cn", @"jutuib.cn", @"192.168.18.157"];
    
    NSArray *tags = [url.host componentsSeparatedByString:@"."];
    if (tags.count<2) {
        return NO;
    }
    BOOL result = NO;
    NSString *resultDomain = nil;
    
    NSMutableString *host = [NSMutableString stringWithString:[tags lastObject]];
    for (NSInteger i=tags.count-2; i>=0; i--) {
        [host insertString:[NSString stringWithFormat:@"%@.", tags[i]] atIndex:0];
        if ([whiteUrlStrList containsObject:host]) {
            resultDomain = [NSString stringWithString:host];
            result = YES;
            break;
        }
    }
    
    if (whiteDomain) {
        *whiteDomain = resultDomain;
    }
    
    return result;
}

+ (NSHTTPCookie *)createCookieWithKey:(NSString *)key value:(NSString *)value domain:(NSString *)domain
{
    if (!key||!value||!domain) {
        return nil;
    }
    NSMutableDictionary *cookie = [NSMutableDictionary dictionary];
    [cookie safeSetObject:key forKey:NSHTTPCookieName];
    [cookie safeSetObject:value forKey:NSHTTPCookieValue];
    [cookie safeSetObject:domain forKey:NSHTTPCookieDomain];
    [cookie setObject:@"/" forKey:NSHTTPCookiePath];
    return [[NSHTTPCookie alloc] initWithProperties:[NSDictionary dictionaryWithDictionary:cookie]];
}

+ (BOOL)insertCookieForUrl:(NSURL *)URL
{
    NSString *cookieDomain = nil;
    if ([DTURLWhiteList isWhiteUrl:URL matchWhiteDomain:&cookieDomain]) {
        BOOL isLogin = [JTUserManager sharedInstance].isLogined;
        
        //设置cookie
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        [storage setCookie:[self createCookieWithKey:@"jt_app" value:APP_PROJECT_NAME domain:cookieDomain]];
        [storage setCookie:[self createCookieWithKey:@"jt_appVersion" value:APP_VERSION_SHORT domain:cookieDomain]];
        [storage setCookie:[self createCookieWithKey:@"jt_os" value:@"iOS" domain:cookieDomain]];
        [storage setCookie:[self createCookieWithKey:@"jt_device" value:[JTNetManager sharedInstance].deviceModel domain:cookieDomain]];
        [storage setCookie:[self createCookieWithKey:@"jt_osVersion" value:[JTNetManager sharedInstance].osVersion domain:cookieDomain]];
        if (isLogin) {
            NSString *token = [JTUserManager sharedInstance].ac_token;
            [storage setCookie:[self createCookieWithKey:@"jt_userToken" value:token domain:cookieDomain]];
        }
        return YES;
    }
    return NO;
}

@end
