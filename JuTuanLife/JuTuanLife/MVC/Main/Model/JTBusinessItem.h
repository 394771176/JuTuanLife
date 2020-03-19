//
//  JTBusinessItem.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/14.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <WCModel/WCBaseEntity.h>

@interface JTBusinessItem : WCBaseEntity

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *slogan;

@property (nonatomic, strong) NSString *introImage;

@property (nonatomic, assign) CGFloat commissionRate;
@property (nonatomic, assign) CGFloat masterComRate;
@property (nonatomic, assign) CGFloat shiYeComRate;

@property (nonatomic, strong) NSString *entryUrl;

@end
