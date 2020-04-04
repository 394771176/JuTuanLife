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
    UILabel *_relationLabel;
    UILabel *_jobNoLabel;
    UILabel *_relationNumLabel;//徒弟 + 成就
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
        _headerBtn.userInteractionEnabled = NO;
        
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
    [_headerBtn setImageWithURLStr:user.avatar placeholderImage:[UIImage imageNamed:@"user_home_avatar"]];
    
    NSString *city = [NSString stringWithFormat:@"(%@)", user.bizCityNameShort];
    [_nameLabel setText:[NSString stringWithFormat:@"%@ %@", user.name, (user.bizCityName.length ? city: @"")]];
    
    _teamView.items = item.teams;
    
    if (_showJobNo) {
        self.showJobNo = _showJobNo;
    }
    if (_showRelationNum) {
        self.showRelationNum = _showRelationNum;
    }
}

- (void)setRelationType:(NSInteger)relationType
{
    _relationType = relationType;
    NSString *name = [JTShipItem relationTypeName:relationType];
    if (name.length) {
        if (!_relationLabel) {
            UICREATELabelTo(_relationLabel, UILabel, _nameLabel.left, _teamView.top, 26, _teamView.height, AAR, nil, @"12", @"999999", self);
        }
        _relationLabel.hidden = NO;
        [_relationLabel setLabelWidthWithString:name];
        
        _teamView.left = _relationLabel.right + 8;
    } else {
        _relationLabel.hidden = YES;
        _teamView.left = _nameLabel.left + 2;
    }
}

- (void)setShowJobNo:(BOOL)showJobNo
{
    _showJobNo = showJobNo;
    if (_showJobNo) {
        if (!_jobNoLabel) {
            UICREATELabelTo(_jobNoLabel, UILabel, _nameLabel.left, _teamView.top, 120, _teamView.height, AAR, nil, @"12", @"333333", self);
            [_jobNoLabel addTarget:self longPressAction:@selector(longPressAction:)];
        }
        _jobNoLabel.hidden = NO;
        [_jobNoLabel setLabelWidthWithString:[NSString stringWithFormat:@"工号：%@", _item.jobNo]];
        
        _teamView.left = _jobNoLabel.right + 12;
    } else {
        _jobNoLabel.hidden = YES;
    }
}

- (void)setShowRelationNum:(BOOL)showRelationNum
{
    _showRelationNum = showRelationNum;
    if (_showRelationNum) {
        _nameLabel.height = self.height / 5 * 2;
        _teamView.top = _nameLabel.bottom;
        _jobNoLabel.top = _teamView.top;
        if (!_relationNumLabel) {
            UICREATELabelTo(_relationNumLabel, UILabel, _nameLabel.left, _teamView.bottom + 2, _nameLabel.width, 23, AAW, nil, @"16", @"333333", self);
        }
        _relationNumLabel.hidden = NO;
        NSString *string = [NSString stringWithFormat:@"%zd 徒弟      %d 成就", _item.apprentices, 0];
        [_relationNumLabel setText:string highLightTextArray:@[@"徒弟", @"成就"] withColor:nil font:FONT(12)];
    } else {
        _relationNumLabel.hidden = YES;
    }
}

- (CGFloat)getTeamsViewRight
{
    return _teamView.left + [_teamView teamsContentWidth];
}

- (void)headerBtnAction
{
    NSLog(@"action");
}

- (void)longPressAction:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        if (_item.jobNo.length) {
            [UIPasteboard generalPasteboard].string = _item.jobNo;
            [DTPubUtil showHUDSuccessHintInWindow:@"工号已复制到粘贴板"];
        }
    }
}

@end
