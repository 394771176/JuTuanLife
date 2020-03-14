//
//  JTShipListCell.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/8.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "DTTableCustomCell.h"
#import "JTShipItem.h"

@interface JTShipListCell : DTTableCustomCell

@property (nonatomic, strong) JTShipItem *item;

@end
