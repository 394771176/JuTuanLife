//
//  DTTableTitleCell.m
//  DrivingTest
//
//  Created by cheng on 15/11/27.
//  Copyright © 2015年 eclicks. All rights reserved.
//

#import "DTTableTitleCell.h"

@implementation DTTableTitleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, self.contentView.width-24, self.contentView.height)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:_titleLabel];
        
        [self setSeparatorLineWithLeft:12.f andRight:0.f];
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    _titleLabel.text = title;
}

- (void)setTitleColor:(UIColor *)color
{
    _titleLabel.textColor = color;
}

- (void)setTitleFontSize:(CGFloat)size
{
    _titleLabel.font = [UIFont systemFontOfSize:size];
}

- (void)setTitleColor:(UIColor *)color withFontSize:(CGFloat)size
{
    [self setTitleColor:color];
    [self setTitleFontSize:size];
}

- (void)setTitleColorString:(NSString *)colorString withFontSize:(CGFloat)size
{
    [self setTitleColor:[UIColor colorWithHexString:colorString] withFontSize:size];
}

- (void)setLabelTop:(CGFloat)top
{
    if (top >= self.height) {
        self.height = self.contentView.height = top + 20;
    }
    _titleLabel.frame = CGRectMake(_titleLabel.left, top, _titleLabel.width, self.contentView.height - top);
}

- (void)setLabelBottom:(CGFloat)bottom
{
    if (bottom + _titleLabel.top >= self.height) {
        self.height = self.contentView.height = bottom + _titleLabel.top + 20;
    }
    _titleLabel.frame = CGRectMake(_titleLabel.left, _titleLabel.top, _titleLabel.width, self.contentView.height - _titleLabel.top - bottom);
}

- (void)setHorizontalGap:(CGFloat)gap
{
    _titleLabel.frame = CGRectMake(gap, _titleLabel.top, self.contentView.width - gap * 2, _titleLabel.height);
}

+ (CGFloat)cellHeightWithItem:(id)item tableView:(UITableView *)tableView
{
    return 35;
}

@end
