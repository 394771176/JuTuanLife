//
//  JTShipItem.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/14.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <WCModel/WCBaseEntity.h>
#import "JTUser.h"

@interface JTShipItem : JTUser

@property (nonatomic, strong) NSString *relatedTime;

@property (nonatomic, assign) NSInteger relationType;

@end
