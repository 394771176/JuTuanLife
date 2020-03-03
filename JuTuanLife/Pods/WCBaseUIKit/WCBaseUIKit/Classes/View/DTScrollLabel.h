//
//  DTScrollLabel.h
//  DrivingTest
//
//  Created by cheng on 2017/10/24.
//  Copyright © 2017年 eclicks. All rights reserved.
//

#import <UIKit/UIKit.h>

// 单行， 长度超限，滚动显示
@interface DTScrollLabel : UILabel

@property (nonatomic) CGFloat scrollGap;//default is 32;

- (void)stopAnimation;

@end
