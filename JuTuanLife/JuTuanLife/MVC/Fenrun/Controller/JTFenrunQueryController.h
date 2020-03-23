//
//  JTFenrunQueryController.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/23.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "DTHttpRefreshLoadMoreTableController.h"
#import "JTFenRunOverItem.h"

@interface JTFenrunQueryController : DTHttpRefreshLoadMoreTableController

@property (nonatomic, assign) JTFenRunPeriod period;

@end
