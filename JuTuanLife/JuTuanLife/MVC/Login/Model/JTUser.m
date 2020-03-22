//
//  JTUser.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/4.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTUser.h"

@implementation JTUser

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper
{
    return @{@"name" : @[@"name", @"userName"]};
}

/*
 apprentices = 12;
 avatar = "";
 birthday = "";
 bizCityCode = 310100;
 bizCityName = "\U4e0a\U6d77\U5e02";
 certAddress = "\U4e0a\U6d77\U5e02\U677e\U6c5f\U533a\U5e7f\U5bcc\U6797\U8def1188\U5f04154\U53f71604\U5ba4";
 certAuth = 1;
 certAuthTime = "2020-03-08 00:14:26";
 certBack = "images/2020/03/07/901fee96023b30456c0bc8d002c46c4cad17.jpeg";
 certExpire = "";
 certFront = "images/2020/03/07/a2e7861b0edc404340097440977129bef6df.jpg";
 certIssuer = "";
 certNo = 340104198307163038;
 certType = 1;
 createTime = "2020-03-07 13:58:00";
 depositPaid = 0;
 depositTotal = 100000;
 gender = 1;
 jobNo = JTB0000001;
 mobile = 15618197321;
 name = "\U5218\U5065";
 nation = "\U6c49";
 shippingAddress = "\U4e0a\U6d77\U5e02\U677e\U6c5f\U533a\U5e7f\U5bcc\U6797\U8def1155\U5f0412\U53f71202\U5ba4";
 teams =     (
 {
 id = 1;
 name = "\U805a\U56e2";
 },
 {
 id = 2;
 name = "\U805a\U63a8";
 }
 );
 userNo = U120200307210893057585152;
 */

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass
{
    return @{@"teams" : [JTUserTeam class]};
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic
{
    if (APP_DEBUG) {
        _bankNum = @"1234567890123344";
    }
    _phone = _mobile;
    self.cert = [JTUserCert itemFromDict:dic];
    return YES;
}

- (NSString *)phone
{
    if (_mobile.length) {
        return _mobile;
    }
    if (!_phone) {
        _phone = [JTUserManager sharedInstance].phone;
    }
    return _phone;
}

- (NSString *)phoneCipher
{
    if (self.phone.length) {
        NSInteger right = MIN(_phone.length / 3, 3);
        NSInteger left = MIN((_phone.length - right) / 2, 3);
        
//        NSMutableString *str = [NSMutableString string];
//        for (int i=0; i < _phone.length - left - right; i++) {
//            [str appendString:@"*"];
//        }
//        return [_phone stringByReplacingCharactersInRange:NSMakeRange(left, _phone.length - left - right) withString:str];
        return [self.class replaceString:_phone withStr:@"*" inRange:NSMakeRange(left, _phone.length - left - right)];
    } else {
        return _phone;
    }
}

- (NSString *)IDNumCipher
{
    NSString *num = self.cert.certNo;
    if (APP_DEBUG) {
        num = @"362334199008253112";
    }
    if (num.length > 5) {
//        return [num stringByReplacingCharactersInRange:NSMakeRange(1, num.length - 5) withString:@"·"];
        return [self.class replaceString:num withStr:@"·" inRange:NSMakeRange(1, num.length - 5)];
    } else {
        return num;
    }
}

- (NSString *)bankNumCipher
{
    if (_bankNum.length > 4) {
//        return [_bankNum stringByReplacingCharactersInRange:NSMakeRange(0, _bankNum.length - 4) withString:@"·"];
        NSString *str = [self.class replaceString:_bankNum withStr:@"·" inRange:NSMakeRange(0, _bankNum.length - 4)];
        return [self.class insertSpaceForString:str withLength:4];
    } else {
        return _bankNum;
    }
}

- (NSString *)bizCityNameShort
{
    if (_bizCityName && [_bizCityName hasSuffix:@"市"] && _bizCityName.length > 2) {
        return [_bizCityName substringToIndex:_bizCityName.length - 1];
    }
    return _bizCityName;
}

+ (NSString *)replaceString:(NSString *)string withStr:(NSString *)str inRange:(NSRange)range
{
    if (string.length && str.length && range.location + range.length < string.length) {
        NSMutableString *mStr = [NSMutableString string];
        for (NSInteger i = 0; i < range.length; i++) {
            [mStr appendString:str];
        }
        return [string stringByReplacingCharactersInRange:range withString:mStr];
    }
    return string;
}

+ (NSString *)insertSpaceForString:(NSString *)string withLength:(NSInteger)length
{
    if (string.length > length) {
        NSMutableArray *array = [NSMutableArray array];
        NSString *str = [string mutableCopy];
        while (str.length > length) {
            [array safeAddObject:[str substringToIndex:length]];
            str = [str substringFromIndex:length];
        }
        if (str.length) {
            [array safeAddObject:str];
        }
        return [array componentsJoinedByString:@" "];
    }
    return string;
}

@end


@interface JTUserCert () {
    
}

@end


@implementation JTUserCert


@end


@interface JTUserTeam ()
{
    
}

@end

@implementation JTUserTeam

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper
{
    return @{@"itemId" : @"id"};
}

- (NSString *)fullName
{
    if (!_fullName.length) {
//        if ([self.name isEqualToString:@"聚团"]) {
//            return @"聚团生活";
//        } else if ([self.name isEqualToString:@"聚推"]) {
//            return @"聚推帮";
//        } else {
//            return _name;
//        }
        return _name;
    } else {
        return _fullName;
    }
}

@end
