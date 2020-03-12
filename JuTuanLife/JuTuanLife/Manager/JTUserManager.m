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

//#define JTUserManager_ACTOKEN_KEY      @"JTUserManager_ACTOKEN.KEY"
//#define JTUserManager_USERINFO_KEY      @"JTUserManager_USERINFO.KEY"
//#define JTUserManager_PROTOROL_KEY      @"JTUserManager_PROTOROL.KEY"

KEY(JTUserManager_ACTOKEN)
KEY(JTUserManager_USERINFO)
KEY(JTUserManager_PROTOROL)

@interface JTUserManager () {
    JTUserStatus _currentStatusMark;
    JTUserStatus _statusMark;
}

@end

@implementation JTUserManager

SHARED_INSTANCE_M

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSDictionary *tokenDict = [[BPAppPreference sharedInstance] dictionaryForKey:JTUserManager_ACTOKEN];
        NSDictionary *userDict = [[[BPAppPreference sharedInstance] stringForKey:JTUserManager_USERINFO] JSONObject];
        NSDictionary *protorolDict = [[[BPAppPreference sharedInstance] stringForKey:JTUserManager_PROTOROL] JSONObject];
        
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
        
        _currentStatusMark = [self userAuthStatus];
    }
    return self;
}

- (BOOL)isLogined
{
    return _ac_token.length > 0 && _rf_token.length > 0 && _user;
}

- (BOOL)isAuth
{
    return [self userAuthStatus] == JTUserStatusAuthPass;
}

- (JTUserStatus)userAuthStatus
{
    if (_statusMark > 0) {
        return _statusMark;
    }
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

- (void)setControllerAuthStatus:(JTUserStatus)status
{
    _statusMark = status;
}

- (void)checkUpdateAuthStatusController
{
    JTUserStatus status = [self userAuthStatus];
    if (status == JTUserStatusNeedLogin || status == JTUserStatusAuthPass) {
        [JTCommon resetRootController];
    } else {
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
            default:
                break;
        }
    }
}

- (void)updateAcToken:(NSDictionary *)dict
{
    if ([NSDictionary validDict:dict]) {
        self.ac_token = [dict stringForKey:@"ac_token"];
        self.rf_token = [dict stringForKey:@"rf_token"];
        [[BPAppPreference sharedInstance] setObject:dict forKey:JTUserManager_ACTOKEN];
    } else {
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

- (void)refreshUserInfo
{
    if ([self isLogined]) {
        [JTService async:[JTUserRequest getUserInfo] config:^(WCDataResult *result) {
            [self updateUserInfo:result.data];
        } finish:^(WCDataResult *result) {
            
        }];
    }
}

- (void)refreshProtorol
{
    if ([self isLogined]) {
        [JTService async:[JTUserRequest get_unsigned_contracts] config:^(WCDataResult *result) {
            [self updateProtorol:result.data];
        } finish:^(WCDataResult *result) {
            
        }];
    }
}

- (void)saveAcToken:(NSDictionary *)tokenDict userInfo:(NSDictionary *)userDict protorol:(NSDictionary *)protorolDict
{
    [self updateAcToken:tokenDict];
    [self updateUserInfo:userDict];
    [self updateProtorol:protorolDict];
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
        BOOL success = NO;
        WCDataResult *tokenResult = [JTService sync:[JTUserRequest loginWithMobile:phone password:password]];
        if (tokenResult.success) {
            NSString *token = [tokenResult.data stringForKey:@"ac_token"];
            if (token.length) {
                [[self sharedInstance] setAc_token:token];
                WCDataResult *userResult = [JTService sync:[JTUserRequest getUserInfo]];
                if (userResult.success) {
                    WCDataResult *protorolResult = [JTService sync:[JTUserRequest get_unsigned_contracts]];
                    if (protorolResult.success) {
                        success = YES;
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
    if (block) {
        block();
    }
}

+ (UIViewController *)rootController
{
    JTUserStatus status = [[self sharedInstance] userAuthStatus];
    switch (status) {
        case JTUserStatusAuthPass:
            return [[JTMainController alloc] init];
            break;
        case JTUserStatusNeedCertifie:
            return [[JTLoginAuthController alloc] init];
            break;
        case JTUserStatusNeedSign:
            return [[JTLoginAgreementController alloc] init];
        default:
            return [[JTLoginHomeController alloc] init];
            break;
    }
}

@end
