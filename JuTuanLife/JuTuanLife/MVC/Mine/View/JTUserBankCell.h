//
//  JTUserBankCell.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/9.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "DTTableCustomCell.h"
#import "JTUserBank.h"

@interface JTUserBankCell : DTTableCustomCell

@property (nonatomic, strong) JTUserBank *item;
@property (nonatomic, weak) id<DTTableButtonCellDelegate> delegate;

@end
