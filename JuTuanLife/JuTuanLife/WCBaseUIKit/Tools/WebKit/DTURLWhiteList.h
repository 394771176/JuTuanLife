//
//  DTURLWhiteList.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/26.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DTURLWhiteList : NSObject

+ (BOOL)isWhiteUrl:(NSURL *)url matchWhiteDomain:(NSString *__autoreleasing *)whiteDomain;

+ (BOOL)insertCookieForUrl:(NSURL *)URL;

@end

NS_ASSUME_NONNULL_END
