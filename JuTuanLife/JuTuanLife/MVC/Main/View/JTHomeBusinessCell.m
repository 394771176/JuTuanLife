//
//  JTHomeBusinessCell.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/14.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTHomeBusinessCell.h"

@interface JTHomeBusinessCell () {
    UILabel *_fenrunLabel;
}

@end

@implementation JTHomeBusinessCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.height = self.contentView.height = 56 + 24;
        
        self.iconView.frame = CGRectMake(12, 12, 56, 56);
        self.iconView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        self.iconView.cornerRadius = 4;
        
        self.titleLabel.frame = CGRectMake(self.iconView.right + 12, 18, self.contentView.width - self.iconView.right - 24, 25);
        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        self.contentLabel.frame = CGRectMake(self.titleLabel.left, self.titleLabel.bottom, self.titleLabel.width, self.titleLabel.height);
        self.contentLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.contentLabel.textAlignment = NSTextAlignmentLeft;
    }
    return self;
}

- (void)setItem:(DTTitleIconItem *)item
{
    if ([item isKindOfClass:JTBusinessItem.class]) {
        [self setBusinessItem:(id)item];
    } else if ([item isKindOfClass:JTFenRunOverItem.class]) {
        JTFenRunOverItem *fenrun = (id)item;
        [self setBusinessItem:fenrun.business];
        [self setContent:[NSString stringWithFormat:@"业绩总金额：%.2f", fenrun.totalOrderAmt]];
        if (!_fenrunLabel) {
            UICREATELabel2To(_fenrunLabel, UILabel, self.titleLabel.left, 0, self.contentView.width - self.titleLabel.left - 12, self.contentView.height, AAWH, TTRight, nil, @"20", @"333333", self.contentView);
        }
        _fenrunLabel.text = [NSString stringWithFormat:@"%.2f", fenrun.myCommAmt];
    } else {
        [super setItem:item];
    }
}

- (void)setBusinessItem:(JTBusinessItem *)bitem
{
    [self.iconView setImageWithURLStr:bitem.icon placeholderImage:[UIImage imageWithColorString:@"e9e9e9" cornerRadius:4]];
    [self setTitle:bitem.name content:bitem.slogan];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)cellHeightWithItem:(id)item tableView:(UITableView *)tableView
{
    return 80;
}

@end
