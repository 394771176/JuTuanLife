//
//  JTBaseConfig.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/22.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <WCModel/WCModel.h>

@interface JTBaseConfig : WCBaseEntity

@property (nonatomic, strong) NSString *about_us_url;
@property (nonatomic, strong) NSArray *h5_domain_whitelist;
@property (nonatomic, strong) NSString *deposit_deduct_text;

@end
