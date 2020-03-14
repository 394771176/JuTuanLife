//
//  JTShipListCell.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/8.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTShipListCell.h"
#import "JTUserTeamView.h"
#import "JTUserHeaderView.h"

@interface JTShipListCell () {
    JTUserHeaderView *_headerView;
    UILabel *_dateLabel;
    UILabel *_shipNumLabel;
}

@end

@implementation JTShipListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UICREATETo(_headerView, JTUserHeaderView, 20, 16, self.contentView.width - 40, 60, AAW, self.contentView);
        [_headerView setNameFont:[UIFont systemFontOfSize:16]];
        
        UICREATELabelTo(_dateLabel, UILabel, self.contentView.width - 120 - 20, _headerView.nameLabel.top + _headerView.top, 120, _headerView.nameLabel.height, AAL, nil, @"12", @"999999", self.contentView);
        _dateLabel.textAlignment = NSTextAlignmentRight;
        
        UICREATELabelTo(_shipNumLabel, UILabel, _dateLabel.left, _headerView.teamView.top + _headerView.top, _dateLabel.width, _headerView.teamView.height, AAL, nil, @"12", @"999999", self.contentView);
        _shipNumLabel.textAlignment = NSTextAlignmentRight;
    }
    return self;
}

- (void)setItem:(JTShipItem *)item
{
    _item = item;
    
    _headerView.item = item;

    _dateLabel.text = @"2020-03-12 13:14";
    _shipNumLabel.text = @"名下徒弟40人";
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
    return 92;
}

@end
