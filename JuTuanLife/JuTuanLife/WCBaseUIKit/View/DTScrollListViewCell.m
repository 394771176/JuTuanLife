//
//  DTHorizontalScrollViewCell.m
//  DrivingTest
//
//  Created by cheng on 16/12/15.
//  Copyright © 2016年 eclicks. All rights reserved.
//

#import "DTScrollListViewCell.h"
#import "WCUICommon.h"

@implementation DTScrollListViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _scrollView = [[DTControllerListView alloc] initWithFrame:self.bounds];
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:_scrollView];
        
        [self setSelectionStyleClear];
    }
    return self;
}

- (void)setDelegate:(id<DTControllerListViewDelegate>)delegate
{
    _delegate = delegate;
    _scrollView.delegate = delegate;
}

@end

@implementation DTHorizontalScrollViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _scrollView = [[DTHorizontalScrollView alloc] initWithFrame:self.contentView.bounds];
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:_scrollView];
        
        [self setSelectionStyleClear];
    }
    return self;
}

- (void)setDelegate:(id<DTHorizontalScrollViewDelegate,DTHorizontalScrollViewDataSource>)delegate
{
    _delegate= delegate;
    _scrollView.horizontalDelegate = delegate;
    _scrollView.horizontalDataSource = delegate;
}

@end
