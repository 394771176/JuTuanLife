//
//  CLWXAccess.h
//  DrivingTest
//
//  Created by cheng on 16/4/21.
//  Copyright © 2016年 eclicks. All rights reserved.
//

#import <WCModel/WCBaseEntity.h>

@interface CLWXAccess : WCBaseEntity

@property (nonatomic, strong) NSString *access_token;
@property (nonatomic, strong) NSString *expires_in;
@property (nonatomic, strong) NSString *openid;
@property (nonatomic, strong) NSString *unionid;
@property (nonatomic, strong) NSString *refresh_token;

@end

@interface CLWXAccessUserInfo : WCBaseEntity

@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *headimgurl;

@end
