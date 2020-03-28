//
//  JTBusinessFenrunHeader.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/28.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTBusinessFenrunHeaderCell.h"

@interface JTBusinessFenrunHeaderCell () {
    UILabel *_dateLabel;
    UILabel *_tipLabel;
}

@end

@implementation JTBusinessFenrunHeaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.height = self.contentView.height = 103;
        
        UICREATELabel2To(_dateLabel, UILabel, 10, 10, self.width - 20, 36, AAW, TTCenter, nil, @"18", @"333333", self);
        
        UICREATELabel2To(_tipLabel, UILabel, 50, 49, self.contentView.width - 50 * 2, self.contentView.height - 49 - 16, AAW, TTCenter, nil, @"15", @"333333", self);
        _tipLabel.numberOfLines = 0;
        
        [self setSelectionStyleClear];
    }
    return self;
}

- (void)setTitleItem:(JTBusinessFenRunTitleItem *)titleItem
{
    _titleItem = titleItem;
    _dateLabel.text = [titleItem dateStr];
    _tipLabel.text = titleItem.explanation;
}

+ (CGFloat)cellHeightWithItem:(JTBusinessFenRunTitleItem *)item tableView:(UITableView *)tableView
{
    CGFloat height = [item.explanation sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(tableView.width - 100, FLT_MAX)].height;
    if (height > 1 && height < 24) {
        height = 24;
    }
    return height + 49 + 16;
}

@end
