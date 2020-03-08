//
//  DTTitleContentCell.h
//  DrivingTest
//
//  Created by cheng on 15/11/27.
//  Copyright © 2015年 eclicks. All rights reserved.
//

#import "DTTableTitleCell.h"

@interface DTTitleContentCell : DTTableTitleCell

@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) NSString *content;
@property (nonatomic) BOOL disableContentSize;//禁用cotnent

- (void)setContentColor:(UIColor *)color;
- (void)setContentFontSize:(CGFloat)size;
- (void)setContentColor:(UIColor *)color withFont:(UIFont *)font;
- (void)setContentColor:(UIColor *)color withFontSize:(CGFloat)size;
- (void)setContentColorString:(NSString *)colorString withFontSize:(CGFloat)size;

- (void)setTitle:(NSString *)title content:(NSString *)content;

@end
