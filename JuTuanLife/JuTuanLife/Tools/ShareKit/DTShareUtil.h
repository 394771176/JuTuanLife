//
//  DTShareUtil.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/15.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTShareItem.h"
#import "FFWechatManager.h"

@interface DTShareUtil : NSObject

+ (void)shareWithTitle:(NSString *)title item:(DTShareItem *)item;

+ (void)shareItem:(DTShareItem *)item channel:(DTShareChannel)channel;
+ (void)shareItem:(DTShareItem *)item channelItem:(DTShareChannelItem *)channelItem;

@end
