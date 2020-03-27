//
//  JTUserCenterModel.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/22.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTPosListDataModel.h"
#import "JTFenRunOverItem.h"
#import "JTShipItem.h"
#import "JTBusinessItem.h"

@interface JTUserCenterModel : JTPosListDataModel

@property (nonatomic, strong) NSString *userNo;

@property (nonatomic, assign) JTFenRunPeriod period;
//@property (nonatomic, strong) NSString *selectedDate;

@property (nonatomic, strong) JTFenRunOverItem *fenrun;

@end
