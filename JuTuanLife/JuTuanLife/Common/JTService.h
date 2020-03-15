//
//  JTService.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/6.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <WCNetKit/WCDataService.h>

@interface JTService : WCDataService

+ (void)loadCache:(void (^)(WCDataResult *cache))cacheBlock
           forKey:(NSString *)cacheKey;

+ (void)async:(WCDataRequest *)request
     cacheKey:(NSString *)cacheKey
    loadCache:(void (^)(WCDataResult *cache))cacheBlock
       finish:(void (^)(WCDataResult *result))finish;

@end
