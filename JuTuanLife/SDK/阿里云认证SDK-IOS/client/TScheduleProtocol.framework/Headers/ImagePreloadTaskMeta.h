//
//  ImageLibScheduleTaskMeta.h
//  TSchedule
//
//  Created by Hansong Liu on 2019/7/8.
//  Copyright © 2019 alibaba. All rights reserved.
//

#import "ScheduleTaskMeta.h"

NS_ASSUME_NONNULL_BEGIN

@interface ImagePreloadTaskMeta : ScheduleTaskMeta

@property (nonatomic, copy) NSString* url;
@property (nonatomic, assign) CGSize imageSize;

@end

NS_ASSUME_NONNULL_END
