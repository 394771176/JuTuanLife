//
//  WCWKWebView.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/21.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "WCCookieManager.h"

@class WCWKWebView;

@protocol WCWKWebViewDelegate <NSObject>

@optional
- (BOOL)webView:(WCWKWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(WKNavigationType)navigationType;
- (void)webViewDidStartLoad:(WCWKWebView *)webView;
- (void)webViewDidFinishLoad:(WCWKWebView *)webView;
- (void)webView:(WCWKWebView *)webView didFailLoadWithError:(NSError *)error;

- (void)webViewDidUpdateTitle:(NSString *)title;

- (void)webView:(WCWKWebView *)webView updateLoadingProgress:(double)progress;

@end

@interface WCWKWebView : WKWebView

@property (nonatomic, weak) id<WCWKWebViewDelegate> delegate;

//服务器重定向
@property (nonatomic, assign) BOOL isServerRedirect;

- (instancetype)initWithFrame:(CGRect)frame withDelegate:(id<WCWKWebViewDelegate>)delegate;

- (void)loadRequestForURL:(NSURL *)URL;

@end
