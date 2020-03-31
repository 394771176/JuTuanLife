//
//  JTUserManager.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/4.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WCBaseUIKit.h"
#import "JTUser.h"

KEY(JTUserManager_LAUNCH_REFRESH)
KEY(JTUserManager_USERINFO_UPDATE)
KEY(JTUserManager_USER_SESSION)

KEY(JTUserManager_USER_PROTROLS)

KEY(JTUserRequest_unread_msg_num)

typedef NS_ENUM(NSUInteger, JTLoginType) {
    JTLoginTypeLoginedBefore = 0,//之前已经登录
    JTLoginTypeLoginNow,//现在登录
    JTLoginTypeRegister,//首次注册
};

@interface JTUserManager : NSObject

@property (nonatomic, strong) NSString *ac_token;
@property (nonatomic, strong) NSString *rf_token;

@property (nonatomic, strong) NSString *phone;

//认证完成过一次
@property (nonatomic, assign) BOOL hadFirstAuthFinish;

@property (nonatomic, strong) JTUser *user;
@property (nonatomic, strong) NSArray <JTProtorolItem *> *protorolList;
@property (nonatomic, assign) NSInteger unreadMsgCount;

@property (nonatomic, strong) DTIntBlock loginBlock;

SHARED_INSTANCE_H

- (BOOL)isLogined;
- (JTUserStatus)userAuthStatus;

- (void)refreshUserInfo:(DTCommonBlock)block;
- (void)refreshProtorol:(DTCommonBlock)block;
- (void)refreshMessageUnreadCount;

//启动时刷新
- (void)refreshForLaunch;
- (void)refreshForLaunch:(BOOL)isLaunch;

- (void)checkUserAuthStatus;

- (void)updateAcToken:(NSDictionary *)dict;
- (void)updateUserInfo:(NSDictionary *)dict;
- (void)updateProtorol:(NSDictionary *)dict;

//登录三要素：token , userinfo , 协议数据
- (void)saveAcToken:(NSDictionary *)tokenDict userInfo:(NSDictionary *)userDict protorol:(NSDictionary *)protorolDict;

- (void)checkToNextForStatus:(JTUserStatus)status;

//+ (void)loginAction:(DTIntBlock)block;//登录操作
+ (void)loginAuth:(DTIntBlock)block;//登录
+ (void)logoutAction:(void (^)(void))block;

+ (void)loginActionWithPhone:(NSString *)phone password:(NSString *)password completion:(void (^)(WCDataResult *result))completion;

+ (UIViewController *)rootController;

@end
