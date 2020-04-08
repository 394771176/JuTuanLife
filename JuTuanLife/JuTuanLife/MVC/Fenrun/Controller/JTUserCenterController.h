//
//  JTUserCenterController.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/22.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTUserCenterModel.h"

@interface JTUserCenterController : DTHttpTableController

@property (nonatomic, assign) JTFenRunPeriod period;
@property (nonatomic, strong) NSString *userNo;
@property (nonatomic, strong) JTUser *user;

@end
