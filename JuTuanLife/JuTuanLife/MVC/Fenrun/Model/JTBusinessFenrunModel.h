//
//  JTBusinessFenrunModel.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/28.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTPosListDataModel.h"
#import "JTBusinessItem.h"
#import "JTFenRunOverItem.h"
#import "JTBusinessFenRunItem.h"

@interface JTBusinessFenrunModel : JTPosListDataModel

@property (nonatomic, strong) NSString *businessCode;
@property (nonatomic, assign) JTFenRunPeriod period;

@property (nonatomic, strong) JTBusinessFenRunTitleItem *businessFenRunTitle;

@end
