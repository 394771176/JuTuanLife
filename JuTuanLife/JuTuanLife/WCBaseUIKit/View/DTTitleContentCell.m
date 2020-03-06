//
//  DTTitleContentCell.m
//  DrivingTest
//
//  Created by cheng on 15/11/27.
//  Copyright © 2015年 eclicks. All rights reserved.
//

#import "DTTitleContentCell.h"

@implementation DTTitleContentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.contentView.width-15-15, self.contentView.height)];
        _contentLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.textColor = [UIColor colorWithHexString:@"4c4c4c" alpha:1.0];
        _contentLabel.font = [UIFont systemFontOfSize:12];
        _contentLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_contentLabel];
    }
    return self;
}

- (void)setContent:(NSString *)content
{
    _content = content;
    _contentLabel.text = content;
    if (!_disableContentSize) {
        CGFloat left = self.titleLabel.left+[self.titleLabel getTextWidth]+10;
        if (left+[_contentLabel getTextWidth]>_contentLabel.right) {
            _contentLabel.frame = CGRectMake(left, _contentLabel.top, _contentLabel.right-left, _contentLabel.height);
        }
    }
}

- (void)setContentColor:(UIColor *)color
{
    _contentLabel.textColor = color;
}

- (void)setContentFontSize:(CGFloat)size
{
    _contentLabel.font = [UIFont systemFontOfSize:size];
}

- (void)setContentColor:(UIColor *)color withFontSize:(CGFloat)size
{
    [self setContentColor:color];
    [self setContentFontSize:size];
}

- (void)setContentColorString:(NSString *)colorString withFontSize:(CGFloat)size
{
    [self setContentColor:[UIColor colorWithHexString:colorString] withFontSize:size];
}

- (void)setTitle:(NSString *)title content:(NSString *)content
{
    self.title = title;
    self.content = content;
}

- (void)showArrow:(BOOL)show
{
    [super showArrow:show];
    _contentLabel.width = self.contentView.width-_contentLabel.left-(show?28:15);
}

@end
