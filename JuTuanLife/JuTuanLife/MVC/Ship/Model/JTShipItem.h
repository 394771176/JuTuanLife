//
//  JTShipItem.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/14.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <WCBaseKit/WCBaseKit.h>
#import "JTUser.h"

@interface JTShipItem : JTUser

@property (nonatomic, strong) NSString *relatedTime;

//关系类型，0: 自己, 1: 徒弟, 2: 徒孙
@property (nonatomic, assign) NSInteger relationType;
@property (nonatomic, readonly) NSString *relationTypeName;

@property (nonatomic, assign) CGFloat commAmt;

+ (NSString *)relationTypeName:(NSInteger)type;

@end
