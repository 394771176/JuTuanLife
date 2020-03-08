//
//  JTUser.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/4.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <WCModel/WCBaseEntity.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JTUserStatus) {
    JTUserStatusNeedCertifie,
    JTUserStatusNeedSign,
    JTUserStatusAuthPass,
};

@interface JTUser : WCBaseEntity

@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *avatar;

@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *IDNum;
@property (nonatomic, strong) NSString *bankNum;

@property (nonatomic, strong) NSString *city;

@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *yajinTip;

@property (nonatomic, assign) JTUserStatus status;

- (NSString *)phoneCipher;
- (NSString *)IDNumCipher;
- (NSString *)bankNumCipher;

@end

NS_ASSUME_NONNULL_END
