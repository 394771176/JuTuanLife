//
//  JTUser.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/4.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <WCModel/WCBaseEntity.h>

NS_ASSUME_NONNULL_BEGIN

@interface JTUser : WCBaseEntity

@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *avatar;

@end

NS_ASSUME_NONNULL_END
