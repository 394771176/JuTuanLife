//
//  JTMineHeaderView.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/7.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTLoginHeaderView.h"
#import "JTUserHeaderView.h"
#import "JTUser.h"

@interface JTMineHeaderView : UIView

@property (nonatomic, strong) JTUserHeaderView *headerView;

@property (nonatomic, strong) JTUser *user;

@end
