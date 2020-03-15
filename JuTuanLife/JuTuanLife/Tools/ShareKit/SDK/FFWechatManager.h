//
//  FFWechatManager.h
//  FFStory
//
//  Created by PageZhang on 16/3/9.
//  Copyright © 2016年 Chelun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WechatOpenSDK_NoPay/WXApi.h>
#import "CLWXAccess.h"
#import "DTShareItem.h"

@interface FFWechatManager : NSObject <WXApiDelegate> 

@property (nonatomic, copy) FFReqCallback callback;

+ (instancetype)sharedInstance;

// 注册微信
- (void)configWithAppKey:(NSString *)appKey appSecret:(NSString *)appSecret;

// 是否可用
+ (BOOL)isAvaliable;

// 授权
- (void)auth:(FFReqCallback)callback;

// 分享
- (void)share:(DTShareItem *)obj scene:(int)scene callback:(FFReqCallback)callback;

- (NSString *)responseObjectFromSuccessResp:(BaseResp *)resp;

- (void)authWithWXAccess:(void (^)(CLWXAccess *access, NSString *error))accessBlock;
- (void)authWithWXAccessUserInfo:(void (^)(CLWXAccess *access, CLWXAccessUserInfo *userInfo, NSString *error))accessBlock;

@end
