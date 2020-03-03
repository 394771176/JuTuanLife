//
//  DTEnrollProgressView.h
//  DrivingTest
//
//  Created by PageZhang on 16/5/9.
//  Copyright © 2016年 eclicks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTEnrollProgressView : UIView

@property (nonatomic, assign) CGFloat progress;

// 进行一个动画
- (void)startAnimating;
- (void)stopAnimating;
- (BOOL)isAnimating;


@end
