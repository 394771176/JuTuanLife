//
//  JTUser.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/4.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <WCModel/WCBaseEntity.h>
#import "JTProtorolItem.h"
#import "JTUserBank.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JTUserStatus) {
    JTUserStatusNeedLogin,
    JTUserStatusNeedCertifie,
    JTUserStatusNeedSign,
    JTUserStatusAuthPass,
};

@class JTUserCert, JTUserTeam;

@interface JTUser : WCBaseEntity

@property (nonatomic, strong) NSString *userNo;
@property (nonatomic, strong) NSString *jobNo;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *avatar;

@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *mobile;

@property (nonatomic, strong) JTUserCert *cert;

@property (nonatomic, strong) NSString *bizCityCode;
@property (nonatomic, strong) NSString *bizCityName;

@property (nonatomic, strong) NSString *createTime;

//收货地址
@property (nonatomic, strong) NSString *shippingAddress;

//@property (nonatomic, strong) NSString *bankNum;

//押金
@property (nonatomic, assign) CGFloat depositPaid;
@property (nonatomic, assign) CGFloat depositTotal;
@property (nonatomic, strong) NSString *depositTips;

@property (nonatomic, assign) NSInteger apprentices;
@property (nonatomic, strong) NSArray<JTUserTeam *> *teams;

- (NSString *)phoneCipher;
- (NSString *)IDNumCipher;
//- (NSString *)bankNumCipher;
- (NSString *)bizCityNameShort;

@end

//身份证
@interface JTUserCert : WCBaseEntity

/*
 certType * integer 证件类型, 1: 身份证
 certNo * string   证件号
 certAddress string   证件地址
 certExpire string   证件有效期
 certIssuer string   证件签发机构
 certFront * string   证件正面图片
 certBack * string   证件反面图片
 faceImg * string   人脸图片
 name * string   姓名
 birthday string   生日，格式: 1983-03-02
 nation string   民族
 gender integer   性别, 1：男，2：女
 */

@property (nonatomic, assign) NSInteger certType;
@property (nonatomic, strong) NSString *certNo;
@property (nonatomic, strong) NSString *name;
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

+ (JTUserCert *)itemFromVerifyData:(NSDictionary *)dict;

@end

@interface JTUserTeam : WCBaseEntity {
    
}

@property (nonatomic, strong) NSString *itemId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *fullName;

@end


NS_ASSUME_NONNULL_END
