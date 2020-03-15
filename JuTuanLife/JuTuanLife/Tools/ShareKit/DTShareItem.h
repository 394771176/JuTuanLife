//
//  DTShareItem.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/15.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTShareChannelItem.h"

typedef NS_ENUM(NSUInteger, DTShareContentType) {
    DTShareContentTypeAuto, //根据内容自动，图片+文字+链接 小程序 自由组合
    DTShareContentTypeText,
    DTShareContentTypePhoto,
    DTShareContentTypeWebPage,
    DTShareContentTypeMusic,
    DTShareContentTypeVideo,
    DTShareContentTypeMiniProgram,
};

@class DTShareItem;

typedef DTShareItem * (^DTShareItemkBlock)(DTShareChannelItem *channel);

typedef void(^FFReqCallback)(BOOL success, id responseObject);

typedef void (^DTShareClickBlock)(DTShareChannelItem *channel);
typedef void (^DTShareSuccessBlock)(DTShareChannelItem *channel);

@interface DTShareItem : NSObject

@property (nonatomic, assign) DTShareChannel channelType;

@property (nonatomic, assign) DTShareContentType contentType;//default is auto

@property (nonatomic, strong) NSString *title;
@property (nonatomic, copy) NSString *desc;

@property (nonatomic, strong) NSString *text;//拷贝文案, 可以没有
@property (nonatomic, strong) NSString *copyLink;//拷贝链接, 可以没有

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *imageUrl;

@property (nonatomic, strong) UIImage *thumbImage;//缩略图标，可以没有

@property (nonatomic, strong) NSString *link;

@property (nonatomic, copy) NSString *dataUrl; // 微信 - music

@property (nonatomic, strong) NSString *miniprogramUserName;
@property (nonatomic, strong) NSString *miniprogramPath;
@property (nonatomic, strong) NSString *miniprogramDownloadUrl;

@property (nonatomic, strong) id userInfo;

@property (nonatomic, strong) DTShareClickBlock clickBlock;
@property (nonatomic, strong) DTShareSuccessBlock successBlock;

@end
