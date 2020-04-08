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
    UIView *_bodyView;
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
        
        self.height = self.contentView.height = 90;
        
        UICREATETo(_bodyView, UIView, 0, self.contentView.height / 2 - 60 / 2, self.contentView.width, 60, AAW | AATB, self.contentView);
        
        UICREATETo(_headerView, JTUserHeaderView, 20, 0, self.contentView.width - 40, _bodyView.height, AAW, _bodyView);
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
                UICREATELabelTo(_dateLabel, UILabel, _bodyView.width - 120 - 20, _headerView.nameLabel.top + _headerView.top, 120, _headerView.nameLabel.height, AAL, nil, @"12", @"999999", _bodyView);
                _dateLabel.textAlignment = NSTextAlignmentRight;
                
                UICREATELabelTo(_shipNumLabel, UILabel, [_headerView getTeamsViewRight], _headerView.teamView.top + _headerView.top, 200, _headerView.teamView.height, AAL, nil, @"12", @"999999", _bodyView);
                
                UICREATEBtnImgTo(_phoneBtn, UIButton, _bodyView.width - 40 - 12, _shipNumLabel.top - 8 - 2, 40, 40, AAL, @"jt_ship_phone", self, @selector(phoneAction), _bodyView);
            }
            _fenrunLabel.hidden = YES;
            _phoneBtn.hidden = NO;
            _dateLabel.hidden = _shipNumLabel.hidden = NO;
        }
            break;
        case JTShipCellTypeFenrun:
        {
            if (!_fenrunLabel) {
                UICREATELabel2To(_fenrunLabel, UILabel, _bodyView.width - 160, 0, 120, _bodyView.height, AAWH|AAL, TTRight, nil, @"16", @"333333", _bodyView);
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
    [JTCoreUtil callPhoneNumber:_item.mobile];
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
    return 84;
}

@end
