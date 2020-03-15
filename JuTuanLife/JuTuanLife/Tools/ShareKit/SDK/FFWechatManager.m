//
//  FFWechatManager.m
//  FFStory
//
//  Created by PageZhang on 16/3/9.
//  Copyright © 2016年 Chelun. All rights reserved.
//

#import "FFWechatManager.h"

#define APP_WECHAT_KJZ_UNIVERSAL_LINK  @"https://xch5.chelun.com/applinks/kjz/"
#define APP_CONST_MINIPROGRAM_USERNAME          @""   //7.2.0版本替换

@interface FFWechatManager ()
{
    NSString *_appKey,*_appSecret;
}
@end

@implementation FFWechatManager

+ (instancetype)sharedInstance {
    static __strong FFWechatManager *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [self.class new];
    });
    return _instance;
}

- (void)configWithAppKey:(NSString *)appKey appSecret:(NSString *)appSecret {
    _appKey = appKey;
    _appSecret = appSecret;
    [WXApi registerApp:_appKey];
//    [WXApi registerApp:_appKey universalLink:APP_WECHAT_KJZ_UNIVERSAL_LINK];
    NSLog(@"====wxapi version : %@====", [WXApi getApiVersion]);
}

// 所有操作必须确保可用
+ (BOOL)isAvaliable {
    return [WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi];
}

- (void)auth:(FFReqCallback)callback {
    
    if (![DTReachabilityUtil sharedInstance].isReachable) {
        if (callback) {
            callback(NO, @"网络异常");
        }
        return;
    }
    
    
    if(![FFWechatManager isAvaliable]) {
        if (callback) {
            callback(NO, @"你还没有安装微信");
        }
        return;
    }
    
    _callback = callback;
    // 消息结构体
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo";
    [WXApi sendReq:req];
//    [WXApi sendReq:req completion:^(BOOL success) {
//
//    }];
}

- (void)share:(DTShareItem *)obj scene:(int)scene callback:(FFReqCallback)callback
{
    if(![FFWechatManager isAvaliable]) {
        if (callback) {
            callback(NO, @"你还没有安装微信");
        }
        return;
    }
    
    _callback = callback;
    // 消息结构体
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.scene = scene;
    
    // 多媒体内容
    id mediaObject = nil;
    switch (obj.contentType) {
        case DTShareContentTypeText: {
            // 文本内容
            req.bText = YES;
            if (obj.desc.length > 10240) {
                obj.desc = [obj.desc substringToIndex:10240];
            }
            req.text = obj.desc;
        } break;
        case DTShareContentTypePhoto: {
            WXImageObject *imageObject = [WXImageObject object];
            imageObject.imageData = UIImageJPEGRepresentation(obj.image, 0.8);
            mediaObject = imageObject;
        } break;
        case DTShareContentTypeMusic: {
            WXMusicObject *musicObject = [WXMusicObject object];
            musicObject.musicUrl = obj.link;
            musicObject.musicDataUrl = obj.dataUrl;
            mediaObject = musicObject;
        } break;
        case DTShareContentTypeVideo: {
            WXVideoObject *videoObject = [WXVideoObject object];
            videoObject.videoUrl = obj.link;
            mediaObject = videoObject;
        } break;
        case DTShareContentTypeWebPage: {
            WXWebpageObject *webPageObject = [WXWebpageObject object];
            webPageObject.webpageUrl = obj.link;
            mediaObject = webPageObject;
        } break;
        case DTShareContentTypeMiniProgram:
        {
            WXMiniProgramObject *ext = [WXMiniProgramObject object];
            ext.path = obj.miniprogramPath;
            if (obj.miniprogramUserName.length) {
                ext.userName = obj.miniprogramUserName;
            } else {
                ext.userName = APP_CONST_MINIPROGRAM_USERNAME;
            }

            if (obj.miniprogramDownloadUrl.length) {
                ext.webpageUrl = obj.miniprogramDownloadUrl;
            }
            UIImage *hdImage = [self getImageForMinProWith:obj.image];
            if (hdImage) {
                NSData *data = UIImageJPEGRepresentation(hdImage, 0.8);
                //不用1024，用1000, 这样确保转换后小于120k
                CGFloat rate = ceil(data.length * 1.f/1000/120);
                CGFloat i = 100;
                while (data.length * 1.f / 1000 > 120 && i > 5) {
                    data = UIImageJPEGRepresentation(hdImage, 0.8/rate * (i / 100.f));
                    i -= 5;
                }
                ext.hdImageData = data;
            }
            
//            ext.withShareTicket = withShareTicket;
        
#ifdef DEBUG
//            ext.miniProgramType = WXMiniProgramTypeTest;
//            ext.miniProgramType = WXMiniProgramTypePreview;
#else
//            ext.miniProgramType = WXMiniProgramTypeRelease;
#endif
            mediaObject = ext;
        }
            break;
        default:
            break;
    }
    
    if (mediaObject) {
        // 多媒体信息
        WXMediaMessage *message = [WXMediaMessage message];
        message.mediaObject = mediaObject;
        
        if (obj.contentType != DTShareContentTypePhoto) {
            message.title = obj.title;
            message.description = obj.desc;
            [message setThumbImage:obj.thumbImage];
        }
        
        req.message = message;
    }
    
    if (obj.contentType == DTShareContentTypeText) {
        
    } else {
        
        
        
        
        // 多媒体描述内容
//        if (obj.type != FFShareContentTypeImage) {
//            if (obj.scene==WXSceneTimeline && obj.type!=FFShareContentTypeMusic) {
//                message.title = [[obj pyqText] limit:512];
//            } else {
//                message.title = [obj.title limit:512];
//                message.description = [obj.desc limit:1024];
//            }
//        }
//        [message setThumbImage:obj.thumbImage];
    }
    [WXApi sendReq:req];
//    [WXApi sendReq:req completion:^(BOOL success) {
//
//    }];
}

