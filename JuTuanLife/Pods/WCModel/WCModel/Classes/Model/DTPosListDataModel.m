//
//  DTPosListDataModel.m
//  DrivingTest
//
//  Created by Hunter Huang on 3/14/14.
//  Copyright (c) 2014 eclicks. All rights reserved.
//

#import "DTPosListDataModel.h"
#import <WCCategory/WCCategory.h>

@implementation DTPosListDataModel

- (void)resetReloadStatus
{
    [super resetReloadStatus];
    _pos = nil;
}

- (id)parseData:(id)data
{
    if ([NSDictionary validDict:data]) {
        _pos = [data stringForKey:@"pos"];
    }
    return data;
}

@end
