//
//  JTDataManager.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/4.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JTDataManager : NSObject

@property (nonatomic, strong) NSDictionary *baseConfig;
@property (nonatomic, strong) NSDictionary *shareDict;

SHARED_INSTANCE_H

//用户数据，基础配置关
+ (void)setupManager;

- (DTShareItem *)shareItem;

@end
