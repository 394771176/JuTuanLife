//
//  JTUserManager.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/4.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTUserManager.h"
#import "JTMainController.h"
#import "JTLoginHomeController.h"
#import "JTLoginAuthController.h"
#import "JTLoginAgreementController.h"
#import "JTViewController.h"

//#define JTUserManager_ACTOKEN_KEY      @"JTUserManager_ACTOKEN.KEY"
//#define JTUserManager_USERINFO_KEY      @"JTUserManager_USERINFO.KEY"
//#define JTUserManager_PROTOROL_KEY      @"JTUserManager_PROTOROL.KEY"

KEY(JTUserManager_ACTOKEN)
KEY(JTUserManager_USERINFO)
KEY(JTUserManager_PROTOROL)
KEY(JTUserManager_FIRST_AUTH_FINISH)

KEY(JTUserManager_PHONE)

@interface JTUserManager () {
    
}

@end

@implementation JTUserManager

SHARED_INSTANCE_M

- (instancetype)init
{
    self = [super init];
    if (self) {
        _hadFirstAuthFinish = [[BPAppPreference sharedInstance] boolForKey:JTUserManager_FIRST_AUTH_FINISH];
        [self setupUserInfo];
    }
    return self;
}

- (void)setupUserInfo
{
    if (_hadFirstAuthFinish) {
        NSDictionary *tokenDict = [[[BPAppPreference sharedInstance] stringForKey:JTUserManager_ACTOKEN] JSONObject];
        NSDictionary *userDict = [[[BPAppPreference sharedInstance] stringForKey:JTUserManager_USERINFO] JSONObject];
        NSDictionary *protorolDict = [[[BPAppPreference sharedInstance] stringForKey:JTUserManager_PROTOROL] JSONObject];
        
        _phone = [[BPAppPreference sharedInstance] stringForKey:JTUserManager_PHONE];
        
        if (tokenDict) {
            _ac_token = [tokenDict objectForKey:@"ac_token"];
            _rf_token = [tokenDict objectForKey:@"rf_token"];
        }
        if (userDict) {
            _user = [JTUser itemFromDict:[userDict objectForKey:@"user"]];
        }
        if (protorolDict) {
            NSArray *list = [protorolDict arrayForKey:@"contracts"];
            _protorolList = [JTProtorolItem itemsFromArray:list];
        }
    }
}

- (BOOL)isLogined
{
    return _ac_token.length > 0 && _rf_token.length > 0 && _user;
}

- (BOOL)isHadFirstAuthFinish
{
    return [self userAuthStatus] == JTUserStatusAuthPass;
}

- (JTUserStatus)userAuthStatus
{
    if ([self isLogined]) {
        if (!self.user.cert.certAuth) {
            return JTUserStatusNeedCertifie;
        } else if (self.protorolList.count) {
            return JTUserStatusNeedSign;
        } else {
            return JTUserStatusAuthPass;
        }
    } else {
        return JTUserStatusNeedLogin;
    }
}

- (JTUserStatus)checkNextStatusWith:(JTUserStatus)status
{
    JTUserStatus nextStatus = status + 1;
    if ([self isLogined]) {
        if (nextStatus == JTUserStatusNeedCertifie) {
            if (self.user.cert.certAuth) {
                nextStatus ++;
            }
        }
        if (nextStatus == JTUserStatusNeedSign) {
            if (self.protorolList.count <= 0) {
                nextStatus ++;
            }
        }
        
        if (nextStatus > JTUserStatusAuthPass) {
            nextStatus = JTUserStatusAuthPass;
        }
        return nextStatus;
    } else {
        return JTUserStatusNeedLogin;
    }
}

