//
//  JTCommon.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/4.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JTMainController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JTCommon : WCControllerUtil

+ (void)setupAppStyle;

+ (void)setMainController:(JTMainController *)vc;
+ (JTMainController *)mainController;

+ (void)resetRootController;

+ (BOOL)APPDebug;
+ (BOOL)isServerPro;
+ (NSString *)serverForPro:(NSString *)pro test:(NSString *)test;

@end

NS_ASSUME_NONNULL_END
