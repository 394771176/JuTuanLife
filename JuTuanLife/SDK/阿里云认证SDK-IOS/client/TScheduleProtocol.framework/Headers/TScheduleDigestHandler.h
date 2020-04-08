//
//  TScheduleDigestHandler.h
//  TScheduleProtocol
//
//  Created by Hansong Liu on 2019/7/16.
//  Copyright © 2019 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol TScheduleDigestHandler <NSObject>

@required

/**
 * callback when creating preload cache
 * @param cachedUrl url to be preloaded
 * @param bizType H5/Mtop/...
 * @param isSuccess is creation success
 * @param error error message if any
 */
- (void)onPreloadTaskCreation:(NSString*)bizType url:(NSString*)cachedUrl isSuccess:(BOOL)isSuccess error:(NSError*)error;

/**
 * preloaded cache got hit
 * @param bizType H5/Mtop/...
 * @param cachedUrl cached url
 * @param targetUrl the actual target url, maybe different from cached URL, because some keys maybe ignored
 */
- (void)onPreloadedCacheHit:(NSString*)bizType cachedUrl:(NSString*)cachedUrl targetUrl:(NSString*)targetUrl;

/**
 * preloaded cache not exists(different from malformed cache)
 * @param bizType H5/Mtop/...
 * @param targetUrl the actual target url
 */
- (void)onPreloadedCacheMiss:(NSString*)bizType targetUrl:(NSString*)targetUrl;

/**
 * preload cache url malformed
 * @param cachedUrl cached url
 * @param targetUrl the actual target url
 * @param error error message, maybe nil
 */
- (void)onPreloadedCacheMalformed:(NSString*)bizType cachedUrl:(NSString*)cachedUrl targetUrl:(NSString*)targetUrl error:(NSError*)error;

/**
 * preload cache got eliminated
 * @param bizType H5/Mtop/...
 * @param cachedUrl cached url
 * @param error error message, maybe nil
 */
- (void)onPreloadedCacheEliminated:(NSString*)bizType cachedUrl:(NSString*)cachedUrl error:(NSError*)error;

@end


#ifdef __cplusplus
extern "C" {
#endif // __cplusplus
    
    id<TScheduleDigestHandler> getGlobalDigestService(void);
    void setGlobalDigestService(id<TScheduleDigestHandler> service);
    
#ifdef __cplusplus
}
#endif // __cplusplus