- (void)checkToNextForStatus:(JTUserStatus)status
{
    JTUserStatus nextStatus = [self checkNextStatusWith:status];
    if (nextStatus == JTUserStatusNeedCertifie) {
        PUSH_VC(JTLoginAuthController);
    } else if (nextStatus == JTUserStatusNeedSign) {
        PUSH_VC(JTLoginAgreementController);
    } else if (nextStatus == JTUserStatusAuthPass) {
        if ([JTCommon mainController]) {
            [[JTCommon topContainerController] dismissViewControllerAnimated:YES completion:nil];
        } else {
            [[BPAppPreference sharedInstance] setBool:YES forKey:JTUserManager_FIRST_AUTH_FINISH];
            [JTCommon resetRootController];
        }
    }
}

- (void)checkUserAuthStatus
{
    JTUserStatus status = [self userAuthStatus];
//    if (APP_DEBUG) {
//        if (status == JTUserStatusNeedCertifie) {
//            return;
//        }
//    }
    if (status == JTUserStatusNeedCertifie) {
        PRESENT_VC(JTLoginAuthController);
    } else if (status == JTUserStatusNeedSign) {
        PRESENT_VC(JTLoginAgreementController);
    } else if (status == JTUserStatusNeedLogin) {
        PRESENT_VC(JTLoginHomeController);
    }
}

- (void)setPhone:(NSString *)phone
{
    _phone = phone;
    if (phone.length) {
        [[BPAppPreference sharedInstance] setObject:phone forKey:JTUserManager_PHONE];
    }
}

- (void)updateAcToken:(NSDictionary *)dict
{
    if ([NSDictionary validDict:dict]) {
        self.ac_token = [dict stringForKey:@"ac_token"];
        self.rf_token = [dict stringForKey:@"rf_token"];
        [[BPAppPreference sharedInstance] setObject:[dict JSONString] forKey:JTUserManager_ACTOKEN];
    } else {
        self.ac_token = nil;
        self.rf_token = nil;
        [[BPAppPreference sharedInstance] removeObjectForKey:JTUserManager_ACTOKEN];
    }
}

- (void)updateUserInfo:(NSDictionary *)dict
{
    if ([NSDictionary validDict:dict]) {
        self.user = [JTUser itemFromDict:[dict objectForKey:@"user"]];
        [[BPAppPreference sharedInstance] setObject:[dict JSONString] forKey:JTUserManager_USERINFO];
    } else {
        self.user = nil;
        [[BPAppPreference sharedInstance] removeObjectForKey:JTUserManager_USERINFO];
    }
}

- (void)updateProtorol:(NSDictionary *)dict
{
    if ([NSDictionary validDict:dict]) {
        NSArray *list = [dict arrayForKey:@"contracts"];
        self.protorolList = [JTProtorolItem itemsFromArray:list];
        [[BPAppPreference sharedInstance] setObject:[dict JSONString] forKey:JTUserManager_PROTOROL];
    } else {
        self.protorolList = nil;
        [[BPAppPreference sharedInstance] removeObjectForKey:JTUserManager_PROTOROL];
    }
}

- (void)refreshUserInfo:(DTCommonBlock)block
{
    if ([self isLogined]) {
        [JTService async:[JTUserRequest getUserInfo] config:^(WCDataResult *result) {
            if (result.success) {
                [self updateUserInfo:result.data];
            }
        } finish:^(WCDataResult *result) {
            if (block) {
                block(result);
            }
        }];
    } else {
        if (block) {
            block(nil);
        }
    }
}

- (void)refreshProtorol:(DTCommonBlock)block
{
    if ([self isLogined]) {
        [JTService async:[JTUserRequest get_unsigned_contracts] config:^(WCDataResult *result) {
            if (result.success) {
                [self updateProtorol:result.data];
            }
        } finish:^(WCDataResult *result) {
            if (block) {
                block(result);
            }
        }];
    } else {
        if (block) {
            block(nil);
        }
    }
}

