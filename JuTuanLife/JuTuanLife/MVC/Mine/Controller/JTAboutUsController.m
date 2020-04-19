//
//  JTAboutUsController.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/7.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTAboutUsController.h"

@interface JTAboutUsController () {
    UIView *_titleView;
    UILabel *_titleLabel;
}

@end

@implementation JTAboutUsController

- (void)viewDidLoad {
    
    self.urlStr = [JTDataManager sharedInstance].baseConfig.about_us_url;
    
    [super viewDidLoad];
    [self setupTitleView];
    self.title = @"关于聚推帮";
}

- (void)setupTitleView
{
    if (!_titleView) {
        UICREATETo(_titleView, UIView, 0, 0, 180, 44, AANone, nil);
        
        UICREATELabel2To(_titleLabel, UILabel, 0, 0, _titleView.width, _titleView.height, AAWH, TTCenter, nil, FONT_B(18), @"333333", _titleView);
        
        if (APP_DEBUG) {
            [_titleView addTarget:self longPressAction:@selector(longPressAction:) duration:0.5];
        } else {
            [_titleView addTarget:self longPressAction:@selector(longPressAction:) duration:2];
        }
    }
    self.navigationItem.titleView = _titleView;
}

- (void)setTitle:(NSString *)title
{
    _titleLabel.text = title;
}

- (void)longPressAction:(UIGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        NSString *packet = @"Release";
#ifdef DEBUG
        packet = @"DEBUG";
#endif
        NSString *debug = @"NO";
        if (APP_DEBUG) {
            debug = @"YES";
        }
        
        NSString *server = @"正式服";
        if (APP_SERVER_DEBUG) {
            server = @"测试服";
        }
        
        NSString *token = [JTUserManager sharedInstance].ac_token;
        NSString *content = [NSString stringWithFormat:@"\n"
                             "APPID：%@\n"
                             "version：%@(%@)\n"
                             "packet：%@\n"
                             "debug：%@\n"
                             "server：%@\n"
                             "token：%@\n",
                             APP_BUNDLE_ID, APP_VERSION_SHORT, APP_VERSION_BUILD, packet, debug, server, token];
        
        [JTCoreUtil showAlertWithTitle:@"About Us" message:content cancelTitle:@"取消" confirmTitle:@"确定" destructiveTitle:nil handler:^(UIAlertAction *action) {
            if (token.length) {
                [UIPasteboard generalPasteboard].string = token;
            }
        }];
    }
}

@end
