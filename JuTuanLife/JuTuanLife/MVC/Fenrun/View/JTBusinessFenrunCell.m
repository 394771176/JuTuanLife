//
//  JTBusinessFenrunCell.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/28.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTBusinessFenrunCell.h"

@interface JTBusinessFenrunCell () {
    
    UIView *_bodyView;
    
    UILabel *_totalLabel;
    UILabel *_fenrunLabel;
}

@end

@implementation JTBusinessFenrunCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.height = self.contentView.height = 123 + 16;
        
        self.titleLabel.frame = CGRectMake(16, 0, self.contentView.width - 32, 45);
        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        BPOnePixLineView *line = [[BPOnePixLineView alloc] initWithFrame:RECT(0, self.titleLabel.bottom, self.contentView.width, 1)];
        line.lineColor = [UIColor colorWithString:@"dcdcdc"];
        line.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:line];
        
        self.contentLabel.frame = RECT(self.titleLabel.left, self.contentView.height - 40 - 16, self.titleLabel.width, 40);
        self.contentLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [self setTitleColorString:@"333333" withFontSize:16];
        [self setContentColorString:@"333333" withFontSize:12];
        
        self.contentLabel.textAlignment = NSTextAlignmentLeft;
        
        UICREATEViewTo(_bodyView, UIView, 0, 0, self.contentView.width, self.contentView.height - 16, AAWH, [UIColor whiteColor], self.contentView);
        [self.contentView sendSubviewToBack:_bodyView];
        
        UICREATELabelTo(_totalLabel, UILabel, self.titleLabel.left, 46, SCALE_SCREEN_SIZE(250) - 10 - self.titleLabel.left, 46, AAW|AAR, nil, @"16", @"333333", self.contentView);
        
        UICREATELabelTo(_fenrunLabel, UILabel, _totalLabel.right + 10, _totalLabel.top, self.contentView.width - _totalLabel.right - 10 - 5, _totalLabel.height, AAW|AAL, nil, @"16", @"333333", self.contentView);
        
        [self setSelectionStyleClear];
    }
    return self;
}

- (void)setTitleItem:(JTBusinessFenRunTitleItem *)titleItem
{
    _titleItem = titleItem;
}

- (void)setItem:(JTBusinessFenRunItem *)item
{
    _item = item;
    [self setTitle:[NSString stringWithFormat:@"%@：%@", [_titleItem.performanceTitles safeObjectAtIndex:0], item.title]];
    
    _totalLabel.text = [NSString stringWithFormat:@"%@：%.2f", [_titleItem.performanceTitles safeObjectAtIndex:1], item.total];
    
    _fenrunLabel.text = [NSString stringWithFormat:@"%@：%.2f", [_titleItem.performanceTitles safeObjectAtIndex:2], item.fenrunMon];
    
    [self setContent:[NSString stringWithFormat:@"%@：%@", [_titleItem.performanceTitles safeObjectAtIndex:3], item.date]];
}

+ (CGFloat)cellHeightWithItem:(id)item tableView:(UITableView *)tableView
{
    return 123 + 16;
}

@end
