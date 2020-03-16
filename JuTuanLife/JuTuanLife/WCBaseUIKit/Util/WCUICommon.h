//
//  WCHeader.h
//  WCUIKit
//
//  Created by cheng on 2019/10/16.
//

/**
 #import "WCUICommon.h"
*/

#ifndef WCHeader_h
#define WCHeader_h

#import <WCCategory/WCCategory.h>

#if __has_include(<WCPlugin/WCPlugin.h>)
#import <WCPlugin/WCPlugin.h>
#elif __has_include(<WCPlugin/MBProgressHUDAdditions.h>)
#import <WCPlugin/MBProgressHUDAdditions.h>
#endif

#if __has_include(<WCModule/DTReachabilityUtil.h>)
#import <WCModule/DTReachabilityUtil.h>
#endif

#import "FFConfiguration.h"

#import "DTPubUtil.h"
#import "WCMethodUtil.h"
#import "WCAppStyleUtil.h"
#import "WCControllerUtil.h"
#import "WCBarItemUtil.h"
#import "CWStaticImageManager.h"

#define APP_CONST_BLACK_STRING               @"3f3f3f"
#define APP_CONST_BLACK_COLOR                [UIColor colorWithHexString:APP_CONST_BLACK_STRING]     //黑色

#define APP_CONST_BLUE_STRING                @"0093f0"//@"38a8ef"
#define APP_CONST_BLUE_COLOR                 [UIColor colorWithHexString:APP_CONST_BLUE_STRING]      // 蓝色

#define APP_CONST_RED_STRING                @"ff471b"
#define APP_CONST_RED_COLOR                 [UIColor colorWithHexString:APP_CONST_RED_STRING]      // 红色

#define APP_CONST_PINK_STRING                @"fc3670"
#define APP_CONST_PINK_COLOR                 [UIColor colorWithHexString:APP_CONST_PINK_STRING]      // 粉色

#pragma mark - block

typedef void (^DTVoidBlock)(void);
typedef void (^DTCommonBlock)(id userInfo);
typedef void (^DTIntBlock)(NSInteger num);

#endif /* WCHeader_h */
