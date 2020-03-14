//
//  JTBusinessItem.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/14.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <WCModel/WCBaseEntity.h>

@interface JTBusinessItem : WCBaseEntity

@property (nonatomic, strong) NSString *itemId;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *content;

@property (nonatomic, strong) NSString *jump_url;

@end
