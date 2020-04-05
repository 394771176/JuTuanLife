//
//  FFUMengManager.h
//  FFStory
//
//  Created by PageZhang on 16/3/11.
//  Copyright © 2016年 Chelun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFUMengManager : NSObject

// 注册友盟
+ (void)configWithAppKey:(NSString *)appKey channel:(NSString *)channel;

// 事件统计
+ (void)event:(NSString *)event;
+ (void)event:(NSString *)event title:(NSString *)title;
+ (void)event:(NSString *)event title:(NSString *)title trail:(NSString *)trail;

+ (void)beginPage:(NSString *)pageName;
+ (void)endPage:(NSString *)pageName;

@end
