//
//  RPSDK+Customize.h
//  ALRealIdentity
//
//  Created by  Hank Zhang on 2020/1/30.
//  Copyright © 2020 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RPSDKInterface.h"

NS_ASSUME_NONNULL_BEGIN

@interface RPSDK (Customize)

/**
 是否打开页面弹窗动画，默认为打开状态。
 */
@property (class, nonatomic, assign) BOOL isPresentationAnimationEnabled;

@end

NS_ASSUME_NONNULL_END
