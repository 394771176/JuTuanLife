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
        
        //0,3 6,3  27 * 27
        UIImage *image = [[UIImage imageNamed:@"login_protorol_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(13, 13, 13, 13)];
        
        UICREATEImg(UIImageView, 21, 12, self.contentView.width - 21 * 2, self.contentView.height - 12 - 6, AAWH, CCFill, image, self.contentView)
        
        UICREATETo(_bodyView, DTControl, 24, 12, self.contentView.width - 24 * 2, self.contentView.height - 12 * 2, AAWH, self.contentView);
        [_bodyView addTarget:self action:@selector(clickAction)];
        
        CREATE_UI_VV(_titleLabel, UILabel, 15, 3, _bodyView.width - 30, _bodyView.height - 3);
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
    [JTLinkUtil openLink:_item.contentUrl];
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
