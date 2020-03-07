//
//  JTMineHeaderView.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/7.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTMineHeaderView.h"

@interface JTMineHeaderView () {
    UIButton *_headerBtn;
    UILabel *_nameLabel;
    DTTagLabel *_jutuanLabel;
    DTTagLabel *_jutuiLabel;
}

@end

@implementation JTMineHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CREATE_Btn_B(_headerBtn, 16, 52 + SAFE_BOTTOM_VIEW_HEIGHT, 80, 80);
        _headerBtn.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        _headerBtn.cornerRadius = _headerBtn.height / 2;
        [_headerBtn addTarget:self action:@selector(headerBtnAction)];
        [self addSubview:_headerBtn];
        
        _nameLabel = [UILabel labelWithFrame:RECT(_headerBtn.right + 16, _headerBtn.top + 15, self.width - _headerBtn.right - 16 * 2, 28) font:[UIFont systemFontOfSize:20] colorString:@"ffffff"];
        _nameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:_nameLabel];
        
        _jutuanLabel = [DTTagLabel labelWithFrame:RECT(_nameLabel.left + 2, _nameLabel.bottom + 5, 32, 16) fontSize:12 colorString:@"ffffff"];
        _jutuanLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        [_jutuanLabel setBackgroundColor:COLOR(#FFA703) cornerRadius:1];
        _jutuanLabel.textAlignment = NSTextAlignmentCenter;
        [_jutuanLabel setText:@"聚团"];
        [self addSubview:_jutuanLabel];
        
        _jutuiLabel = [DTTagLabel labelWithFrame:RECT(_jutuanLabel.right + 7, _jutuanLabel.top, _jutuanLabel.width, _jutuanLabel.height) fontSize:12 colorString:@"ffffff"];
        _jutuiLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        [_jutuiLabel setBackgroundColor:COLOR(#FA793F) cornerRadius:1];
        _jutuiLabel.textAlignment = NSTextAlignmentCenter;
        [_jutuiLabel setText:@"聚推"];
        [self addSubview:_jutuiLabel];
    }
    return self;
}

- (void)setUser:(JTUser *)user
{
    _user = user;
    [_headerBtn setImageWithURL:URL(user.avatar) placeholderImage:[UIImage imageNamed:@"user_home_avatar"]];
    [_nameLabel setText:@"张海（威海）"];
    
}

- (void)headerBtnAction
{
    NSLog(@"action");
}

@end
