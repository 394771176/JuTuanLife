//
//  WMLPrefetchDataResponse.h
//  Weaver
//
//  Created by lianyu on 2018/4/16.
//  Copyright © 2018年 Windmill. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 预取数据的响应。
*/
@interface WMLPrefetchDataResponse : NSObject

/**
 数据的超时时间（秒），0 为不超时，默认为 10 秒。
 */
@property (nonatomic, assign) NSTimeInterval maxAge;

/**
 数据的使用次数限制，-1 为不限制，默认为 1。
 */
@property (nonatomic, assign) NSInteger useageLimit;

/**
 预取的数据。
 */
@property (nonatomic, strong, readonly, nonnull) NSDictionary * data;

/**
 使用预取的数据初始化。
 */
- (instancetype _Nonnull)initWithData:(NSDictionary * _Nonnull)data;

@end
