//
//  JTConstants.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/3.
//  Copyright © 2020 cheng. All rights reserved.
//

#ifndef JTConstants_h
#define JTConstants_h

#pragma mark - server

#define APP_SERVER_DEBUG   1

#define APP_DEBUG          (![JTCommon isServerPro])

#define SERVER(_pro, _test)  ([JTCommon serverForPro:_pro test:_test])

#define APP_JT_SERVER       SERVER(@"http://api-daily.jutuanlife.com/api", @"http://api-daily.jutuanlife.com/api")

#define APP_JT_SIGN         @"1234567"


#endif /* JTConstants_h */
