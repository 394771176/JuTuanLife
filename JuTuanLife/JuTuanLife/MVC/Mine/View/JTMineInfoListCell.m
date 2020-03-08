//
//  JTMineInfoListCell.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/8.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTMineInfoListCell.h"

@interface JTMineInfoListCell () {
    
}

@end

@implementation JTMineInfoListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel.frame = RECT(28, 0, 80, self.contentView.height);
        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        
        self.contentLabel.frame = RECT(self.titleLabel.right + 8, 0, self.contentView.width - self.titleLabel.right - 8 - 92, self.contentView.height);
        self.contentLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.textAlignment = NSTextAlignmentLeft;
        
        [self setTitleColorString:@"333333" withFontSize:16];
        [self setContentColorString:@"999999" withFontSize:15];
        
        [self setSeparatorLineWithLeft:self.contentLabel.left andRight:(self.contentView.width - self.contentLabel.right)];
        
        [self setLineStyle:DTCellLineNone];
    }
    return self;
}

+ (CGFloat)cellHeightWithItem:(NSString *)item tableView:(UITableView *)tableView
{
    return 44;
}

@end
