//
//  JTMessageListCell.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/8.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTMessageListCell.h"

@interface JTMessageListCell () {
    UIImageView *_bodyView;
    UILabel *_dateLabel;
    DTBadgeView *_badgeView;
}

@end

@implementation JTMessageListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.height = self.contentView.height = 100;
        
        //0,3 6,3  27 * 27
        UIImage *image = [[UIImage imageNamed:@"login_protorol_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(13, 13, 13, 13)];
        
        UICREATEImageTo(_bodyView, UIImageView, 14, 0, self.contentView.width - 14 * 2, self.contentView.height - 13, AAWH, CCFill, image, self.contentView);
        [self.contentView sendSubviewToBack:_bodyView];
        
        self.titleLabel.frame = RECT(2+16, 0, _bodyView.width - 120, 42);
        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.titleLabel removeFromSuperview];
        [_bodyView addSubview:self.titleLabel];
        
        UICREATELabel2To(_dateLabel, UILabel, _bodyView.width / 2, 0, _bodyView.width /2 - 16 - 3, self.titleLabel.height, AAW, TTRight, nil, @"12", @"999999", _bodyView);
        
        _badgeView = [[DTBadgeView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
        _badgeView.onlyDot = YES;
        _badgeView.origin = CGPointMake(_dateLabel.right, _dateLabel.centerY - 8 - _badgeView.height+2);
        _badgeView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [_bodyView addSubview:_badgeView];
        
        self.contentLabel.frame = RECT(self.titleLabel.left, 42, _bodyView.width - self.titleLabel.left * 2, _bodyView.height - 42 - 18);
        self.contentLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentLabel removeFromSuperview];
        [_bodyView addSubview:self.contentLabel];
        
        [self setTitleColorString:@"999999" withFontSize:13];
        [self setContentColorString:@"333333" withFontSize:15];
        
        [self setSelectionStyleClear];
        
//        [self showSubView];
    }
    return self;
}

- (void)setItem:(JTMessageItem *)item
{
    _item = item;
    if (item.itemId > _lastReadMsgId && _lastReadMsgId >= 0) {
        //未读 红底
//        UIImage *image = [[UIImage imageNamed:@"message_center_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(13, 13, 13, 13)];
//        _bodyView.image = image;
        _badgeView.badge = 1;
    } else {
        //已读 白底
//        UIImage *image = [[UIImage imageNamed:@"login_protorol_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(13, 13, 13, 13)];
//        _bodyView.image = image;
        _badgeView.badge = 0;
    }
//    self.textLabel.text = item.content;
//    self.textLabel.numberOfLines = 0;
    [self setTitle:item.title];
    [self.contentLabel setText:item.content withLineSpace:4];
    _dateLabel.text = [NSDate autoDayOrHourMinStr:item.createTime];
}

+ (CGFloat)cellHeightWithItem:(JTMessageItem *)item tableView:(UITableView *)tableView
{
//    CGFloat height = [item.content sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(tableView.width - 13 * 2 - 19 * 2, FLT_MAX)].height;
    NSString *text = item.content;
    CGFloat height = 10;
    if (text.length) {
//        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:item.content];
//        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//        [paragraphStyle setLineSpacing:4.f];
//        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
//        height = [attributedString boundingRectWithSize:CGSizeMake(tableView.width - 13 * 2 - 19 * 2, FLT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:NULL].size.height;
        
        height = [text sizeWithWidth:tableView.width - 14 * 2 - 18 * 2 withFont:[UIFont systemFontOfSize:15] lineSpace:4.f].height;
    }
    
    
    return 42 + ceil(height) + 18 + 13;
}

@end
