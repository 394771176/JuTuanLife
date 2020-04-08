//
//  WMLPrefetchReporter.h
//  Weaver
//
//  Created by AllenHan on 2019/8/1.
//  Copyright © 2019年 Windmill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMLPrefetchResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface WMLPrefetchReporter : NSObject

+ (void)reportWithUrl:(NSString *)url result:(WMLPrefetchResult *)result;

@end

NS_ASSUME_NONNULL_END
