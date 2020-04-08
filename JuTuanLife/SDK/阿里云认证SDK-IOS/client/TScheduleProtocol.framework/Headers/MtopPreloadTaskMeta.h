//
//  MtopPreloadTaskMeta.h
//  TSchedule
//
//  Created by Hansong Liu on 2019/7/8.
//  Copyright © 2019 alibaba. All rights reserved.
//

#import "ScheduleTaskMeta.h"

@interface MtopPreloadTaskMeta : ScheduleTaskMeta

@property (nonatomic, copy) NSString* api;
@property (nonatomic, copy) NSString* version;
@property (nonatomic, copy) NSString* unit;
@property (nonatomic, copy) NSString* requestType;
@property (nonatomic, assign) BOOL needEcode;
@property (nonatomic, assign) NSString* needSession;
@property (nonatomic, assign) NSUInteger timeout;
@property (nonatomic, copy) NSDictionary<NSString*, NSString*>* header;         // headers key => header expression
@property (nonatomic, copy) NSDictionary<NSString*, NSString*>* apiParams;      // params key => param expression
@property (nonatomic, copy) NSDictionary<NSString*, NSString*>* extParams;      // params key => param expression
@property (nonatomic, copy) NSArray<NSString*>* mtopIgnore;                     // params will be ignored by mtop evaluation


// 以下字段用于开放业务的MTOP请求
@property (nonatomic, copy) NSString *openBizCode;
@property (nonatomic, copy) NSString *miniAppkey;
@property (nonatomic, copy) NSString *requestAppkey;
@property (nonatomic, copy) NSString *openBizData;
@property (nonatomic, copy) NSString *customHost;
@property (nonatomic, strong) NSDictionary<NSString*, NSString*> *protocolParams;

@end
