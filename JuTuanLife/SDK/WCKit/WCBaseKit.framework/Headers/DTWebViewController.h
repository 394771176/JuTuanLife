//
//  DTWebViewController.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/21.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "DTViewController.h"
#import "WCWKWebView.h"

@interface DTWebViewController : DTViewController

@property (nonatomic, strong) NSString *strTitle;

@property (nonatomic, strong) NSString *urlStr;
@property (nonatomic, strong) NSURL *URL;

@property (nonatomic, assign) BOOL fromLinkUtil;
@property (nonatomic, assign) BOOL forcePush;

@property (nonatomic, strong) WCWKWebView *webView;

- (BOOL)checkWebViewScheme:(NSString *)urlStr;
- (BOOL)checkAppLinkScheme:(NSString *)urlStr;

@end
