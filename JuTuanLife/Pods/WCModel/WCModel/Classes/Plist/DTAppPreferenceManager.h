//
//  DTAppPreference.h
//  DrivingTest
//
//  Created by cheng on 17/3/2.
//  Copyright © 2017年 eclicks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BPAppPreference.h"

#define APP_CONST_PREFERENCE_MANAGER_UPDATE_SUCCESS        @"app.const.preference.manager.update.success"

@interface DTAppPreferenceManager : NSObject

//+ (BPAppPreference *)sharedFileName:(NSString *)fileName;
+ (BPAppPreference *)userSessionAppPreference;
+ (BPAppPreference *)userCityAppPreference;
+ (BPAppPreference *)answerAppPreference;//答题index 标记
+ (BPAppPreference *)courseAppPreference;
+ (BPAppPreference *)favAppPreference;
+ (BPAppPreference *)todayAppPreference;
+ (BPAppPreference *)skillAppPreference;//答题技巧
+ (BPAppPreference *)smartAppPreference;//智能答题

+ (void)clearAppPreferenceOldKey;
+ (void)updateAppPreferenceVersion;

@end

@interface BPAppPreference (DTUpdate)

- (BPAppPreference *)validAppPreference_dt;

- (BOOL)isUpdateSuccess_dt;
- (void)setUpdateSuccess_dt;

- (void)updateValueWithKey_dt:(NSString *)key;
- (void)updateValueWithKeyArray_dt:(NSArray *)keys;
- (void)checkUpdateValueWithKeyArray_dt:(NSArray *)keys;

- (void)clearAllKey;

@end
