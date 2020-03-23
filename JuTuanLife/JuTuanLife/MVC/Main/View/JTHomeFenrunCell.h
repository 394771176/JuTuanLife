//
//  JTHomeFenrunCell.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/14.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "DTTableCustomCell.h"
#import "JTFenRunOverItem.h"

@interface JTHomeFenrunCell : DTTableCustomCell

@property (nonatomic, assign) JTFenRunPeriod period;
@property (nonatomic, strong) JTFenRunOverItem *item;

@property (nonatomic, strong) NSArray *itemList;

@property (nonatomic, assign) BOOL onlyFixPeriod;

@property (nonatomic, weak) id<DTTabBarViewDelegate> delegate;

+ (CGFloat)cellHeightWithItem:(id)item tableView:(UITableView *)tableView onlyFixPeriod:(BOOL)onlyFixPeriod;

@end
