//
//  DTStrokeLabel.h
//  DrivingTest
//
//  Created by cheng on 2017/9/20.
//  Copyright © 2017年 eclicks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTStrokeLabel : UILabel

@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic, strong) NSString *strokeColorStr;

@property (nonatomic, strong) NSNumber *strokeWidth;

@end
