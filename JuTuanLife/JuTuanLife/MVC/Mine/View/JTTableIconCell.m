//
//  JTTableIconCell.m
//  JuTuanLife
//
//  Created by cheng on 2020/4/11.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTTableIconCell.h"

@implementation JTTableIconCell

- (void)setItem:(DTTitleIconItem *)item
{
    _item = item;
    [self setTitle:item.title content:nil icon:item.icon];
}

@end
