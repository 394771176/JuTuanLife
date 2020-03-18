//
//  JTMineInfoAvatarCell.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/8.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTMineInfoAvatarCell.h"

@interface JTMineInfoAvatarCell () {
    UIImageView *_avatarView;
}

@end

@implementation JTMineInfoAvatarCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UICREATEImageTo(_avatarView, UIImageView, self.contentView.width - 116 / 2 - 80, self.contentView.height / 2 - 80 / 2, 80, 80, AAL | AATB, CCAFill, nil, self.contentView);
        
        _avatarView.cornerRadius = _avatarView.height / 2;
        
        [self setTitle:@"头 像"];
        [self showArrow:YES];
    }
    return self;
}

- (void)setItem:(JTUser *)item
{
    [_avatarView setImageWithURL:URL(item.avatar) placeholderImage:[UIImage imageNamed:@"user_home_avatar"]];
}

- (void)setAvatar:(UIImage *)image
{
    _avatarView.image = image;
}

+ (CGFloat)cellHeightWithItem:(id)item tableView:(UITableView *)tableView
{
    return 104;
}

@end
