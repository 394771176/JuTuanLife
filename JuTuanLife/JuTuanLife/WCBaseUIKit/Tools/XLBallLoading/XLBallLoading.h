//
//  XLBallLoading.h
//  XLBallLoadingDemo
//
//  Created by MengXianLiang on 2017/3/21.
//  Copyright © 2017年 MengXianLiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLBallLoading : UIView

@property (nonatomic, assign) CGFloat duration;
@property (nonatomic, assign) CGFloat ballDistance;
@property (nonatomic, assign) CGFloat ballScale;
@property (nonatomic, assign) CGSize ballContainerSize;

@property (nonatomic, assign) CGFloat minDuration;//default is 0

@property (nonatomic, assign) CGFloat offsetY;

-(void)start;

-(void)stop;

+(id)showInView:(UIView*)view;
+(id)showInView:(UIView*)view minDuration:(CGFloat)minDuration;

+(void)hideInView:(UIView*)view;
+(void)hideInViewImmediately:(UIView*)view;

@end
