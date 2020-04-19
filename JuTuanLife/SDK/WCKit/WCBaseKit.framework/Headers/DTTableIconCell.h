//
//  DTTableIconCell.h
//  DrivingTest
//
//  Created by cheng on 2017/10/31.
//  Copyright © 2017年 eclicks. All rights reserved.
//

#import "DTTitleContentCell.h"

@interface DTTableIconCell : DTTitleContentCell

@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, strong) NSString *iconName;
@property (nonatomic, strong) UIImageView *iconView;

- (void)setTitle:(NSString *)title content:(NSString *)content icon:(UIImage *)image;
- (void)setTitle:(NSString *)title content:(NSString *)content iconName:(NSString *)imageName;

- (void)setIconLeft:(CGFloat)left;

@end
