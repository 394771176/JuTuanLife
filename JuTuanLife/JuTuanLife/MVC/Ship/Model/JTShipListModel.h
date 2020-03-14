//
//  JTShipListModel.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/8.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <WCModel/DTListDataModel.h>
#import "JTShipItem.h"

@interface JTShipListModel : DTListDataModel

@property (nonatomic, strong) NSArray<JTShipItem *> *teachers;

@end
