//
//  DTControl.h
//  DrivingTest
//
//  Created by cheng on 15/11/3.
//  Copyright © 2015年 eclicks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCUICommon.h"

@interface DTControl : UIControl

@property (nonatomic,assign) BOOL disableAlpha;

- (void)downAction;
- (void)upAction;

- (void)addTarget:(nullable id)target action:(nullable SEL)action;

@end
