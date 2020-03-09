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

#define APP_DEBUG               ([JTCommon APPDebug])

#pragma mark - server

#define SERVER(_pro, _test)     ([JTCommon serverForPro:_pro test:_test])

#define APP_JT_SERVER           SERVER(@"http://api-daily.jutuanlife.com/api", @"http://api-daily.jutuanlife.com/api")

#define APP_JT_SIGN             @"1234567"


#pragma mark - color

#define APP_JT_BLUE_STRING              @"#137FFE"
#define APP_JT_BLUE_COLOR               COLORS(APP_JT_BLUE_STRING)

#define APP_JT_BTN_BLUE                 @"#107CF8"

#define APP_JT_GRAY_STRING              @"#CFCFCF"
#define APP_JT_GRAY_COLOR               COLORS(APP_JT_GRAY_STRING)

#define APP_JT_GRAY_BGSTRING              @"#F9F9F9"
#define APP_JT_GRAY_BGCOLOR               COLORS(APP_JT_GRAY_BGSTRING)

#endif /* JTConstants_h */
