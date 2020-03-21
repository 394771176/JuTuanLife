//
//  JTMessageListCell.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/8.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTMessageListCell.h"

@interface JTMessageListCell () {
    
}

@end

@implementation JTMessageListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setItem:(JTMessageItem *)item
{
    _item = item;
    self.textLabel.text = item.content;
    self.textLabel.numberOfLines = 0;
}

+ (CGFloat)cellHeightWithItem:(id)item tableView:(UITableView *)tableView
{
    return 120;
}

@end
