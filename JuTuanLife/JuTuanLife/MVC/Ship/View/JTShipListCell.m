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
    UILabel *_fenrunLabel;
    
    UIButton *_phoneBtn;
}

@end

@implementation JTShipListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UICREATETo(_headerView, JTUserHeaderView, 20, 16, self.contentView.width - 40, 60, AAW, self.contentView);
        [_headerView setNameFont:[UIFont systemFontOfSize:16]];
        
        self.cellType = JTShipCellTypeShip;
    }
    return self;
}

- (void)setItem:(JTShipItem *)item
{
    _item = item;
    
    _headerView.item = item;

    if (_cellType == JTShipCellTypeFenrun) {
        _headerView.relationType = item.relationType;
        [_fenrunLabel setText:[NSString stringWithFormat:@"%.2f", item.commAmt]];
    } else {
        _dateLabel.text = [NSDate dayHourMinStr:item.relatedTime];
        _shipNumLabel.left = _headerView.left + [_headerView getTeamsViewRight] + 12;
        _shipNumLabel.text = [NSString stringWithFormat:@"名下徒弟%zd人", item.apprentices];
    }
}

- (void)setCellType:(JTShipCellType)cellType
{
    _cellType = cellType;
    switch (cellType) {
        case JTShipCellTypeShip:
        {
            if (!_phoneBtn) {
                UICREATELabelTo(_dateLabel, UILabel, self.contentView.width - 120 - 20, _headerView.nameLabel.top + _headerView.top, 120, _headerView.nameLabel.height, AAL, nil, @"12", @"999999", self.contentView);
                _dateLabel.textAlignment = NSTextAlignmentRight;
                
                UICREATELabelTo(_shipNumLabel, UILabel, [_headerView getTeamsViewRight], _headerView.teamView.top + _headerView.top, 200, _headerView.teamView.height, AAL, nil, @"12", @"999999", self.contentView);
                
                UICREATEBtnImgTo(_phoneBtn, UIButton, self.contentView.width - 40 - 12, _shipNumLabel.top - 8 - 2, 40, 40, AAL, @"jt_ship_phone", self, @selector(phoneAction), self.contentView);
            }
            _fenrunLabel.hidden = YES;
            _phoneBtn.hidden = NO;
            _dateLabel.hidden = _shipNumLabel.hidden = NO;
        }
            break;
        case JTShipCellTypeFenrun:
        {
            if (!_fenrunLabel) {
                UICREATELabel2To(_fenrunLabel, UILabel, self.contentView.width - 160, 0, 120, self.contentView.height, AAWH|AAL, TTRight, nil, @"16", @"333333", self.contentView);
            }
            _fenrunLabel.hidden = NO;
            _phoneBtn.hidden = YES;
            _dateLabel.hidden = _shipNumLabel.hidden = YES;
            self.backgroundColor = [UIColor clearColor];
            [self setSeparatorLineWithLeft:16];
        }
            break;
        default:
            break;
    }
}

- (void)phoneAction
{
    [DTPubUtil callPhoneNumber:_item.mobile];
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
