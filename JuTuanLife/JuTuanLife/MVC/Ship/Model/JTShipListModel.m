//
//  JTShipListModel.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/8.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTShipListModel.h"

@implementation JTShipListModel

- (WCDataResult *)loadData
{
    return [JTService sync:[JTUserRequest getShipList]];
}

- (id)parseData:(id)data
{
    if ([NSDictionary validDict:data]) {
        self.teachers = [JTShipItem itemsFromArray:[data objectForKey:@""]];
        return [JTShipItem itemsFromArray:[data objectForKey:@""]];
    }
    return nil;
}

@end
