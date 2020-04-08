//
//  WCNetManager.h
//  WCKitDemo
//
//  Created by cheng on 2019/9/26.
//  Copyright © 2019 cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WCCategory.h"

NS_ASSUME_NONNULL_BEGIN

@interface WCNetManager : NSObject

@property (nonatomic, assign) BOOL enableLog;//允许日志
@property (nonatomic, assign) BOOL enableProxy;//允许抓包
@property (nonatomic, assign) NSInteger defaultTimeOut;//默认超时时长

SHARED_INSTANCE_H

+ (NSString *)createUserAgent;

@end

NS_ASSUME_NONNULL_END
