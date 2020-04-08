//
//  WMLPrefetchDecision.h
//  Weaver
//
//  Created by lianyu on 2018/4/17.
//  Copyright © 2018年 Windmill. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 预取的响应类型。
 */
typedef NS_ENUM(NSUInteger, WMLPrefetchResponseType) {
	WMLPrefetchResponseTypeDefault,    // 使用默认通道返回数据
	WMLPrefetchResponseTypeCustomized, // 自行完成数据回调
};

/**
 预取的决定。
 */
@interface WMLPrefetchDecision : NSObject

/**
 预取数据的返回方式。
 */
@property (nonatomic, assign) WMLPrefetchResponseType type;

/**
 数据预取的 Handler 名称。
 */
@property (nonatomic, copy, nullable) NSString * handlerName;

/**
 【慎用】要重定向到另一个页面，默认为 nil 表示不需要重定向。
 重定向后的页面 URL 可能仍会进入到数据预取逻辑，务必自行做好保护。
 */
@property (nonatomic, strong, nullable) NSURL * redirect;
 
/**
 缓存的额外键，用于 URL 的 host+path 相同的情况，会按照 host+path#externalKey 的格式存储。
 */
@property (nonatomic, copy, nullable) NSString * externalKey;

@end
