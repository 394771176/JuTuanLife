//
//  JTUserProtorols.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/10.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <WCModel/WCBaseEntity.h>

@interface JTUserProtorols : WCBaseEntity

/*
 "contentUrl": "string",
 "contractId": "string",
 "name": "string",
 "signedTime": "2020-03-31T15:23:40.293Z"
 */
@property (nonatomic, strong) NSString *contractId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *contentUrl;
@property (nonatomic, strong) NSString *signedTime;

//@property (nonatomic, strong) NSDate *signedDate;

+ (NSArray<NSArray *> *)groupForDateWithItems:(NSArray<JTUserProtorols *> *)items;

@end

