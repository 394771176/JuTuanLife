//
//  DTHttpRefreshLoadMoreTableController.m
//  DrivingTest
//
//  Created by Kent on 14-7-4.
//  Copyright (c) 2014年 eclicks. All rights reserved.
//

#import "DTHttpRefreshLoadMoreTableController.h"
#import "DTLoadMoreCommonCell.h"

@interface DTHttpRefreshLoadMoreTableController ()

@end

@implementation DTHttpRefreshLoadMoreTableController

- (void)dealloc
{
    _loadMoreCell.delegate = nil;
    _loadMoreCell = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    _loadMoreCell = [self createLoadMoreCell];
    _loadMoreCell.delegate = self;
    
    [super viewDidLoad];
}

- (DTLoadMoreCommonCell *)createLoadMoreCell
{
    DTLoadMoreCommonCell *cell = [[DTLoadMoreCommonCell alloc] init];
    cell.height = 52;
    return cell;
}

- (void)reloadData
{
    [super reloadData];
    [_loadMoreCell setState:DTTableLoadMoreNormal];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
    
    [_loadMoreCell scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [_loadMoreCell scrollViewDidEndDragging:scrollView];
}

#pragma mark - DTLoadMoreRoundCellDelegate

- (void)loadMoreCellDidStartLoad:(DTLoadMoreCommonCell *)cell
{
    if (![self.dataModel loading]&&[self.dataModel canLoadMore]) {
        [self.dataModel startLoad];
    } else if (_loadMoreCell.state == DTTableLoadMoreLoading) {
        _loadMoreCell.state = DTTableLoadMoreNormal;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView cellForRowAtIndexPath:indexPath]==_loadMoreCell) {
        if (_loadMoreCell.state == DTTableLoadMoreFailed) {
            [_loadMoreCell startLoad];
        }
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

@end
