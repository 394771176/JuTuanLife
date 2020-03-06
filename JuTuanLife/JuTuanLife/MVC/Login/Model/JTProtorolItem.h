//
//  JTProtorolItem.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/7.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <WCModel/WCBaseEntity.h>

NS_ASSUME_NONNULL_BEGIN

@interface JTProtorolItem : WCBaseEntity

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *link;

+ (JTProtorolItem *)itemWithName:(NSString *)name link:(NSString *)link;

@end

NS_ASSUME_NONNULL_END
