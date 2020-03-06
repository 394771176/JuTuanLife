//
//  DTTableTitleCell.h
//  DrivingTest
//
//  Created by cheng on 15/11/27.
//  Copyright © 2015年 eclicks. All rights reserved.
//

#import "DTTableCustomCell.h"

@interface DTTableTitleCell : DTTableCustomCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSString *title;

- (void)setTitleColor:(UIColor *)color;
- (void)setTitleFontSize:(CGFloat)size;
- (void)setTitleColor:(UIColor *)color withFontSize:(CGFloat)size;
- (void)setTitleColorString:(NSString *)colorString withFontSize:(CGFloat)size;

- (void)setLabelTop:(CGFloat)top;//固定top, height自适应
- (void)setLabelBottom:(CGFloat)bottom;//固定bottom, height自适应
- (void)setHorizontalGap:(CGFloat)gap;

@end
