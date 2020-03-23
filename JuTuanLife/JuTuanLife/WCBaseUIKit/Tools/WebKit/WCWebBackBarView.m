//
//  WCWebBackItem.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/23.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "WCWebBackBarView.h"

@implementation WCWebBackBarView

+ (WCWebBackBarView *)view
{
    WCWebBackBarView *view = [[WCWebBackBarView alloc] initWithFrame:RECT(0, 0, 80, 44)];
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UICREATEBtnImgTo(_backBtn, UIButton, 0, 0, self.width / 2, self.height, AAW|AAR, @"web_nav_back", nil, nil, self);
        
        UICREATEBtnImgTo(_closeBtn, UIButton, self.width / 2, 0, self.width / 2, self.height, AAW|AAL, @"web_nav_close", nil, nil, self);
        
        self.showCloseBtn = NO;
    }
    return self;
}

- (void)setShowCloseBtn:(BOOL)showCloseBtn
{
    _showCloseBtn = showCloseBtn;
    _closeBtn.hidden = !showCloseBtn;
}

- (void)addTarget:(id)target withBackAction:(SEL)backAction
{
    [self.backBtn addTarget:target action:backAction];
}

- (void)addTarget:(id)target withCloseAction:(SEL)closeAction
{
    [self.closeBtn addTarget:target action:closeAction];
}

@end
