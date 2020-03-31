//
//  JTMineYaJinCell.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/9.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTMineYaJinCell.h"

@interface JTMineYaJinCell () {
    UILabel *_titleLabel2;
    UILabel *_contentLabel2;
    
    UILabel *_tipLabel;
}

@end

@implementation JTMineYaJinCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.titleLabel setTop:6 andHeight:34];
        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        
        [self.contentLabel setTop:self.titleLabel.top andHeight:self.titleLabel.height];
        self.contentLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        [self setTitle:@"总  押  金："];
        
        [self setContentColor:self.titleLabel.textColor withFont:self.titleLabel.font];
        
        UICREATELabelTo(_titleLabel2, UILabel, self.titleLabel.left, self.titleLabel.bottom, self.titleLabel.width, self.titleLabel.height, (NSInteger)self.titleLabel.autoresizingMask, @"已  扣  除：", self.titleLabel.font, self.titleLabel.textColor, self.contentView);
        
        UICREATELabelTo(_contentLabel2, UILabel, self.contentLabel.left, _titleLabel2.top, self.contentLabel.width, self.contentLabel.height, (NSInteger)self.contentLabel.autoresizingMask, nil, self.contentLabel.font, self.contentLabel.textColor, self.contentView);
        
        UICREATELabelTo(_tipLabel, UILabel, 24, _titleLabel2.bottom + 10, self.contentView.width - 24 - 75, 40, AAW, nil, @"12", @"999999", self.contentView);
        _tipLabel.numberOfLines = 0;
        
        [self setLineStyle:DTCellLineNone];
        
        [self showArrow:YES];
    }
    return self;
}

- (void)setItem:(JTUser *)item
{
    [self setContent:[NSString stringWithFormat:@"%.2f元", item.depositTotal]];
    _contentLabel2.text = [NSString stringWithFormat:@"%.2f元", item.depositPaid];
    
    [_tipLabel setLabelHeightWithString:item.depositTips];
}

+ (CGFloat)cellHeightWithItem:(JTUser *)item tableView:(UITableView *)tableView
{
    CGFloat height = [item.depositTips sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(tableView.width - 24 - 75, FLT_MAX)].height;
    return 6 + 34 + 34 + 10 + height + 18;
}

@end
