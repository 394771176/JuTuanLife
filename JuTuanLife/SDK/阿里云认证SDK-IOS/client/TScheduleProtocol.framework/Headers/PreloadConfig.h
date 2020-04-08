//
//  PreloadConfig.h
//  TScheduleProtocol
//
//  Created by Hansong Liu on 2019/8/5.
//  Copyright © 2019 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TScheduleDigestHandler.h"

@interface PreloadConfig : NSObject

@property(nonatomic, assign) NSTimeInterval preloadTimeout;                         // preload请求超时时间,默认5000ms
@property(nonatomic, strong) id<TScheduleDigestHandler> digestHandler;              // 被预取时的回调
@property(nonatomic, copy) NSSet<NSString*>* excludedPreloadKeyParameters;          // 判断请求是否相同时的参数排除名单

@end
