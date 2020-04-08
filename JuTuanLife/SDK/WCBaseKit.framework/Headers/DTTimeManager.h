//
//  DTTimeManager.h
//  DrivingTest
//
//  Created by cheng on 2017/11/6.
//  Copyright © 2017年 eclicks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTTimeManager : NSObject

+ (void)startTime;

+ (void)logTime;

+ (void)logTimeWith:(NSString *)event;

+ (void)endTime;


@end
