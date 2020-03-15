//
//  DTShareUtil.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/15.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "DTShareUtil.h"

@implementation DTShareUtil

+ (void)shareWithTitle:(NSString *)title item:(DTShareItem *)item;
{
    
}

+ (void)shareItem:(DTShareItem *)item channel:(DTShareChannel)channel
{
    [self shareItem:item channelItem:[DTShareChannelItem itemWithChannel:channel]];
}

+ (void)shareItem:(DTShareItem *)item channelItem:(DTShareChannelItem *)channelItem
{
    void (^callback)(BOOL success, id responseObject) = ^(BOOL success, id responseObject) {
        if (success) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:APP_EVENT_KJZ_SHARE_DID_SUCCESS object:nil];
        } else {
            if (responseObject&&[responseObject isKindOfClass:[NSString class]]) {
                [DTPubUtil showHUDErrorHintInWindow:responseObject];
            } else {
                [DTPubUtil showHUDErrorHintInWindow:@"分享失败"];
            }
        }
    };
    
    DTShareChannel channel = channelItem.channel;
    switch (channel) {
        case DTShareToWXHy:
        case DTShareToWXPyq:
        case DTShareToWXFav:
        {
            int scene = [DTShareChannelItem sceneWithChannel:channel];
            [[FFWechatManager sharedInstance] share:item scene:scene callback:callback];
        }
            
        case DTShareToQQ:
        case DTShareToQZone:
        {
//            int scene = [DTShareChannelItem sceneWithChannel:channel];
        }
            break;
        case DTShareToSina:
            
            break;
        case DTShareToDownloadPhoto:
            
            break;
        case DTShareToCopyLink:
            if (item.copyLink.length) {
                [[UIPasteboard generalPasteboard] setString:item.copyLink];
                [DTPubUtil showHUDSuccessHintInWindow:@"已复制到粘贴板"];
            }
            break;
        case DTShareToRefresh:
            
            break;
        case DTShareToBrowser:
            
            break;
        default:
            break;
    }
}

@end
