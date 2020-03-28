//
//  JTMessageListModel.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/8.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTPosListDataModel.h"
#import "JTMessageItem.h"

@interface JTMessageListModel : JTPosListDataModel

@property (nonatomic, assign) NSInteger lastReadMsgId;

@end
