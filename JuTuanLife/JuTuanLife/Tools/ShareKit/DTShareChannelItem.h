//
//  DTShareChannelItem.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/15.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, DTShareChannelType) {
    DTShareChannelNone      = 0,
    DTShareChannelWechat    = 1 << 0,
    DTShareChannelTimeline  = 1 << 1,
    DTShareChannelWxFav     = 1 << 2,
    DTShareChannelQQ        = 1 << 3,
    DTShareChannelQzone     = 1 << 4,
    DTShareChannelSina      = 1 << 5,
    DTShareChannelFunction  = 1 << 7, //帖子相关功能 + webview 相关功能 等
    
    DTShareChannelTypeDefault = DTShareChannelWechat | DTShareChannelTimeline | DTShareChannelWxFav | DTShareChannelQQ | DTShareChannelSina,
    DTShareChannelTypeAll = DTShareChannelTypeDefault | DTShareChannelFunction,
    DTShareChannelTypeSocialNoFav = DTShareChannelWechat | DTShareChannelTimeline | DTShareChannelQQ | DTShareChannelSina,
    DTShareChannelTypeSocialQzoneNofav = DTShareChannelWechat | DTShareChannelTimeline | DTShareChannelQQ | DTShareChannelQzone | DTShareChannelSina,
};

typedef NS_ENUM(NSInteger, DTShareChannel) {
    DTShareToWXHy,
    DTShareToWXPyq,
    DTShareToWXFav,
    DTShareToSina,
    DTShareToQQ,
    DTShareToQZone,
    DTShareToMessage,
    DTShareToDownloadPhoto,
    DTShareToCopyLink,
    DTShareToBrowser,
    DTShareToRefresh,
};

@interface DTShareChannelItem : NSObject

@property (nonatomic, assign) DTShareChannel channel;

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) UIImage *icon;
@property (nonatomic, readonly) NSString *titleColor;
@property (nonatomic, readonly) BOOL isFunction;

@property (nonatomic) BOOL clearBgIcon;

- (NSString *)channelCode;

+ (DTShareChannelItem *)itemWithChannel:(DTShareChannel)channel;
+ (NSString *)titleWithChannel:(DTShareChannel)channel;

//是否功能
+ (BOOL)isFunctionForChannel:(DTShareChannel)channel;

+ (int)sceneWithChannel:(DTShareChannel)channel;

@end
