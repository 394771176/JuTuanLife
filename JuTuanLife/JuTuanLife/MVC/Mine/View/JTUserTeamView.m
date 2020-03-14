//
//  JTUserTeamView.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/14.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTUserTeamView.h"

@interface JTUserTeamView () {
    NSMutableArray *_labelList;
}

@end

@implementation JTUserTeamView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _labelList = [NSMutableArray array];
    }
    return self;
}

- (void)setItems:(NSArray<JTUserTeam *> *)items
{
    _items = items;
    
    for (NSInteger i= _labelList.count; i<items.count; i++) {
        [_labelList safeAddObject:[self tagLabel]];
    }
    
    CGFloat left = 0;
    for (NSInteger i=0; i < _labelList.count; i++) {
        DTTagLabel *label = [_labelList safeObjectAtIndex:i];
        if (i < items.count) {
            JTUserTeam *team = [items safeObjectAtIndex:i];
            label.left = left;
            label.text = team.name;
            [label setBackgroundColor:([team.itemId integerValue] % 2 == 1 ? COLOR(#FA3F3F) : COLOR(#FFA703)) cornerRadius:1];
            label.hidden = NO;
            left = label.right + 7;
        } else {
            label.hidden = YES;
        }
    }
}

- (DTTagLabel *)tagLabel
{
    DTTagLabel *label = [DTTagLabel labelWithFrame:RECT(0, 0, 32, self.height) fontSize:12 colorString:@"ffffff"];
    label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    label.textAlignment = NSTextAlignmentCenter;
    label.gap = 4;
    [self addSubview:label];
    return label;
}

@end
