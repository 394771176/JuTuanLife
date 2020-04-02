//
//  JTUserYajinListCell.m
//  JuTuanLife
//
//  Created by cheng on 2020/4/2.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTUserYajinListCell.h"

@interface JTUserYajinListCell () {
    UILabel *_dateLabel;
    UILabel *_fenrunLabel;
    UILabel *_yajinLabel;
}

@end

@implementation JTUserYajinListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UICREATELabel2To(_dateLabel, UILabel, 24, 0, SCALE_SCREEN_SIZE(64+60), self.contentView.height, AAWH|AAR, TTLeft, nil, @"16", @"111111", self.contentView);
        
        UICREATELabel2To(_fenrunLabel, UILabel, _dateLabel.right, _dateLabel.top, SCALE_SCREEN_SIZE(80+60), _dateLabel.height, AALR|AAWH, TTLeft, nil, @"16", @"111111", self.contentView);
        
        UICREATELabel2To(_yajinLabel, UILabel, _fenrunLabel.right, _dateLabel.top, self.contentView.width - _fenrunLabel.right - 5, _dateLabel.height, AAL|AAWH, TTLeft, nil, @"16", @"111111", self.contentView);
        
        [self setSelectionStyleNoneLine];
    }
    return self;
}

- (void)setIsTitle:(BOOL)isTitle
{
    _isTitle = isTitle;
    if (isTitle) {
        _dateLabel.text = @"扣除时间";
        [_dateLabel setTextColorString:@"333333"];
        
        _fenrunLabel.text = @"当月总分润";
        [_fenrunLabel setTextColorString:@"333333"];
        
        _yajinLabel.text = @"扣除金额";
        [_yajinLabel setTextColorString:@"333333"];
    } else {
        [_dateLabel setTextColorString:@"111111"];
        
        [_fenrunLabel setTextColorString:@"111111"];
        
        [_yajinLabel setTextColorString:@"111111"];
    }
}

- (void)setItem:(JTUserYajin *)item
{
    _item = item;
    _dateLabel.text = item.paidTime;
    _fenrunLabel.text = [NSString stringWithFormat:@"%.2f", item.comAmt];
    _yajinLabel.text = [NSString stringWithFormat:@"%.2f", item.depositPaid];
}

+ (CGFloat)cellHeightWithItem:(id)item tableView:(UITableView *)tableView
{
    return 50;
}

@end
