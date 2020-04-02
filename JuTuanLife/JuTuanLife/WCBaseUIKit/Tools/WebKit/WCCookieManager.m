//
//  WCCookieManager.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/31.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "WCCookieManager.h"

@implementation WCCookieManager

+ (BOOL)isWhiteUrl:(NSURL *)url matchDomain:(NSString **)domain
{
    if (!url) {
        return NO;
    }
    
    NSArray *whiteList = nil;
    
    whiteList = [JTDataManager sharedInstance].baseConfig.h5_domain_whitelist;
    
    if (!whiteList.count) {
        return NO;
    }
    
    NSArray *tags = [url.host componentsSeparatedByString:@"."];
    if (tags.count<2) {
        return NO;
    }
    BOOL result = NO;
    NSString *resultDomain = url.host;
    
    NSMutableString *host = [NSMutableString stringWithString:[tags lastObject]];
    for (NSInteger i=tags.count-2; i>=0; i--) {
        [host insertString:[NSString stringWithFormat:@"%@.", tags[i]] atIndex:0];
        if ([whiteList containsObject:host]) {
            resultDomain = [NSString stringWithString:host];
            result = YES;
            break;
        }
    }
    
    if (domain) {
        *domain = resultDomain;
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
    NSString *domain = nil;
    if ([self isWhiteUrl:URL matchDomain:&domain]) {
        BOOL isLogin = [JTUserManager sharedInstance].isLogined;
        
        //设置cookie
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        [storage setCookie:[self createCookieWithKey:@"jt_app" value:APP_PROJECT_NAME domain:domain]];
        [storage setCookie:[self createCookieWithKey:@"jt_appVersion" value:APP_VERSION_SHORT domain:domain]];
        [storage setCookie:[self createCookieWithKey:@"jt_os" value:@"iOS" domain:domain]];
        [storage setCookie:[self createCookieWithKey:@"jt_device" value:[JTNetManager sharedInstance].deviceModel domain:domain]];
        [storage setCookie:[self createCookieWithKey:@"jt_osVersion" value:[JTNetManager sharedInstance].osVersion domain:domain]];
        if (isLogin) {
            NSString *token = [JTUserManager sharedInstance].ac_token;
            [storage setCookie:[self createCookieWithKey:@"jt_userToken" value:token domain:domain]];
        }
        return YES;
    }
    return NO;
}

+ (NSString *)jsStrForCookie:(NSHTTPCookie *)cookie
{
    NSString *string = [NSString stringWithFormat:@"%@=%@;domain=%@;path=%@",
                        cookie.name,
                        cookie.value,
                        cookie.domain,
                        cookie.path ?: @"/"];
    
    if (cookie.secure) {
        string = [string stringByAppendingString:@";secure=true"];
    }
    
    return string;
}

+ (NSArray<NSHTTPCookie *> *)cookiesForURL:(NSURL *)url
{
    //cookie重复，先放到字典进行去重
    NSString *domain = nil;
    [self isWhiteUrl:url matchDomain:&domain];
    NSMutableDictionary *cookieDict = [NSMutableDictionary dictionary];
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        // Skip cookies that will break script
        if ([cookie.value rangeOfString:@"'"].location != NSNotFound) {
            continue;
        }
        // check cookie for current domain
        if (![cookie.domain hasSuffix:domain]) {
            continue;
        }
        [cookieDict safeSetObject:cookie forKey:cookie.name];
    }
    return [cookieDict allValues];
}

+ (NSMutableURLRequest *)getCookieRequestWithURL:(NSURL *)URL forWKWebView:(WKWebView *)webView
{
    if (!URL) {
        return nil;
    }
    
    if ([self isWhiteUrl:URL matchDomain:nil]) {
        NSArray *cookies = [self cookiesForURL:URL];
        if (cookies.count) {
            [self setWebView:webView withCookies:cookies];
            return [self requestForURL:URL withCookies:cookies];
        }
    }
    
    return [NSMutableURLRequest requestWithURL:URL];
}

// JS携带cookie的形式
+ (void)setWebView:(WKWebView *)webview withCookies:(NSArray *)cookies
{
    NSMutableString *cookieStr = [NSMutableString string];//wkwebview
    for (NSHTTPCookie *cookie in cookies) {
        [cookieStr appendFormat:@"document.cookie='%@';\n", [self jsStrForCookie:cookie]];
    }
    WKUserScript *script = [[WKUserScript alloc] initWithSource:cookieStr injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    WKUserContentController *userContentController = webview.configuration.userContentController;
    [userContentController addUserScript:script];
}

// PHP携带cookie的形式
+ (NSMutableURLRequest *)requestForURL:(NSURL *)URL withCookies:(NSArray *)cookies
{
    if (!URL) {
        return nil;
    }
    NSMutableString *cookieStr = [NSMutableString string];//request
    for (NSHTTPCookie *cookie in cookies) {
        [cookieStr appendFormat:@"%@=%@;", cookie.name, cookie.value];
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request addValue:cookieStr forHTTPHeaderField:@"Cookie"];
    return request;
}

@end
