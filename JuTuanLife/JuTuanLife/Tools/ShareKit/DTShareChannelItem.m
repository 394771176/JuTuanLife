//
//  DTShareChannelItem.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/15.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "DTShareChannelItem.h"

@implementation DTShareChannelItem

+ (DTShareChannelItem *)itemWithChannel:(DTShareChannel)channel
{
    DTShareChannelItem *item = [DTShareChannelItem new];
    return item;
}

- (void)setChannel:(DTShareChannel)channel
{
    _channel = channel;
    _title = [self.class titleWithChannel:channel];
    _icon = [UIImage imageNamed:[self imageNameForChannel]];
    _titleColor = [self titleColorForChannel];
    _isFunction = [self.class isFunctionForChannel:_channel];
}

- (void)setClearBgIcon:(BOOL)clearBgIcon
{
    _clearBgIcon = clearBgIcon;
    self.channel = _channel;
}

- (NSString *)imageNameForChannel
{
    switch (_channel) {
        case DTShareToWXHy:
        {
            if (_clearBgIcon) {
                return @"dt_share_wx_c";
            }
            return @"dt_share_wx";
        }
            break;
        case DTShareToWXPyq:
        {
            if (_clearBgIcon) {
                return @"dt_share_wxpyq_c";
            }
            return @"dt_share_wxpyq";
        }
            break;
        case DTShareToWXFav:
        {
            if (_clearBgIcon) {
                return @"dt_share_wxfav_c";
            }
            return @"dt_share_wxfav";
        }
            break;
        case DTShareToQQ:
        {
            if (_clearBgIcon) {
                return @"dt_share_txqq_c";
            }
            return @"dt_share_txqq";
        }
            break;
        case DTShareToQZone:
        {
            if (_clearBgIcon) {
                return @"dt_share_qzone_c";
            }
            return @"dt_share_qzone";
        }
            break;
        case DTShareToSina:
            if (_clearBgIcon) {
                return @"dt_share_sina_c";
            }
            return @"dt_share_sina";
            break;
        case DTShareToDownloadPhoto:
            return @"dt_share_download";
            break;
        case DTShareToCopyLink:
            return @"dt_share_copylink";
            break;
        case DTShareToRefresh:
            return @"dt_share_refresh";
            break;
        case DTShareToBrowser:
            return @"dt_share_safari";
            break;
        default:
            break;
    }
    return nil;
}

- (NSString *)channelCode
{
    switch (_channel) {
        case DTShareToWXHy:
            return @"WXHY";
            break;
        case DTShareToWXPyq:
            return @"WXPYQ";
            break;
        case DTShareToWXFav:
            return @"WXFAV";
            break;
        case DTShareToQQ:
            return @"QQ";
            break;
        case DTShareToQZone:
            return @"QZone";
            break;
        case DTShareToSina:
            return @"Sina";
            break;
        case DTShareToDownloadPhoto:
            return @"download";
            break;
        case DTShareToCopyLink:
            return @"copylink";
            break;
        case DTShareToRefresh:
            return @"refresh";
            break;
        case DTShareToBrowser:
            return @"safari";
            break;
        default:
            break;
    }
    return nil;
}

- (NSString *)titleColorForChannel
{
    return @"333333";
}

+ (int)sceneWithChannel:(DTShareChannel)channel
{
    switch (channel) {
        case DTShareToWXHy:
        case DTShareToQQ:
            return 0;
        case DTShareToWXPyq:
        case DTShareToQZone:
            return 1;
        case DTShareToWXFav:
            return 2;
        default:
            return 0;
            break;
    }
}

+ (BOOL)isFunctionForChannel:(DTShareChannel)channel
{
    switch (channel) {
        case DTShareToWXHy:
        case DTShareToWXPyq:
        case DTShareToWXFav:
        case DTShareToQQ:
        case DTShareToQZone:
        case DTShareToSina:
            return NO;
            break;
        default:
            return YES;
            break;
    }
}

@end