- (UIImage *)getImageForMinProWith:(UIImage *)image
{
    if (!image) {
        return nil;
    }
    UIImage *result = nil;
    //小程序图片限制120k
    if (image.size.width > 480) {
        result = [image resizeToSize:CGSizeMake(480, image.size.height / image.size.width * 480)];
    } else {
        result = image;
    }
    //确保图片按照一定比例5:4
    CGSize size = result.size;
    CGFloat fixHeight = size.width / 5 * 4;
    if (size.height < fixHeight) {
        if (size.height < fixHeight / 1.5) {
            //小于三分之二 裁剪
            CGFloat cgWidth = CGImageGetWidth(result.CGImage);
            CGFloat cgHeight = CGImageGetHeight(result.CGImage);
            CGFloat width = cgHeight / 4 * 5;
            result = [result subImageFromRect:CGRectMake((cgWidth - width) / 2, 0, width, cgHeight)];
        } else {
            //底部 补齐
            UIImage *whiteImage = [UIImage imageWithColor:[UIColor whiteColor] cornerRadius:0 withSize:CGSizeMake(size.width, (fixHeight - size.height))];
            result = [result addImageToBottom:whiteImage];
        }
    } else {
        CGFloat cgWidth = CGImageGetWidth(result.CGImage);
        CGFloat cgHeight = CGImageGetHeight(result.CGImage);
        CGFloat height = cgWidth / 5 * 4;
        result = [result subImageFromRect:CGRectMake(0, (cgHeight - height) / 2, cgWidth, height)];
    }
    
    return result;
}

- (void)authWithWXAccess:(void (^)(CLWXAccess *, NSString *))accessBlock
{
    void (^block)(CLWXAccess *access, NSString *) = ^(CLWXAccess * access, NSString *error){
        if (accessBlock) {
            accessBlock(access, error);
        }
    };
    [self auth:^(BOOL success, id responseObject) {
        NSString *code = responseObject;
        if (success && [code isKindOfClass:[NSString class]]) {
            [JTService addBlockOnGlobalThread:^{
                NSDictionary *result = [self requestWXAssessWithCode:code];
                CLWXAccess *access = [CLWXAccess itemFromDict:result];
                [JTService addBlockOnMainThread:^{
                    if (access.openid.length) {
                        block(access, nil);
                    } else {
                        block(nil, @"授权失败");
                    }
                }];
            }];
        } else {
            block(nil, responseObject);
        }
    }];
}

- (void)authWithWXAccessUserInfo:(void (^)(CLWXAccess *, CLWXAccessUserInfo *, NSString *))accessBlock
{
    void (^block)(CLWXAccess *access, CLWXAccessUserInfo *userInfo, NSString *) = ^(CLWXAccess *access, CLWXAccessUserInfo *userInfo, NSString *error){
        if (accessBlock) {
            accessBlock(access, userInfo, error);
        }
    };
    [self authWithWXAccess:^(CLWXAccess *access, NSString *error) {
        if (access) {
            [JTService addBlockOnGlobalThread:^{
                NSDictionary *result = [self requestWXUserInfoWithOpenId:access.openid acToken:access.access_token];
                CLWXAccessUserInfo *userInfo = [CLWXAccessUserInfo itemFromDict:result];
                if (userInfo && userInfo.nickname) {
                    userInfo.nickname = [[self class] _859ToUTF8:userInfo.nickname];
                }
                [JTService addBlockOnMainThread:^{
                    block(access, userInfo, nil);
                }];
            }];
        } else {
            block(nil, nil, error);
        }
    }];
}

- (NSString *)responseObjectFromSuccessResp:(BaseResp *)resp
{
    id responseObject = nil;
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        // 授权回调
        SendAuthResp *temp = (SendAuthResp *)resp;
        responseObject = temp.code;
        
        if (!responseObject) {
            responseObject = @"微信授权失败";
        }
    }
    return responseObject;
}

#pragma mark - Delegates
- (void)onResp:(BaseResp *)resp {
    id responseObject = nil;
    if (resp.errCode == WXSuccess) {
        responseObject = [self responseObjectFromSuccessResp:resp];
    }
    // 回调
    if (_callback) {
        _callback(resp.errCode==WXSuccess, responseObject);
        _callback = nil;
    }
}

+ (NSString *)_859ToUTF8:(NSString *)oldStr
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingISOLatin1);
    
    return [NSString stringWithUTF8String:[oldStr cStringUsingEncoding:enc]];
}

- (id)requestWXAssessWithCode:(NSString *)code
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_appKey forKey:@"appid"];
    [params setObject:_appSecret forKey:@"secret"];
    [params setObject:code forKey:@"code"];
    [params setObject:@"authorization_code" forKey:@"grant_type"];
    BPURLRequest *req = [BPURLRequest getRequestWithParams:params httpMethod:@"GET" delegate:nil requestURL:@"https://api.weixin.qq.com/sns/oauth2/access_token"];
    NSDictionary *res = [req startSynchronous];
    return res;
}

- (id)requestWXUserInfoWithOpenId:(NSString *)openId acToken:(NSString *)ac_token
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:openId forKey:@"openid"];
    [params setObject:ac_token forKey:@"access_token"];
    BPURLRequest *req = [BPURLRequest getRequestWithParams:params httpMethod:@"GET" delegate:nil requestURL:@"https://api.weixin.qq.com/sns/userinfo"];
    NSDictionary *res = [req startSynchronous];
    return res;
}

@end
