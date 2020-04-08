//
//  JTUserAddBankController.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/9.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTUserBank.h"

KEY(JTUserAddBankController_ADD_BANK)

@interface JTUserAddBankController : DTTableController

@property (nonatomic, strong) JTUserBank *bank;

@end
