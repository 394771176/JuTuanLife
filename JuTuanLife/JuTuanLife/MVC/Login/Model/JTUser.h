//
//  JTUser.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/4.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <WCModel/WCBaseEntity.h>
#import "JTProtorolItem.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JTUserStatus) {
    JTUserStatusNeedLogin,
    JTUserStatusNeedCertifie,
    JTUserStatusNeedSign,
    JTUserStatusAuthPass,
};

@class JTUserCert, JTUserTeam;

@interface JTUser : WCBaseEntity

@property (nonatomic, assign) NSString *userNo;
@property (nonatomic, assign) NSString *jobNo;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *avatar;

@property (nonatomic, strong) NSString *phone;

@property (nonatomic, strong) JTUserCert *cert;

@property (nonatomic, strong) NSString *bizCityCode;
@property (nonatomic, strong) NSString *bizCityName;
@property (nonatomic, strong) NSString *createTime;

//收货地址
@property (nonatomic, strong) NSString *address;

@property (nonatomic, strong) NSString *bankNum;
@property (nonatomic, strong) NSString *yajinTip;

@property (nonatomic, assign) NSInteger apprentices;
@property (nonatomic, strong) NSArray<JTUserTeam *> *teams;

- (NSString *)phoneCipher;
- (NSString *)IDNumCipher;
- (NSString *)bankNumCipher;

@end

//身份证
@interface JTUserCert : WCBaseEntity

@property (nonatomic, assign) NSInteger certType;
@property (nonatomic, strong) NSString *certNo;
@property (nonatomic, strong) NSString *certAddress;
@property (nonatomic, strong) NSString *certFront;
@property (nonatomic, strong) NSString *certBack;
@property (nonatomic, strong) NSString *certExpire;
@property (nonatomic, strong) NSString *certIssuer;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *nation;
@property (nonatomic, assign) NSInteger gender;

@property (nonatomic, strong) NSString *faceImg;

@property (nonatomic, assign) BOOL certAuth;
@property (nonatomic, strong) NSString *certAuthTime;

@end

@interface JTUserTeam : WCBaseEntity {
    
}

@property (nonatomic, strong) NSString *itemId;
@property (nonatomic, strong) NSString *name;

@end


NS_ASSUME_NONNULL_END
