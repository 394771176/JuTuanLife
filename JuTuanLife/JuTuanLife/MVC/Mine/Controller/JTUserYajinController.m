//
//  JTUserYajinController.m
//  JuTuanLife
//
//  Created by cheng on 2020/4/2.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTUserYajinController.h"
#import "JTUserYajinModel.h"
#import "JTUserYajinListCell.h"

@interface JTUserYajinController () {
    JTUserYajinListCell *_titleCell;
}

@end

@implementation JTUserYajinController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"责任保证金";
    self.noDataMsg = @"暂无扣除记录";
}

- (DTListDataModel *)createDataModel
{
    JTUserYajinModel *model = [[JTUserYajinModel alloc] initWithFetchLimit:20 delegate:self];
    [model loadCache];
    return model;
}

- (WCTableSourceData *)setupTableSourceData
{
    WEAK_SELF
    WCTableSourceData *source = [WCTableSourceData new];
    
    if (self.dataModel.itemCount) {
        {
            if (!_titleCell) {
                _titleCell = [[JTUserYajinListCell alloc] init];
                _titleCell.isTitle = YES;
            }
            
            WCTableRow *row = [WCTableRow rowWithCell:_titleCell height:55 click:nil];
            [source addRowItem:row];
            [source setLastSectionHeaderHeight:12 footerHeight:0];
        }
        
        {
            [source addSectionWithItems:self.dataModel.data cellClass:JTUserYajinListCell.class];
            [source setLastSectionHeaderHeight:3 footerHeight:0];
        }
        
        if (self.loadMoreCell) {
            WCTableSection *section = [WCTableSection sectionWithCells:@[self.loadMoreCell] click:nil];
            section.countBlock = ^NSInteger(NSInteger section) {
                if ([weakSelf.dataModel canLoadMore]) {
                    return 1;
                } else {
                    return 0;
                }
            };
            [source addSectionItem:section];
        }
    }
    
    return source;
}

- (void)reloadData
{
    [super reloadData];
}

@end
