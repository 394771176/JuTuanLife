//
//  JTUserHeaderView.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/14.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTUserHeaderView.h"

@interface JTUserHeaderView () {
    UIButton *_headerBtn;
}

@end

@implementation JTUserHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        _headerBtn = UICreateBtn([UIButton class], RECT(16, 48+SAFE_BOTTOM_VIEW_HEIGHT, 72, 72), AAR, nil, nil, nil, self, @selector(headerBtnAction), self);
        UICREATEBtnTo(_headerBtn, UIButton, 0, 0, self.height, self.height, AAR, nil, nil, nil, self, @selector(headerBtnAction), self);
        _headerBtn.cornerRadius = _headerBtn.height / 2;
        
        CGFloat gap = 12 + (self.height - 60) / 12 * 8;
        gap = validValue(gap, 10, 20);
        
        UICREATELabelTo(_nameLabel, UILabel, _headerBtn.right + gap, 0, self.width - _headerBtn.right - gap * 2, self.height / 5 * 3, AAW, nil, @"20", @"333333", self);
        
        UICREATETo(_teamView, JTUserTeamView, _nameLabel.left + 2, _nameLabel.bottom, _nameLabel.width, 16, AAW, self);
    }
    return self;
}

- (void)setNameFont:(UIFont *)font
{
    _nameLabel.font = font;
}

- (void)setItem:(JTUser *)item
{
    _item = item;
    JTUser *user = item;
    [_headerBtn setImageWithURL:URL(user.avatar) placeholderImage:[UIImage imageNamed:@"user_home_avatar"]];
    
    NSString *city = [NSString stringWithFormat:@"(%@)", user.bizCityName];
    [_nameLabel setText:[NSString stringWithFormat:@"%@ %@", user.name, (user.bizCityName.length ? city: @"")]];
    
    _teamView.items = item.teams;
}

- (void)headerBtnAction
{
    NSLog(@"action");
}

@end
