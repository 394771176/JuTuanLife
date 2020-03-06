//
//  JTLoginProtorolCell.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/6.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTLoginProtorolCell.h"

@interface JTLoginProtorolCell () {
    DTControl *_bodyView;
    UILabel *_titleLabel;
}

@end

@implementation JTLoginProtorolCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CREATE_UI_VV(_bodyView, DTControl, 24, 12, self.contentView.width - 24 * 2, self.contentView.height - 12 * 2);
        _bodyView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_bodyView addTarget:self action:@selector(clickAction)];
        _bodyView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bodyView];
        
        CREATE_UI_VV(_titleLabel, UILabel, 15, 0, _bodyView.width - 30, _bodyView.height);
        _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_titleLabel setFontSize:16 colorString:APP_JT_BLUE_STRING];
        [_bodyView addSubview:_titleLabel];
        
        [self setSelectionStyleClear];
    }
    return self;
}

- (void)setItem:(JTProtorolItem *)item
{
    _item = item;
    _titleLabel.text = item.name;
}

- (void)clickAction
{
    [JTCoreUtil openWithLink:_item.link];
//    [DTPubUtil sendTagert:self.delegate action:@selector(tableButtonCellDidClickAction:) object:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)cellHeightWithItem:(id)item tableView:(UITableView *)tableView
{
    return 52 + 24;
}

@end
