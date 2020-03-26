//
//  DTWebViewController.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/21.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "DTWebViewController.h"
#import "WCWebBackBarView.h"
#import "DTURLWhiteList.h"

@interface DTWebViewController () <WCWKWebViewDelegate> {
    WCWKWebView *_webView;
    WCWebBackBarView *_backBarView;
    NSString *_rightItemUrl;
}

@property (nonatomic, assign) BOOL hasStartLoad;

@end

@implementation DTWebViewController

- (void)dealloc
{
    _webView.delegate = nil;
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

}

- (void)viewDidLoad {
    self.disableBackBtn = YES;
    
    _backBarView = [WCWebBackBarView view];
    [_backBarView addTarget:self withBackAction:@selector(backAction)];
    [_backBarView addTarget:self withCloseAction:@selector(closeAction)];
    [self setLeftBarItem:WCBarItem(_backBarView)];
    
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
    
    [DTURLWhiteList insertCookieForUrl:URL];
    
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

- (void)backAction
{
    if ([_webView canGoBack]) {
        [_webView goBack];
        _backBarView.showCloseBtn = YES;
    } else {
        [self closeAction];
    }
}

- (void)closeAction
{
    [super backAction];
}

#pragma mark - WCWKWebViewDelegate

- (BOOL)checkWebViewScheme:(NSString *)urlStr
{
    // 强制当前页打开
    if ([urlStr rangeOfString:@"://webview/back"].length) {
        [self backAction];
        return YES;
    } else if ([urlStr rangeOfString:@"://webview/close"].length) {
        [self closeAction];
        return YES;
    } else if ([urlStr rangeOfString:@"://webview/login"].length) {
        
        return YES;
    } else if ([urlStr rangeOfString:@"://webview/logout"].length) {
        [JTUserManager logoutAction:^{
            
        }];
        return YES;
    } else if ([urlStr rangeOfString:@"://webview/loading"].length) {
        NSString *message = [urlStr getUrlParamValueForkey:@"message"];
        NSInteger type = [urlStr getUrlParamIntForkey:@"type"];
        BOOL stop = [urlStr getUrlParamBoolForkey:@"stop"];
        if (stop) {
            [DTPubUtil stopHUDLoading];
            [self stopLoadingIndicator];
        } else {
            if (type == 0) {
                [DTPubUtil startHUDLoading:message];
                [DTPubUtil stopHUDLoading:10];
            } else {
                [self startLoadingIndicator];
                [self stopLoadingIndicatorByDelay:10];
            }
        }
        return YES;
    } else if ([urlStr rangeOfString:@"://webview/rightBarItem"].length) {
        NSString *title = [urlStr getUrlParamValueForkey:@"title"];
        if (title.length) {
            _rightItemUrl = [urlStr getUrlParamValueForkey:@"url"];
            [self setRightBarItem:[WCBarItemUtil barButtonItemWithTitle:title target:self action:@selector(rightItemAction)]];
        } else {
            _rightItemUrl = nil;
            [self setRightBarItem:nil];
        }
        return YES;
    }
    return NO;
}

- (void)rightItemAction
{
    [WCLinkUtil openWithLink:_rightItemUrl];
}

- (BOOL)webView:(WCWKWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(WKNavigationType)navigationType
{
    NSString *urlStr = request.URL.absoluteString;
    
    if ([urlStr rangeOfString:@"__target=__self"].length) {
        return YES;
    } else if ([urlStr rangeOfString:@"about:blank"].length) {
        return YES;
    }
    
    if ([self checkWebViewScheme:urlStr]) {
        return NO;
    }
    
    if (!self.fromLinkUtil) {
        BOOL popOne = [urlStr getUrlParamBoolForkey:@"jt_popone"];
        BOOL needPush = [urlStr getUrlParamBoolForkey:@"jt_push"];
        UIViewController *vc = [JTLinkUtil getControllerWithLink:urlStr forcePush:self.forcePush || popOne || needPush];
        if (vc) {
            [JTLinkUtil checkOpenController:vc withLink:urlStr popOne:popOne];
            return NO;
        }
    } else {
        //该属性用过后就失效，需要重置
        self.fromLinkUtil = NO;
    }
    
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
