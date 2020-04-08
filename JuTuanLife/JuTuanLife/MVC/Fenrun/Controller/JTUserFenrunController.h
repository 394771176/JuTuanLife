//
//  JTFenrunDetailController.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/27.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTUserFenrunModel.h"

@interface JTUserFenrunController : DTHttpRefreshLoadMoreTableController

@property (nonatomic, assign) JTFenRunPeriod period;
@property (nonatomic, strong) NSString *selectedDate;

@property (nonatomic, strong) JTUser *user;

@end