- (void)refreshUserInfoForLaunch
{
    if ([self isLogined]) {
        __block int i = 0;
        [self refreshUserInfo:^(id userInfo) {
            i++;
            if (i >= 2) {
                [[NSNotificationCenter defaultCenter] postNotificationName:JTUserManager_LAUNCH_REFRESH object:nil];
            }
        }];
        [self refreshProtorol:^(id userInfo) {
            i++;
            if (i >= 2) {
                [[NSNotificationCenter defaultCenter] postNotificationName:JTUserManager_LAUNCH_REFRESH object:nil];
            }
        }];
    }
}

- (void)saveAcToken:(NSDictionary *)tokenDict userInfo:(NSDictionary *)userDict protorol:(NSDictionary *)protorolDict
{
    [self updateAcToken:tokenDict];
    [self updateUserInfo:userDict];
    [self updateProtorol:protorolDict];
}

- (void)clearUserInfo
{
    [self updateAcToken:nil];
    [self updateUserInfo:nil];
    [self updateProtorol:nil];
}

+ (void)loginAuth:(DTIntBlock)block
{
    if (block) {
        JTUserStatus status = [[self sharedInstance] userAuthStatus];
        if (status == JTUserStatusAuthPass) {
            block(JTLoginTypeLoginedBefore);
        } else {
            [[self sharedInstance] setLoginBlock:block];
            switch (status) {
                case JTUserStatusNeedCertifie:
                {
                    PUSH_VC(JTLoginAuthController);
                }
                    break;
                case JTUserStatusNeedSign:
                {
                    PUSH_VC(JTLoginAgreementController);
                }
                    break;
                case JTUserStatusNeedLogin:
                {
                    
                }
                default:
                    break;
            }
        }
    }
}

+ (void)loginActionWithPhone:(NSString *)phone password:(NSString *)password completion:(void (^)(WCDataResult *))completion
{
    void (^loginFinish)(WCDataResult *result) = ^(WCDataResult *result){
        if (completion) {
            [JTService addBlockOnMainThread:^{
                completion(result);
            }];
        }
    };
    
    [JTService addBlockOnGlobalThread:^{
        WCDataResult *tokenResult = [JTService sync:[JTUserRequest loginWithMobile:phone password:password]];
        if (tokenResult.success) {
            NSString *token = [tokenResult.data stringForKey:@"ac_token"];
            if (token.length) {
                [[self sharedInstance] setAc_token:token];
                WCDataResult *userResult = [JTService sync:[JTUserRequest getUserInfo]];
                if (userResult.success) {
                    WCDataResult *protorolResult = [JTService sync:[JTUserRequest get_unsigned_contracts]];
                    if (protorolResult.success) {
                        [[self sharedInstance] setPhone:phone];
                        [[self sharedInstance] saveAcToken:tokenResult.data userInfo:userResult.data protorol:protorolResult.data];
                        loginFinish(userResult);
                    } else {
                        loginFinish(protorolResult);
                    }
                } else {
                    loginFinish(userResult);
                }
            } else {
                loginFinish(tokenResult);
            }
        } else {
            loginFinish(tokenResult);
        }
    }];
}

+ (void)logoutAction:(void (^)(void))block
{
    [JTService addBlockOnGlobalThread:^{
        [[self sharedInstance] clearUserInfo];
        [JTService addBlockOnMainThread:^{
            [[self sharedInstance] checkUserAuthStatus];
            if (block) {
                block();
            }
        }];
    }];
}

+ (UIViewController *)rootController
{
    //启动：两者之一
    if ([[self sharedInstance] isLogined]) {
        return [[JTMainController alloc] init];
    } else {
        return [[JTLoginHomeController alloc] init];
    }
    
//    JTUserStatus status = [[self sharedInstance] userAuthStatus];
//    switch (status) {
//        case JTUserStatusAuthPass:
//            return [[JTMainController alloc] init];
//            break;
//        case JTUserStatusNeedCertifie:
//            return [[JTLoginAuthController alloc] init];
//            break;
//        case JTUserStatusNeedSign:
//            return [[JTLoginAgreementController alloc] init];
//        default:
//            return [[JTLoginHomeController alloc] init];
//            break;
//    }
}

@end
