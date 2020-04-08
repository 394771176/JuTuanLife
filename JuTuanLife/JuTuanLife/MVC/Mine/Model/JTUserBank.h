//
//  JTUserBank.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/9.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <WCBaseKit/WCBaseKit.h>

@interface JTUserBank : WCBaseEntity

/*
 id *
 银行卡编号
 
 cardNo
 银行卡号
 
 bankName
 银行名称
 
 bankBranch
 开户行
 
 holder
 持有人姓名
 */
@property (nonatomic, strong) NSString *itemId;
@property (nonatomic, strong) NSString *cardNo;
@property (nonatomic, strong) NSString *bankName;
@property (nonatomic, strong) NSString *bankBranch;

@property (nonatomic, strong) NSString *userNo;
@property (nonatomic, strong) NSString *holder;

@property (nonatomic, strong) NSString *createTime;

- (NSString *)bankNumCipher;

@end
