//
//  JTService.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/6.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTService.h"

@implementation JTService

+ (void)loadCache:(void (^)(WCDataResult *cache))cacheBlock
           forKey:(NSString *)cacheKey
{
    [JTService addBlockOnGlobalThread:^{
        WCDataResult *cache = nil;
        if (cacheKey && cacheBlock) {
            cache = [[BPCacheManager sharedInstance] cacheForKey:cacheKey];
        }
        [JTService addBlockOnMainThread:^{
            if (cacheBlock) {
                cacheBlock(cache);
            }
        }];
    }];
}

+ (void)async:(WCDataRequest *)request
     cacheKey:(NSString *)cacheKey
    loadCache:(void (^)(WCDataResult *cache))cacheBlock
       finish:(void (^)(WCDataResult *result))finish
{
    if (cacheBlock) {
        [self loadCache:^(WCDataResult *cache) {
            if (cacheBlock) {
                cacheBlock(cache);
            }
            [self async:request cacheKey:cacheKey finish:finish];
        } forKey:cacheKey];
    } else {
        [self async:request cacheKey:cacheKey finish:finish];
    }
}

+ (void)async:(WCDataRequest *)request
     cacheKey:(NSString *)cacheKey
       finish:(void (^)(WCDataResult *result))finish
{
    [JTService addBlockOnGlobalThread:^{
        WCDataResult *result = [JTService sync:request];
        if (result.success && cacheKey) {
            [[BPCacheManager sharedInstance] setCache:result forKey:cacheKey];
        }
        [JTService addBlockOnMainThread:^{
            if (finish) {
                finish(result);
            }
        }];
    }];
}

@end
