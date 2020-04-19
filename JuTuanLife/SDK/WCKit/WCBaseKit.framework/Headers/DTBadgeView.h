//
//  DTBadgeView.h
//  DrivingTest
//
//  Created by kent on 10/10/14.
//  Copyright (c) 2014 eclicks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTBadgeView : UIView

@property (nonatomic, strong) UIColor *badgeColor; // redColor by default
@property (nonatomic, assign) NSUInteger badge; // 0 by default
@property (nonatomic, assign) int maxBadge;//default is 99
@property (nonatomic, assign) BOOL onlyDot; // NO by default
@property (nonatomic, assign) CGFloat dotWidth; // 8 by default
@property (nonatomic, assign) CGFloat badgeHeight;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, assign) BOOL translateNum;//default is NO , if yes will ignore maxBadge
@property (nonatomic, strong) NSString *badgeTrail;//默认没有，可以设置，如+， 超过最大值为 99+ 这种

@end
