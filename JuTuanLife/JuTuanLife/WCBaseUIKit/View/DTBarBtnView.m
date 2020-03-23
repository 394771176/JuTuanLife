//
//  DTBarBtnView.m
//  DrivingTest
//
//  Created by cheng on 2017/7/27.
//  Copyright © 2017年 eclicks. All rights reserved.
//

#import "DTBarBtnView.h"

@interface DTBarBtnView () {
    
}

@end

@implementation DTBarBtnView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (UIBarButtonItem *)barBtnItem
{
    if (!_barBtnItem) {
        _barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:self];
    }
    return _barBtnItem;
}

@end
