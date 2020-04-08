//
//  WMBridge+Deprecated.h
//  Basic
//
//  Created by lianyu on 2018/11/22.
//  Copyright © 2018 WindVane. All rights reserved.
//

#import "WindVaneJSBridgeCore.h"
#import <Foundation/Foundation.h>
#import <WindmillBridge/WindmillBridge.h>

#pragma mark - 已废弃，预计于 2019.8.1 删除

/**
 包含已废弃的 WVBridge 接口。
 */
@interface WMBridge (Deprecated)

/**
 [已废弃]请替换为 registerHandler:withBlock: 方法，用法请参考 http://h5.alibaba-inc.com/windvane/JSBridge.html#2-2-iOS-静态注册-JSBridge。
 */
- (void)registerHandler:(NSString *)name withClassName:(NSString *)className withHandler:(WVPrivateJSBridgeHandler)handler DEPRECATED_MSG_ATTRIBUTE("请替换为 registerHandler:withBlock: 方法，用法请参考 http://h5.alibaba-inc.com/windvane/JSBridge.html#2-2-iOS-静态注册-JSBridge");

@end
