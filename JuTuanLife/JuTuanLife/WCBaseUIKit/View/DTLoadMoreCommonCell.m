//
//  DTLoadMoreRoundCell.m
//  DrivingTest
//
//  Created by Kent on 14-3-4.
//  Copyright (c) 2014年 eclicks. All rights reserved.
//

#import "DTLoadMoreCommonCell.h"

@interface DTLoadMoreCommonCell () {
    UIActivityIndicatorView *_aiView;
    UILabel *_loadingLabel;
}

@end

@implementation DTLoadMoreCommonCell

- (UILabel *)loadingLabel
{
    return _loadingLabel;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *contantView = [[UIView alloc] initWithFrame:CGRectMake(self.width / 2 - 120/2, 0, 120, self.contentView.height )];
        contantView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:contantView];
        
        _aiView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        if (AvailableiOS(13)) {
            _aiView.frame = CGRectMake(0, contantView.height / 2 - 18 / 2, 18, 18);
        } else {
            _aiView.transform = CGAffineTransformMakeScale(18.0f/_aiView.width, 18.0f/_aiView.width);
            _aiView.origin = CGPointMake(0, floorf(contantView.height/2.0f-_aiView.height/2));
        }
        _aiView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        [contantView addSubview:_aiView];
        
        _loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(_aiView.right+6, 0, contantView.width - _aiView.right - 6, self.height)];
        _loadingLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _loadingLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        _loadingLabel.font = [UIFont systemFontOfSize:15];
        _loadingLabel.backgroundColor = [UIColor clearColor];
        _loadingLabel.text = @"正在加载更多";
        _loadingLabel.textColor = [UIColor colorWithHexString:@"b5b5b5" alpha:1.0f];
        [contantView addSubview:_loadingLabel];
        
        [contantView setFixCenterWidth:_aiView.right + 6 + [_loadingLabel getTextWidth]];
    }
    return self;
}

- (void)startIndicator
{
    [_aiView startAnimating];
    _aiView.hidden = NO;
    _loadingLabel.hidden = NO;
}

- (void)stopIndicator
{
    [_aiView stopAnimating];
    _aiView.hidden = YES;
    _loadingLabel.hidden = YES;
}

- (void)setState:(DTTableLoadMoreState)state
{
    _state = state;
    
    switch (state) {
        case DTTableLoadMoreNormal:
            [self startIndicator];
            break;
        case DTTableLoadMoreFailed:
            [self setState:DTTableLoadMoreNormal];
            break;
        default:
            [self startIndicator];
            break;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y-scrollView.contentInset.bottom>=scrollView.contentSize.height-scrollView.height) {
        if (self.state == DTTableLoadMoreNormal) {
            self.state = DTTableLoadMoreLoading;
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y-scrollView.contentInset.bottom>=scrollView.contentSize.height-scrollView.height) {
        if (self.state == DTTableLoadMoreNormal) {
            self.state = DTTableLoadMoreLoading;
        }
    }
    if (self.state == DTTableLoadMoreLoading) {
        [_delegate loadMoreCellDidStartLoad:self];
    }
}

- (void)startLoad
{
    self.state = DTTableLoadMoreLoading;
    [_delegate loadMoreCellDidStartLoad:self];
}

+ (CGFloat)cellHeightWithItem:(id)item tableView:(UITableView *)tableView
{
    return 50 + SAFE_BOTTOM_VIEW_HEIGHT;
}

@end
