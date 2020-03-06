//
//  DTTableContentCell.m
//  DrivingTest
//
//  Created by cheng on 15/11/27.
//  Copyright © 2015年 eclicks. All rights reserved.
//

#import "DTTableContentCell.h"

@implementation DTTableContentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.textColor = [UIColor colorWithHexString:@"6b6b6b"];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return self;
}

+ (CGFloat)cellHeightWithItem:(NSString *)item tableView:(UITableView *)tableView
{
    return [self cellHeightWithItem:item tableView:tableView withFont:[UIFont systemFontOfSize:15]];
}

+ (CGFloat)cellHeightWithItem:(NSString *)item tableView:(UITableView *)tableView withFont:(UIFont *)font
{
    return [self cellHeightWithItem:item tableView:tableView withFont:font gapH:12 minH:44];
}

+ (CGFloat)cellHeightWithItem:(NSString *)item tableView:(UITableView *)tableView withFont:(UIFont *)font gapH:(CGFloat)gapH minH:(CGFloat)minH
{
    CGFloat height = [item sizeWithFont:font constrainedToSize:CGSizeMake(tableView.width-30, CGFLOAT_MAX)].height;
    return MAX(height + gapH * 2, minH);
}

+ (CGFloat)cellHeightWithAttrString:(NSAttributedString *)item tableView:(UITableView *)tableView
{
    CGFloat height = [item boundingRectWithSize:CGSizeMake(tableView.width-30, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:NULL].size.height;
    return MAX(height+24, 44);
}

@end
