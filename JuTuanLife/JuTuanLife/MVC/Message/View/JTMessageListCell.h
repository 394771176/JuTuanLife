//
//  JTMessageListCell.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/8.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTMessageItem.h"
#import <UIKit/UIKit.h>

@interface JTMessageListCell : DTTitleContentCell

@property (nonatomic, strong) JTMessageItem *item;
@property (nonatomic, assign) NSInteger lastReadMsgId;

@end
