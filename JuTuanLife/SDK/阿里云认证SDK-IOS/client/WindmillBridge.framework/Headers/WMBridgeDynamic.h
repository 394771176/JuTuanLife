//
//  WMBridgeDynamic.h
//  Bridge
//
//  Created by lianyu on 2018/8/6.
//  Copyright © 2018年 Windmill. All rights reserved.
//

#import "WMBridgeProtocol.h"
#import <Foundation/Foundation.h>

/**
 WMBridge 提供了 Windmill/WindVane/Weex/Native 通用的 Bridge 协议。
 具体的教程可以参考文档 http://h5.alibaba-inc.com/windvane/JSBridge.html，此处作为快捷上手帮助。
 
 提供动态 WMBridge（对类名有要求，但无需注册，会自动反射查找）：
 [STEP 1] 令你要输出为服务的类继承 WMBridgeDynamic（引入头文件 <WindmillBridge/WindmillBridge.h>）。
 [STEP 2] [可选]根据需要重写 instanceScope 方法，设置实例的作用域，具体的定义参见 WMBridgeScope 枚举。
 [STEP 3] 你要输出的方法的命名需要遵循规范：
 -/+ (void)handlerName:(NSDictionary *)params withBridgeContext:(id<WMBridgeCallbackContext>)context
 其中 handlerName 即为你提供给 WMBridge 调用方的方法名称。
 · 第一个参数为 NSDictionary *，是 WMBridge 调用方传入的参数对象。
 · 第二个参数为 id<WMBridgeCallbackContext>，是 WMBridge 的调用上下文。
 [STEP 4] 在你的方法中，使用 [context callbackSuccess:RESULT]/[context callbackFailure:RET withResult:RESULT]
 来输出执行成功/失败的结果返回给 WMBridge 调用方。
 [STEP 5] 当你的 WMBridge API 逻辑执行完毕，可以主动调用 [context releaseHandler:self] 方法来主动释放内存，否则就只能等到页面销毁的时候才会释放。
 注意在 dealloc 中调用 [context releaseHandler:self] 是没有意义的，因此此时对象已经被释放了。
 
 提供普通 WMBridge（需要注册才能够使用）：
 · 使用 WMBridgeRegisterHandler 注册全局 WMBridge 处理器；
 · 使用 WMBridgeRegisterAlias 注册全局 WMBridge 别名；
 · 使用 WMBridgeRegisterClass 注册全局 WMBridge 类；
 
 [注意] 1. WMBridge 总是在主线程调用，如果有耗时操作，请务必自行切换线程。
 2. 可能你提供的服务带有多个阶段输出性，请使用 [context dispatchEvent:eventName withParam:param] 将结果通过事件的方式输出给 WMBridge 调用方。
 */

@interface WMBridgeDynamic : NSObject <WMBridgeProtocol>

/**
 WMBridge 的上下文。
 */
@property (nonatomic, weak, nullable) id<WMBridgeContext> context;

/**
 当前 WMBridge API 绑定到的 UIViewController。
 */
@property (nonatomic, weak, readonly, nullable) UIViewController * viewController;

/**
 当前 WMBridge API 绑定到的 UIView。
 */
@property (nonatomic, weak, readonly, nullable) UIView * view;

/**
 主动释放当前实例。
 */
- (void)releaseInstance;

@end
