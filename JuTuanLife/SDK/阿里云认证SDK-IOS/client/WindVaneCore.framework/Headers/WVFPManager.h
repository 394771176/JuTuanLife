//
//  WVFPManager.h
//  Core
//
//  Created by 郑祯 on 2019/9/4.
//  Copyright © 2019 WindVane. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WVPageTracker;

NS_ASSUME_NONNULL_BEGIN

/**
 白屏时间的管理类。
 */
@interface WVFPManager : NSObject

@property (nonatomic, weak) WVPageTracker * pageTracker;

+ (BOOL)openFP;

+ (NSString *)jsCodeForFP;

- (void)receiveJSMessage:(id)message;

@end

NS_ASSUME_NONNULL_END
