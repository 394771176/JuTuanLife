//
//  JTBusinessFenrunController.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/28.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTBusinessFenrunModel.h"

@interface JTBusinessFenrunController : DTHttpRefreshLoadMoreTableController

@property (nonatomic, strong) NSString *businessCode;

@property (nonatomic, assign) JTFenRunPeriod period;

@property (nonatomic, strong) JTBusinessItem *business;

@end
