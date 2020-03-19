//
//  JTHomeListModel.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/19.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <WCModel/WCModel.h>
#import "JTBusinessItem.h"
#import "JTFenRunOverItem.h"

@interface JTHomeListModel : DTListDataModel

@property (nonatomic, assign) JTFenRunPeriod period;
@property (nonatomic, strong) JTFenRunOverItem *fenrun;

@end
