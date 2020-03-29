//
//  JTMineHeaderView.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/7.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTMineHeaderView.h"

@interface JTMineHeaderView () {
//    JTUserHeaderView *_headerView;
}

@end

@implementation JTMineHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UICREATETo(_headerView, JTUserHeaderView, 24, 64 + SAFE_BOTTOM_VIEW_HEIGHT, self.width - 48, 72, AAW, self);
    }
    return self;
}

- (void)setHeaderViewOffsetY:(CGFloat)offsetY
{
    _headerView.top = 64 + SAFE_BOTTOM_VIEW_HEIGHT + offsetY;
}

- (void)setUser:(JTUser *)user
{
    _user = user;
    _headerView.item = user;
}

- (void)headerBtnAction
{
    NSLog(@"action");
}

@end
