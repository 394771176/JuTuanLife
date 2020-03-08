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
        
        [self setTitle:@"总押金："];
        
        [self setContentColor:self.titleLabel.textColor withFont:self.titleLabel.font];
        
        UICREATELabelTo(_titleLabel2, UILabel, self.titleLabel.left, self.titleLabel.bottom, self.titleLabel.width, self.titleLabel.height, (NSInteger)self.titleLabel.autoresizingMask, @"已扣除：", self.titleLabel.font, self.titleLabel.textColor, self.contentView);
        
        UICREATELabelTo(_contentLabel2, UILabel, self.contentLabel.left, _titleLabel2.top, self.contentLabel.width, self.contentLabel.height, (NSInteger)self.contentLabel.autoresizingMask, nil, self.contentLabel.font, self.contentLabel.textColor, self.contentView);
        
        UICREATELabelTo(_tipLabel, UILabel, 24, _titleLabel2.bottom + 10, self.contentView.width - 24 - 20, 40, AAW, nil, @"12", @"999999", self.contentView);
        _tipLabel.numberOfLines = 0;
        
        [self setSelectionStyleNoneLine];
    }
    return self;
}

- (void)setItem:(JTUser *)item
{
    [self setContent:@"1000元"];
    _contentLabel2.text = @"980.34元";
    
    [_tipLabel setLabelHeightWithString:@"总押金为从每个月分润金额内扣除，按每月总分润的5%扣除，"
     "扣到1000元结束离职后，退还押金。"];
}

+ (CGFloat)cellHeightWithItem:(JTUser *)item tableView:(UITableView *)tableView
{
    CGFloat height = [item.yajinTip sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(tableView.width - 24 - 20, FLT_MAX)].height;
    if (APP_DEBUG) {
        height = [@"总押金为从每个月分润金额内扣除，按每月总分润的5%扣除，"
         "扣到1000元结束离职后，退还押金。" sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(tableView.width - 24 - 20, FLT_MAX)].height;
    }
    return 6 + 34 + 34 + 10 + height + 18;
}

@end
