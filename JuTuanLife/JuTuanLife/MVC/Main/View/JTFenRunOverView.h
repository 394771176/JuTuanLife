//
//  JTFenRunView.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/20.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTFenRunOverItem.h"

@interface JTFenRunOverView : UIView

@property (nonatomic, assign) JTFenRunPeriod period;
@property (nonatomic, strong) JTFenRunOverItem *item;

@end
