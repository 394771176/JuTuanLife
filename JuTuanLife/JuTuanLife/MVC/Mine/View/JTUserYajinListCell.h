//
//  JTUserYajinListCell.h
//  JuTuanLife
//
//  Created by cheng on 2020/4/2.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTUserYajin.h"

@interface JTUserYajinListCell : DTTableCustomCell

@property (nonatomic, assign) BOOL isTitle;
@property (nonatomic, strong) JTUserYajin *item;

@end
