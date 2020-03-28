//
//  JTBusinessFenrunCell.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/28.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "DTTableCustomCell.h"
#import "DTTitleContentCell.h"
#import "JTBusinessFenRunItem.h"

@interface JTBusinessFenrunCell : DTTitleContentCell

@property (nonatomic, strong) JTBusinessFenRunTitleItem *titleItem;
@property (nonatomic, strong) JTBusinessFenRunItem *item;


@end
