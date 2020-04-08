//
//  WVResourceTracker.h
//  Core
//
//  Created by 郑祯 on 2019/7/12.
//  Copyright © 2019 WindVane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WVResource.h"

@class WVPageTracker;

/**
 * 资源追踪器。
 */
@interface WVResourceTracker : NSObject

+ (instancetype _Nullable)sharedInstance;

#pragma mark - Resource Event

- (void)resourceDidStartLoad:(NSURLRequest * _Nonnull)request withOldUserAgent:(NSString * _Nullable)oldUserAgent;
- (void)resource:(NSURLRequest * _Nonnull)request didAcceptStatusCode:(NSInteger)statusCode withResponseHeader:(NSDictionary * _Nullable)header withOldUserAgent:(NSString * _Nullable)oldUserAgent;
- (void)resource:(NSURLRequest * _Nonnull)request didAcceptZCacheState:(WVZCacheState)zcacheState withOldUserAgent:(NSString * _Nullable)oldUserAgent;
- (void)resource:(NSURLRequest * _Nonnull)request didAcceptZCacheInfo:(NSString * _Nonnull)zcacheInfo withOldUserAgent:(NSString * _Nullable)oldUserAgent;
- (void)resource:(NSURLRequest * _Nonnull)request didFinishLoadWithDataSize:(NSUInteger)dataSize withOldUserAgent:(NSString * _Nullable)oldUserAgent;
- (void)resource:(NSURLRequest * _Nonnull)request didFailLoadWithError:(NSError * _Nonnull)error withOldUserAgent:(NSString * _Nullable)oldUserAgent;

#pragma mark - PageTracker Operation

- (void)addPageTracker:(WVPageTracker * _Nonnull)pageTracker;
- (void)removePageTracker:(WVPageTracker * _Nonnull)pageTracker;

@end
