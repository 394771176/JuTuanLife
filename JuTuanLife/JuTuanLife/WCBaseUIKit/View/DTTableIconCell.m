//
//  DTTableIconCell.m
//  DrivingTest
//
//  Created by cheng on 2017/10/31.
//  Copyright © 2017年 eclicks. All rights reserved.
//

#import "DTTableIconCell.h"

@interface DTTableIconCell () {
    
}

@end

@implementation DTTableIconCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 0, 20, self.contentView.height)];
        _iconView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _iconView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_iconView];
        
        self.titleLabel.left = _iconView.right + 10;
        [self setTitleColor:[UIColor colorWithString:@"3f3f3f"]];
        [self setContentColor:[UIColor colorWithString:@"b0b0b0"]];
        
        self.lineStyle = DTCellLineBottom;
    }
    return self;
}

- (void)setIconLeft:(CGFloat)left
{
    _iconView.left = left;
    self.titleLabel.left = _iconView.right + 10;
}

- (void)setIcon:(UIImage *)icon
{
    _icon = icon;
    [_iconView setImage:icon];
}

- (void)setIconName:(NSString *)iconName
{
    _iconName = iconName;
    if (iconName) {
        [self setIcon:[UIImage imageNamed:iconName]];
    } else {
        [self setIcon:nil];
    }
}

- (void)setTitle:(NSString *)title content:(NSString *)content icon:(UIImage *)image
{
    [self setTitle:title content:content];
    [self setIcon:image];
}

- (void)setTitle:(NSString *)title content:(NSString *)content iconName:(NSString *)imageName
{
    [self setTitle:title content:content];
    [self setIconName:imageName];
}

- (void)setItem:(DTTitleIconItem *)item
{
    [self setTitle:item.title content:nil icon:item.icon];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat left = self.titleLabel.left+[self.titleLabel getTextWidth]+10;
    if (left+[self.contentLabel getTextWidth] > self.contentLabel.right) {
        self.contentLabel.frame = CGRectMake(left, self.contentLabel.top, self.contentLabel.right-left, self.contentLabel.height);
    }
}


+ (CGFloat)cellHeightWithItem:(id)item tableView:(UITableView *)tableView
{
    return 45;
}


@end
