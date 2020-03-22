//
//  DTWebViewController.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/21.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "DTWebViewController.h"

@interface DTWebViewController () <WCWKWebViewDelegate> {
    WCWKWebView *_webView;
}

@property (nonatomic, assign) BOOL hasStartLoad;

@end

@implementation DTWebViewController

- (void)dealloc
{
    
}

- (void)setStrTitle:(NSString *)strTitle
{
    _strTitle = strTitle;
    self.title = strTitle;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.hadViewDidAppear) {
        [self loadRequest];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidFirstAppear
{
//    [self loadRequest];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _webView = [[WCWKWebView alloc] initWithFrame:self.view.bounds withDelegate:self];
    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_webView];
}

- (void)setUrlStr:(NSString *)urlStr
{
    _urlStr = urlStr;
    if (urlStr.length) {
        self.URL = [NSURL URLWithString:urlStr];
    }
}

- (void)setURL:(NSURL *)URL
{
    _URL = URL;
    NSLog(@"H5 ：%@", URL.absoluteString);
    [self loadRequest];
}

- (void)loadRequest
{
    if (self.viewLoaded) {
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:self.URL];
        [_webView loadRequest:request];
        
        self.hasStartLoad = YES;
    }
}

- (void)refresh
{
    [_webView reload];
}

#pragma mark - WCWKWebViewDelegate

- (BOOL)webView:(WCWKWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(WKNavigationType)navigationType
{
    NSLog(@"%s", __func__);
    return YES;
}

- (void)webViewDidStartLoad:(WCWKWebView *)webView
{
    NSLog(@"%s", __func__);
}

- (void)webViewDidFinishLoad:(WCWKWebView *)webView
{
    NSLog(@"%s", __func__);
}

- (void)webViewDidUpdateTitle:(NSString *)title
{
    NSLog(@"%s", __func__);
    if (!_strTitle.length) {
        self.title = title;
    }
}

- (void)webView:(WCWKWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"%s, %@", __func__, error);
}

- (void)webView:(WCWKWebView *)webView didLoadingProgress:(double)progress
{
    NSLog(@"%s", __func__);
}

@end
