//
//  WCCookieManager.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/31.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCCookieManager : NSObject

+ (BOOL)isWhiteUrl:(NSURL *)url matchDomain:(NSString **)domain;

+ (BOOL)insertCookieForUrl:(NSURL *)URL;

+ (NSMutableURLRequest *)getCookieRequestWithURL:(NSURL *)URL forWKWebView:(WKWebView *)webView;

@end
