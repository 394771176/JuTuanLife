//
//  DTTagLabel.h
//  DrivingTest
//
//  Created by cheng on 17/1/16.
//  Copyright © 2017年 eclicks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTTagLabel : UILabel

@property (nonatomic) CGFloat gap;//单侧

- (void)setBackgroundColor:(UIColor *)backgroundColor cornerRadius:(CGFloat)cornerRadius;
- (void)setBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius;

@end
