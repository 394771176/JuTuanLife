//
//  PreloadService.h
//  TScheduleProtocol
//
//  Created by Hansong Liu on 2019/7/31.
//  Copyright © 2019 alibaba. All rights reserved.
//

#ifndef PreloadService_h
#define PreloadService_h

#import "ScheduleTaskMeta.h"

#import "TScheduleDigestHandler.h"

@protocol PreloadServiceProtocol <NSObject>

@required

/**
 * preload with tasks
 * @param tasks required preload task, such like mtop preload, http preload, webview pre-render
 * @param digestHandler handler of hit/malformed/eliminated events
 */
- (BOOL)preloadWithTasks:(NSString*)bizId tasks:(NSArray<ScheduleTaskMeta*>*)tasks digestHandler:(id<TScheduleDigestHandler>)digestHandler;

/**
 * get preload data by task meta
 * @param taskMeta task meta info(not exactly the same instance when creating preload tasks), and only preload HTTP data can be fetched for now
 * @return wrappered data and status
 *
 {
 "data":"NSData",  // 请求返回的实际数据
 "response": "NSHTTPURLResponse", // 请求的response
 "error":"NSError", // 请求的connectionError
 "timestamp":1234
 }
 */
- (id)getPreloadedData:(ScheduleTaskMeta*)taskMeta;

@end

#ifdef __cplusplus
extern "C" {
#endif // __cplusplus
    
    // default get [PreloadServiceImp sharedInstance]接口来获取，如果没有的话，就返回nil
    id<PreloadServiceProtocol> getDefaultPreloadService(void);
    void setDefaultPreloadService(id<PreloadServiceProtocol> service);
    
#ifdef __cplusplus
}
#endif // __cplusplus

#endif /* PreloadService_h */
