//
//  JTUserBankCell.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/9.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTUserBankCell.h"

@interface JTUserBankCell () {
    DTControl *_bodyView;
    UILabel *_bankNameLabel;
    UILabel *_bankTypeLabel;
    UILabel *_bankNumLabel;
}

@end

@implementation JTUserBankCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.height = self.contentView.height = 112;
        
        UICREATETo(_bodyView, DTControl, 16, 12, self.contentView.width - 16 * 2, self.contentView.height - 12, AAWH, self.contentView);
        _bodyView.backgroundColor = [UIColor colorWithString:@"#FD5E6A"];
        _bodyView.cornerRadius = 4;
        [_bodyView addTarget:self action:@selector(bodyAction)];
        
        UICREATELabelTo(_bankNameLabel, UILabel, 28, 8, _bodyView.width - 56, 23, AAW, nil, @"16", @"ffffff", _bodyView);
        
        UICREATELabelTo(_bankTypeLabel, UILabel, _bankNameLabel.left, _bankNameLabel.bottom, _bankNameLabel.width, _bankNameLabel.height, AAW, nil, @"12", @"ffffff", _bodyView);
        
        UICREATELabelTo(_bankNumLabel, UILabel, 10, 53, _bodyView.width - 20, 33, AAW, nil, @"23", @"ffffff", _bodyView);
        _bankNumLabel.textAlignment = NSTextAlignmentCenter;
        
        [self setSelectionStyleClear];
    }
    return self;
}

- (void)setItem:(JTUserBank *)item
{
    _item = item;
    
    _bankNameLabel.text = item.bankName;
    _bankTypeLabel.text = item.bankBranch;
    _bankNumLabel.text = [item bankNumCipher];
}

- (void)bodyAction
{
    [DTPubUtil sendTagert:_delegate action:@selector(tableButtonCellDidClickAction:) object:self];
}

+ (CGFloat)cellHeightWithItem:(id)item tableView:(UITableView *)tableView
{
    return 12 + 100;
}

@end
