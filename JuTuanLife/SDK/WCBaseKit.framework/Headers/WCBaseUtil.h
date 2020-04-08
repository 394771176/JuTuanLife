//
//  WCBaseUtil.h
//  WCBaseKit
//
//  Created by cheng on 2020/4/7.
//  Copyright © 2020 cheng. All rights reserved.
//

#ifndef WCBaseUtil_h
#define WCBaseUtil_h

#pragma mark - block

typedef void (^DTVoidBlock)(void);
typedef void (^DTCommonBlock)(id userInfo);
typedef void (^DTIntBlock)(NSInteger num);
typedef void (^DTSuccessBlock)(BOOL success, id userInfo);//userinfo 可以是error信息

#define APP_CONST_BLUE_STRING                @"0093f0"//@"38a8ef"

#import "WCCategory.h"

#import "FFFix.h"
#import "FFConfiguration.h"
#import "BPAppDelegate.h"

#import "WCAppStyleUtil.h"
#import "WCBarItemUtil.h"
#import "WCControllerUtil.h"
#import "DTPubUtil.h"

#import "CWKeyboardManager.h"
#import "CWStaticImageManager.h"

#import "WCBaseManager.h"

#if __has_include(<WCModule/DTReachabilityUtil.h>)
#import <WCModule/DTReachabilityUtil.h>
#endif

#if __has_include(<WCModule/SDWebImageManagerUtil.h>)
#import <WCModule/SDWebImage.h>
#import <WCModule/SDWebImageManagerUtil.h>
#endif

#if __has_include(<WCPlugin/MBProgressHUDAdditions.h>)
#import <WCPlugin/MBProgressHUDAdditions.h>
#endif

#if __has_include(<WCPlugin/FLAnimatedImageView.h>)
#import <WCPlugin/FLAnimatedImageView.h>
#endif

#endif /* WCBaseUtil_h */
