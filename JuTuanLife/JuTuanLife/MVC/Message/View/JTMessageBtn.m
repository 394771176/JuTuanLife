//
//  JTMessageBtn.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/21.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTMessageBtn.h"
#import "JTMessageCenterController.h"

@interface JTMessageBtn () {
    DTBadgeView *_badgeView;
}

@end

@implementation JTMessageBtn

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setImageWithImageName:@"message_center_icon"];
        
        [self addTarget:self action:@selector(btnAction)];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMessageCount) name:JTUserRequest_unread_msg_num object:nil];
    }
    return self;
}

- (void)setBadge:(NSInteger)badge
{
    _badge = badge;
    if (badge > 0) {
        if (!_badgeView) {
            UICREATETo(_badgeView, DTBadgeView, self.width - 18+2, 2, 18, 14, AAL, self);
            _badgeView.badgeColor = [UIColor colorWithString:@"#E73030"];
            _badgeView.font = FONT(12);
        }
    }
    if (_badgeView) {
        _badgeView.badge = badge;
    }
}

- (void)updateMessageCount
{
    self.badge = [JTUserManager sharedInstance].unreadMsgCount;
}

- (void)btnAction
{
    self.badge = 0;
    [JTUserManager sharedInstance].unreadMsgCount = 0;
    PUSH_VC(JTMessageCenterController);
}

@end
