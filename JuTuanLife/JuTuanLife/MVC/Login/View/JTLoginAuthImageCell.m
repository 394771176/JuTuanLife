//
//  JTLoginAuthImageCell.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/6.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTLoginAuthImageCell.h"

@interface JTLoginAuthImageCell () {
    DTControl *_bodyView;
    UILabel *_titleLabel;
    UIImageView *_camBgView;
    UIImageView *_camView;
}

@end

@implementation JTLoginAuthImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //625 - 348
        self.height = self.contentView.height = 478 / 2.f + 20;
        
        //6,7 8,7  24 * 24
        UIImage *image = [[UIImage imageNamed:@"login_auth_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(12, 12, 11, 11)];
        UICREATEImage(UIImageView, 9, 4, self.contentView.width - 9 * 2, self.contentView.height - 4 - 2, AAWH, CCFill, image, self.contentView);
        
        _bodyView = [[DTControl alloc] initWithFrame:CGRectMake(16, 10, self.contentView.width - 32, self.contentView.height - 20)];
        _bodyView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _bodyView.backgroundColor = [UIColor whiteColor];
        [_bodyView addTarget:self action:@selector(clickAction)];
//        _bodyView.cornerRadius = 5;
        [self.contentView addSubview:_bodyView];
        
        _titleLabel = [UILabel labelWithFrame:CGRectMake(9, 5, _bodyView.width - 20, 44) fontSize:16 colorString:@"333333"];
        _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [_bodyView addSubview:_titleLabel];
        
        _camBgView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 49, _bodyView.width - 32, _bodyView.height - 49 - 16)];
        _camBgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _camBgView.contentMode = UIViewContentModeScaleAspectFit;
        [_bodyView addSubview:_camBgView];
        
        _camView = [[UIImageView alloc] initWithFrame:_camBgView.bounds];
        _camView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _camView.contentMode = UIViewContentModeCenter;
        [_camView setImageWithName:@"auth_cam"];
        [_camBgView addSubview:_camView];
        
        _bodyView.clipsToBounds = NO;
        _bodyView.layer.shadowOffset = CGSizeMake(0, 2);
        _bodyView.layer.shadowRadius = 10;
        _bodyView.layer.opacity = 1;
        _bodyView.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;
        
        [self setSelectionStyleClear];
    }
    return self;
}

- (void)setStep:(NSInteger)step
{
    _step = step;
    [_camBgView setImageWithName:[NSString stringWithFormat:@"auth_idcard_%zd", step]];
    switch (step) {
        case 1:
        {
            _titleLabel.text = @"第一步：上传身份证人像面";
        }
            break;
        case 2:
        {
            _titleLabel.text = @"第二步：上传身份证国徽面";
        }
            break;
        case 3:
        {
            _titleLabel.text = @"第三步：人脸识别";
        }
            break;
        default:
            break;
    }
}

- (void)clickAction
{
    [DTPubUtil sendTagert:self.delegate action:@selector(tableButtonCellDidClickAction:) object:self];
}

+ (CGFloat)cellHeightWithItem:(id)item tableView:(UITableView *)tableView
{
    CGFloat imageW = tableView.width - 16 * 2 - 16 * 2;
    CGFloat imageH = 348.f / 625 * imageW;
    return 10 + 49 + imageH + 16 + 10;
}

@end
