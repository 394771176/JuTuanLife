//
//  JTMessageCenterController.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/8.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTMessageCenterController.h"
#import "JTMessageListModel.h"
#import "JTMessageListCell.h"

@interface JTMessageCenterController ()

@end

@implementation JTMessageCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息中心";
    [self reloadData];
}

- (DTListDataModel *)createDataModel
{
    JTMessageListModel *model = [[JTMessageListModel alloc] initWithFetchLimit:20 delegate:self];
    [model loadCache];
    return model;
}

- (void)reloadData
{
    
    [super reloadData];
}

- (WCTableSourceData *)setupTableSourceData
{
    WCTableSourceData *source = [WCTableSourceData new];
    {
        [source addSectionWithItems:self.dataModel.data cellClass:[JTMessageListCell class]];
    }
    
    {
        WCTableSection *section = [WCTableSection sectionWithItems:@[self.loadMoreCell] countBlock:^NSInteger(NSInteger section) {
            return (self.dataModel.canLoadMore ? 1 : 0);
        }];
        [source addSectionItem:section];
    }
    return source;
}

@end
