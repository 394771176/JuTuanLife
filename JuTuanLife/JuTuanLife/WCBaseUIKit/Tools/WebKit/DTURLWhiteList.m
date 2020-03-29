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

+ (NSMutableURLRequest *)setFirstRequestCookies:(NSURLRequest *)request
{
    NSMutableURLRequest *originalRequest = [request mutableCopy];
    NSString *validDomain = request.URL.host;
    const BOOL requestIsSecure = [request.URL.scheme isEqualToString:@"https"];
    
    NSMutableArray *array = [NSMutableArray array];
    if (validDomain != nil) {
        for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
            // Don't even bother with values containing a `'`
            if ([cookie.name rangeOfString:@"'"].location != NSNotFound) {
//                BPLoggerSkipping(@"Skipping %@ because it contains a '", cookie.properties);
                continue;
            }
            
            // Is the cookie for current domain?
            if (![cookie.domain hasSuffix:validDomain]) {
//                BPLoggerSkipping(@"Skipping %@ (because not %@)", cookie.properties, validDomain);
                continue;
            }
            
            // Are we secure only?
            if (cookie.secure && !requestIsSecure) {
//                BPLoggerSkipping(@"Skipping %@ (because %@ not secure)", cookie.properties, request.URL.absoluteString);
                continue;
            }
            
            // 过期处理
//            BOOL canDelete = [[[CKUIManager sharedManager] getConfigParams:@"wk_del_expires_cookie"] boolValue];
//            if (canDelete) {
//                if ([[NSDate date] compare:cookie.expiresDate] == NSOrderedDescending) {
//                    BPLoggerSkipping(@"Skipping %@ (because cookie hax expires) for url :%@", cookie.properties, request.URL.absoluteString);
//                    continue;
//                }
//            }
            
            NSString *value = [NSString stringWithFormat:@"%@=%@", cookie.name, cookie.value];
            [array addObject:value];
        }
    }
    
    NSString *header = [array componentsJoinedByString:@";"];
    if (array.count && header.length) {
        [originalRequest setValue:header forHTTPHeaderField:@"Cookie"];
    }
    return originalRequest;
}

@end
