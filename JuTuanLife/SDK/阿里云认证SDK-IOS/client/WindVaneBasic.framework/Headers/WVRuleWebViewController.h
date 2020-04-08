/*
 * WVRuleWebViewController.h
 * 
 * Created by WindVane.
 * Copyright (c) 2017年 阿里巴巴-淘宝技术部. All rights reserved.
 */

#import "WVViewController.h"

/**
 这个类已将主要功能迁移到 WVViewController。
 */
@interface WVRuleWebViewController : WVViewController

#pragma mark - 已废弃

/**
 【已废弃】URL 拦截的回调会在 shouldStartLoadWithRequest 回调返回 YES 之后调用。
 实际使用中与 shouldStartLoadWithRequest 比较容易混淆，因此建议在 shouldStartLoadWithRequest 回调中增加自己的逻辑，而不是这里。
 */
- (BOOL)interruptJumpToLocalPage:(NSInteger)target withParam:(NSDictionary * _Nullable)params withRequest:(NSURLRequest * _Nonnull)request DEPRECATED_ATTRIBUTE;

@end
