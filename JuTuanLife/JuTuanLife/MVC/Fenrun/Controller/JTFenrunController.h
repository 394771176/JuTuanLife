//
//  JTFenrunController.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/21.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTFenRunOverItem.h"

@interface JTFenrunController : DTHttpRefreshLoadMoreTableController

@property (nonatomic, assign) JTFenRunPeriod period;
@property (nonatomic, strong) NSArray *fenrunForAll;

@end
