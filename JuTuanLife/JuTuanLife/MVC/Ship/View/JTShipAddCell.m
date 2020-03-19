//
//  JTShipAddCell.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/19.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTShipAddCell.h"

@interface JTShipAddCell () {
    UIView *_bodyView;
    UILabel *_titleLabel;
    UIButton *_addBtn;
}

@end

@implementation JTShipAddCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.height = self.contentView.height = 130;
        
        [self setSelectionStyleClear];
        
//        UICREATETo(_bodyView, UIView, 0, self.contentView.height / 2 - 80 / 2, self.contentView.width 80, AATB, self.contentView);
        //75 - 56 = 19
        UICREATETo(_bodyView, UIView, 0, self.contentView.height/2-108/2, self.contentView.width, 108, AATB|AAW, self.contentView);
        
        //16 + 24 + 20 + 48 +20 = 128;
        UICREATELabel2To(_titleLabel, UILabel, 10, 16, _bodyView.width - 20, 24, AAW, TTCenter, @"您暂时还没有徒弟，快去分享招小徒弟吧！", @"12", @"999999", _bodyView);
        
        UICREATEBtnTo(_addBtn, UIButton, _bodyView.width / 2 - 176 / 2, _titleLabel.bottom + 20, 176, 48, AALR, @" 加入聚推", @"16", @"333333", self, @selector(addBtnAction), _bodyView);
        [_addBtn setImageWithImageName:@"jt_ship_add"];
        _addBtn.cornerRadius = 3;
        [_addBtn setBackgroundImageAndHightlightWithColorHex:@"ffffff"];
    }
    return self;
}

- (void)setItem:(JTUser *)item
{
    _item = item;
    if (item.teams) {
        JTUserTeam *team = item.teams.firstObject;
        [_addBtn setTitle:[NSString stringWithFormat:@" 加入%@", team.fullName]];
    }
}

- (void)addBtnAction
{
    [DTPubUtil sendTagert:self.delegate action:@selector(tableButtonCellDidClickAction:) object:self];
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
    return 110;
}

@end
