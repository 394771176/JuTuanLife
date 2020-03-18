//
//  JTShipListModel.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/8.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTPosListDataModel.h"
#import "JTShipItem.h"

@interface JTShipListModel : JTPosListDataModel

@property (nonatomic, strong) NSArray<JTShipItem *> *teachers;
@property (nonatomic, assign) NSInteger masterNum;
@property (nonatomic, assign) NSInteger apprenticeNum;

@end
