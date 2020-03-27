//
//  JTBusinessFenrunController.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/28.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTBusinessFenrunController.h"

@interface JTBusinessFenrunController ()

@end

@implementation JTBusinessFenrunController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"%@业绩", _business.name];
}

- (void)setBusiness:(JTBusinessItem *)business
{
    _business = business;
    _businessCode = business.code;
}

- (DTListDataModel *)createDataModel
{
    JTBusinessFenrunModel *model = [[JTBusinessFenrunModel alloc] initWithFetchLimit:20 delegate:self];
    model.businessCode = _businessCode;
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
