//
//  JTConstants.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/3.
//  Copyright © 2020 cheng. All rights reserved.
//

#ifndef JTConstants_h
#define JTConstants_h

#define APP_CONST_DEBUG         1
#define APP_SERVER_DEBUG        1

#define APP_PROJECT_NAME         @"JuTuiBang"

#define APP_DEBUG               ([JTCommon APPDebug])

#pragma mark - server

#define SERVER(_pro, _test)     ([JTCommon serverForPro:_pro test:_test])

#define APP_JT_SERVER           SERVER(@"http://api-daily.jutuanlife.com/api", @"http://api-daily.jutuanlife.com/api")
#define APP_JT_SERVER_UPLOAD    SERVER(@"http://api-daily.jutuanlife.com/file", @"http://api-daily.jutuanlife.com/file")

#define APP_JT_SIGN             @"ilwhaGnGKdFxY1cK"


#pragma mark - url

#define APP_DOWNLOAD_URL         @""


#pragma mark - color

#define APP_JT_BTN_BG_BLUE              @"#137FFE"
#define APP_JT_BTN_BG_RED               @"#FF6464"
#define APP_JT_BTN_BG_GRAY              @"#CFCFCF"

#define APP_JT_BTN_TITLE_BLUE                 @"#107CF8"


#pragma mark - Notification KEY

#define JTUIApplicationWillEnterForegroundNotification  @"JT_UIApplicationWillEnterForegroundNotification"
#define JTUIApplicationDidEnterBackgroundNotification   @"JT_UIApplicationDidEnterBackgroundNotification"

#endif /* JTConstants_h */
