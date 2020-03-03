//
//  DTControl.m
//  DrivingTest
//
//  Created by cheng on 15/11/3.
//  Copyright © 2015年 eclicks. All rights reserved.
//

#import "DTControl.h"

@implementation DTControl

//兼容xib --owen
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    
    [self addTarget:self action:@selector(downAction) forControlEvents:UIControlEventTouchDown|UIControlEventTouchDragEnter];
    [self addTarget:self action:@selector(upAction) forControlEvents:UIControlEventTouchDragExit|UIControlEventTouchUpInside|UIControlEventTouchUpOutside|UIControlEventTouchCancel];
}

- (void)downAction
{
    if (!_disableAlpha) {
        self.alpha = 0.6;
    }
}

- (void)upAction
{
    if (!_disableAlpha) {
        self.alpha = 1.0;
    }
}

- (void)addTarget:(id)target action:(SEL)action
{
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

@end
