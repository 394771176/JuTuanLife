//
//  JTMessageListModel.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/8.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTMessageListModel.h"

@implementation JTMessageListModel

- (NSString *)cacheKey
{
    return @"JTMessageListModel_cacheKey";
}

- (WCDataResult *)loadData
{
    WCDataResult *result = [JTService sync:[JTUserRequest user_msg_list:self.pos pageSize:self.fetchLimit]];
    
    return [self cacheResult:result];
}

- (id)parseData:(id)data
{
    [super parseData:data];
    if (self.isReload || self.isLoadCache) {
        if ([data objectForKey:@"lastReadMsgId"]) {
            self.lastReadMsgId = [data integerForKey:@"lastReadMsgId"];
        } else {
            self.lastReadMsgId = -1;
        }
    }
    return [JTMessageItem itemsFromDict:data forKey:@"messages"];
}

@end
