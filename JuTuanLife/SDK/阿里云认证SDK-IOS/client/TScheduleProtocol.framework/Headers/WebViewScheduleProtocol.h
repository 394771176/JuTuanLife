//
//  WebViewScheduleProtocol.h
//  TScheduleProtocol
//
//  Created by Hansong Liu on 2019/7/5.
//  Copyright © 2019 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PreloadConfig.h"

@protocol WebViewScheduleProtocol <NSObject>

@required

/**
 * Preload html content with given url, and initialized web view instance will be cached for further usage
 * The following works will be done during preload:
 * 1, create webview instance,
 * 2, load url and
 * 3, notify to webview container once the webview become visiable
 * ***important: html content shuold not trigger alert/dialog
 *
 * @param url the exact full url
 * @param preloadConfig config for ignored keys and digest handlers
 */
- (void)preloadWithUrl:(NSString*)url preloadConfig:(PreloadConfig*)preloadConfig;

/**
 * clear all preloaed webview instances
 */
- (void)clearPreloadedInstances;

/**
 * remove preloaded webview instance by url
 * @param url the exact full url
 */
- (void)removePreloadedInstance:(NSString*)url;


@end

#ifdef __cplusplus
extern "C" {
#endif // __cplusplus
    
    id<WebViewScheduleProtocol> getWebViewPreloadService(void);
    void setWebViewPreloadService(id<WebViewScheduleProtocol> service);
    
#ifdef __cplusplus
}
#endif // __cplusplus
