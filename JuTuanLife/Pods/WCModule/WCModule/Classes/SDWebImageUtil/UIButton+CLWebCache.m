//
//  UIButton+web.m
//  CLCommon
//
//  Created by wangpeng on 14-6-28.
//  Copyright (c) 2014年 eclicks. All rights reserved.
//

#import "UIButton+CLWebCache.h"
#import "UIButton+WebCache.h"
#import "UIView+WebCache.h"
#import "SDWebImageManagerUtil.h"
#import "objc/runtime.h"

static char cacheUrlKey;

@interface UIButton ()

@property (nonatomic, strong) NSString *cacheUrl;

@end

@implementation UIButton (CLWebCache)

- (void)setCacheUrl:(NSString *)cacheUrl
{
    objc_setAssociatedObject(self, &cacheUrlKey, cacheUrl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)cacheUrl
{
    return objc_getAssociatedObject(self, &cacheUrlKey);
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    self.sd_imageTransition = [SDWebImageTransition fadeTransition];
    [self sd_setImageWithURL:url forState:UIControlStateNormal placeholderImage:placeholder];
}

- (void)setBackgroundImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    self.sd_imageTransition = [SDWebImageTransition fadeTransition];
    [self sd_setBackgroundImageWithURL:url forState:UIControlStateNormal placeholderImage:placeholder];
}

#pragma mark - image 加圆角

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder failedImage:(UIImage *)failedImage
{
    self.cacheUrl = nil;
    [self sd_cancelImageLoadForState:UIControlStateNormal];
    WEAK_SELF
    NSString *cacheUrl = nil;
    if (weakSelf.layer.cornerRadius>0) {
        cacheUrl = [[url absoluteString] stringByAppendingFormat:@"_%.0fx%.0f_o%.0f", weakSelf.width, weakSelf.height, weakSelf.cornerRadius];
        if (cacheUrl&&[[SDWebImageManager sharedManager] hasCacheForURLStr:cacheUrl]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImage *image = [[SDWebImageManager sharedManager] cacheImageForURLStr:cacheUrl];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //读缓存图片不加载淡入动画
                    [weakSelf setImage:image forState:UIControlStateNormal];
                });
            });
            return;
        }
    } else if (weakSelf.layer.cornerRadius==0) {
        if (url&&[[SDWebImageManager sharedManager] hasCacheForURL:url]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImage *image = [[SDWebImageManager sharedManager] cacheImageForURL:url];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf setImage:image forState:UIControlStateNormal];
                });
            });
            return;
        }
    }
    
    self.clipsToBounds = YES;
    
    [self sd_setImageWithURL:url forState:UIControlStateNormal placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        __strong UIButton *strongSelf = weakSelf;
        if (!strongSelf) return;
        if (!error) {
            if (strongSelf.layer.cornerRadius>0) {
                [strongSelf setImage:placeholder forState:UIControlStateNormal];
                self.cacheUrl = cacheUrl;
                [strongSelf setCornerImage:image cacheUrl:cacheUrl];
            } else {
                if (image!=[strongSelf imageForState:UIControlStateNormal]) {
                    [strongSelf setImage:image forState:UIControlStateNormal];
                }
                strongSelf.clipsToBounds = NO;
            }
            [self startPushFadeTransition];
        } else {
            strongSelf.clipsToBounds = NO;
        }
    }];
}

- (void)setCornerImage:(UIImage *)image cacheUrl:(NSString *)cacheUrl
{
    __block UIButton *weakSelf = self;
    float cr = weakSelf.layer.cornerRadius;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *result = [SDWebImageManager getImageFrom:image targetSize:self.size corner:cr];
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong UIButton *strongSelf = weakSelf;
            if (!strongSelf) return;
            if ([strongSelf.cacheUrl isEqualToString:cacheUrl]) {
                [strongSelf setImage:result forState:UIControlStateNormal];
                strongSelf.clipsToBounds = NO;
            }
        });
    });
}

- (void)setCornerImage:(UIImage *)image
{
    [self setCornerImage:image cacheUrl:nil];
}

#pragma mark - private

- (void)startPushFadeTransition
{
    CATransition *animation = [CATransition animation];
    [animation setType:kCATransitionFade];
    [animation setDuration:0.3f];
    [animation setRemovedOnCompletion:YES];
    [self.layer addAnimation:animation forKey:@"fade"];
}

@end
