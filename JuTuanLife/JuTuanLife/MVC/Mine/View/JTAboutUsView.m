//
//  JTAboutUsView.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/8.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTAboutUsView.h"

@interface JTAboutUsView () {
    UIImageView *_logoView;
    UILabel *_welcomeLabel;
    UILabel *_jutuiLabel;
    
    UIButton *_iOSBtn;
    UIButton *_androidBtn;
}

@end

@implementation JTAboutUsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UICREATEImageTo(_logoView, UIImageView, 0, 44, self.width, 80, AAW, CCCenter, @"", self);

        
    }
    return self;
}

@end
