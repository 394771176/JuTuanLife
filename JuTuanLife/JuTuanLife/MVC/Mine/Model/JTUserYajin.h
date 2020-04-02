//
//  JTUserYajin.h
//  JuTuanLife
//
//  Created by cheng on 2020/4/2.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <WCModel/WCModel.h>

@interface JTUserYajin : WCBaseEntity

/*
 comAmt    string
 分润金额，单位：分
 
 depositPaid    string
 押金金额，单位：分
 
 id    string
 数据编号
 
 paidTime    string
 押金扣除日期
 
 userNo    string
 用户编号
 */
@property (nonatomic, assign) NSInteger itemId;
@property (nonatomic, strong) NSString *userNo;

@property (nonatomic, assign) CGFloat comAmt;
@property (nonatomic, assign) CGFloat depositPaid;

@property (nonatomic, strong) NSString *paidTime;

@end
