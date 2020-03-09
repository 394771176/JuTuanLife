//
//  JTUserBank.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/9.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <WCModel/WCBaseEntity.h>

@interface JTUserBank : WCBaseEntity

@property (nonatomic, strong) NSString *itemId;
@property (nonatomic, strong) NSString *bankName;
@property (nonatomic, strong) NSString *bankType;
@property (nonatomic, strong) NSString *bankNum;

- (NSString *)bankNumCipher;

@end
