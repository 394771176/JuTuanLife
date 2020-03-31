//
//  JTUserFenrunCell.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/28.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTUserFenrunCell.h"

@implementation JTUserFenrunCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setTitleColorString:@"333333" withFontSize:16];
        [self setContentColorString:@"333333" withFontSize:15];
        
        [self setSelectionStyleNoneLine];
    }
    return self;
}

- (void)setItem:(JTFenRunOverItem *)item
{
    _item = item;
    [self setTitle:[NSString stringWithFormat:@"%@", item.business.name] content:[NSString stringWithFormat:@"%.2f", item.commAmt]];
}

+ (CGFloat)cellHeightWithItem:(id)item tableView:(UITableView *)tableView
{
    return 23 + 24;
}
@end
