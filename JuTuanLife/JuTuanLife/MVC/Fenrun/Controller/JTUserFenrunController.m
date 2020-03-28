//
//  JTFenrunDetailController.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/27.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTUserFenrunController.h"
#import "JTUserFenrunCell.h"

@interface JTUserFenrunController () {
    BOOL _isUserSelf;
    
    DTTitleContentCell *_headerCell;
}

@property (nonatomic, strong) NSString *userNo;

@end

@implementation JTUserFenrunController

- (void)viewDidLoad {
    
    _headerCell = [[JTUserFenrunCell alloc] init];
    [_headerCell setLineStyle:DTCellLineBottom];
    
    [super viewDidLoad];
    if ([self.userNo isEqualToString:[JTUserManager sharedInstance].user.userNo]) {
        _isUserSelf = YES;
        self.title = @"本人";
    } else {
        _isUserSelf = NO;
        self.title = _user.name;
    }
}

- (void)setUser:(JTUser *)user
{
    _user = user;
    _userNo = user.userNo;
}

- (DTListDataModel *)createDataModel
{
    JTUserFenrunModel *model = [[JTUserFenrunModel alloc] initWithDelegate:self];
    model.userNo = _userNo;
    model.period = _period;
    model.selectedDate = _selectedDate;
    [model loadCache];
    return model;
}

- (WCTableSourceData *)setupTableSourceData
{
//    WEAK_SELF
    WCTableSourceData *source = [WCTableSourceData new];
    
    if (_headerCell) {
        [source addSectionWithCells:@[_headerCell] height:46 click:nil];
    }
    
    {
        [source addSectionWithItems:self.dataModel.data cellClass:JTUserFenrunCell.class height:46];
    }
    
    return source;
}

- (void)reloadData
{
    [_headerCell setTitle:_user.name content:[self.Model fenrun].dateStr];
    [super reloadData];
}

@end
