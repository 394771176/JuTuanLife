//
//  JTFenRunModel.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/21.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTPosListDataModel.h"
#import "JTFenRunOverItem.h"
#import "JTShipItem.h"

@interface JTFenRunModel : JTPosListDataModel

@property (nonatomic, assign) JTFenRunPeriod period;
@property (nonatomic, strong) NSString *selectedDate;

@property (nonatomic, strong) JTFenRunOverItem *fenrun;

@end
