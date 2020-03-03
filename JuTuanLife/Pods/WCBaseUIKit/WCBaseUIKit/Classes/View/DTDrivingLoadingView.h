//
//  DTDrivingLoadingView.h
//  DrivingTest
//
//  Created by kent on 15/3/12.
//  Copyright (c) 2015年 eclicks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCUICommon.h"

@interface DTDrivingLoadingView : UIView

+ (instancetype)loadingInView:(UIView *)view;

- (void)startAnimating;
- (void)stopAnimating;
- (BOOL)isAnimating;

- (void)setOffsetY:(CGFloat)offsetY;

@end
