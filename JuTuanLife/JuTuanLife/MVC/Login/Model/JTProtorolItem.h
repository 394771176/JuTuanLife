//
//  JTProtorolItem.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/7.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <WCBaseKit/WCBaseKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JTProtorolItem : WCBaseEntity

@property (nonatomic, strong) NSString *itemId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *contentUrl;

+ (JTProtorolItem *)itemWithName:(NSString *)name link:(NSString *)link;

@end

NS_ASSUME_NONNULL_END
