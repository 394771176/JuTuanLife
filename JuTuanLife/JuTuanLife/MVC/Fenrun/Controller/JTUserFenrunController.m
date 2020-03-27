//
//  JTFenrunDetailController.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/27.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTUserFenrunController.h"

@interface JTUserFenrunController () {
    BOOL _isUserSelf;
}

@property (nonatomic, strong) NSString *userNo;

@end

@implementation JTUserFenrunController

- (void)viewDidLoad {
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
    [model loadCache];
    return model;
}

- (WCTableSourceData *)setupTableSourceData
{
    WEAK_SELF
    WCTableSourceData *source = [WCTableSourceData new];
    
    {
        
    }
    
    return source;
}

- (void)reloadData
{
    [super reloadData];
}



@end
