//
//  WVURLCache+WVPrivate.h
//  Basic
//
//  Created by lianyu.ysj on 16/3/30.
//  Copyright © 2016年 WindVane. All rights reserved.
//

#import <WindVaneBasic/WVURLCache.h>
#import <WindmillWeaver/WindmillWeaver.h>

// 要求不作为缓存清除的文件后缀
#define WV_NO_CLEAN_SUFFIX @"._WV_NO_CLEAN_"

/**
 * WindVane URL 缓存的私有接口。
 */
@interface WVURLCache (WVPrivate) <WMLNetworkCacheProtocol>

/**
 * 安装缓存服务。
 */
+ (void)setup;

@end
