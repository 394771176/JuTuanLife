//
//  HttpPreloadTaskMeta.h
//  Base64-WangXin
//
//  Created by Hansong Liu on 2019/7/29.
//

#import <Foundation/Foundation.h>

#import "ScheduleTaskMeta.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * HTTP请求预加载，不处理登陆、302等逻辑
 */
@interface HttpPreloadTaskMeta : ScheduleTaskMeta

@property (nonatomic, copy) NSString* url;
@property (nonatomic, copy) NSString* requestType;
@property (nonatomic, copy) NSString* charset;
@property (nonatomic, copy) NSDictionary<NSString*, NSString*>* header;
@property (nonatomic, copy) NSDictionary<NSString*, NSString*>* apiParams;
@property (nonatomic, copy) NSDictionary<NSString*, NSString*>* ignoreParams;
@property (nonatomic, assign) int timeout;              // preload instance will be freed after give time

@end

NS_ASSUME_NONNULL_END
