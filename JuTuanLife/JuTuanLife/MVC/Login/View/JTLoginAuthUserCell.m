//
//  JTLoginAuthUserCell.m
//  JuTuanLife
//
//  Created by cheng on 2020/4/4.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTLoginAuthUserCell.h"

@interface JTLoginAuthUserCell () {
    UIImageView *_authImageView;
    UILabel *_label1;
    UILabel *_label2;
}

@end

@implementation JTLoginAuthUserCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UICREATEImageTo(_authImageView, UIImageView, 0, 0, 0, 0, AALR, CCCenter, @"login_auth_face", self.contentView);
        _authImageView.origin = CGPointMake(self.contentView.width / 2 - _authImageView.width / 2, 105);
        
        UICREATELabel2To(_label1, UILabel, 10, _authImageView.bottom + 24, self.contentView.width - 20, 23, AAW, TTCenter, @"请先进行人脸识别认证", @"16", @"333333", self.contentView);
        
        UICREATELabel2To(_label2, UILabel, _label1.left, _label1.bottom, _label1.width, 23, AAW, TTCenter, @"用于身份验证", @"12", @"999999", self.contentView);
        
        [self setSelectionStyleNoneLine];
    }
    return self;
}

+ (CGFloat)cellHeightWithItem:(id)item tableView:(UITableView *)tableView
{
    return 114 + 105 * 2;
}

@end
