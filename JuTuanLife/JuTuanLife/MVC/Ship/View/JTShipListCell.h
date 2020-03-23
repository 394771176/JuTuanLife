//
//  JTShipListCell.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/8.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "DTTableCustomCell.h"
#import "JTShipItem.h"

typedef NS_ENUM(NSUInteger, JTShipCellType) {
    JTShipCellTypeShip,
    JTShipCellTypeFenrun,
};

@interface JTShipListCell : DTTableCustomCell

@property (nonatomic, strong) JTShipItem *item;
@property (nonatomic, assign) JTShipCellType cellType;

@end
