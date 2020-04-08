//
//  WMBQueue.h
//  Bridge
//
//  Created by lianyu on 2018/4/12.
//  Copyright © 2018年 Windmill. All rights reserved.
//

#import <Foundation/Foundation.h>

#if defined __cplusplus
extern "C" {
#endif

/**
 如果当前已经是主线程，那么直接调用；否则在主线程异步调用指定 Block。
 */
void WMBDispatchOnMainThread(dispatch_block_t _Nonnull block);

/**
 在后台线程异步调用指定 Block。
 */
void WMBDispatchOnGlobalThread(dispatch_block_t _Nonnull block);

#if defined __cplusplus
};
#endif
