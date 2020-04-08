//
//  UIImageView+web.m
//  CLCommon
//
//  Created by lin on 13-11-20.
//  Copyright (c) 2013年 eclicks. All rights reserved.
//

#import "UIImageView+CLWebCache.h"
#import "SDWebImageManagerUtil.h"
#import "UIView+WebCache.h"
#import "objc/runtime.h"

//#import "BPExecutorService.h"
//#import "FLAnimatedImageView.h"
//#import <BPCommon/BPCommonMacro.h>
//#import "UIImage+ImageEffects.h"

static char cacheUrlKey;

@interface UIImageView ()

@property (nonatomic, strong) NSString *cacheUrl;

@end

@implementation UIImageView (CLWebCache)

- (void)setCacheUrl:(NSString *)cacheUrl
{
    objc_setAssociatedObject(self, &cacheUrlKey, cacheUrl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)cacheUrl
{
    return objc_getAssociatedObject(self, &cacheUrlKey);
}

#pragma mark - CLWebCache 便利方法

- (void)setImageWithURL:(NSURL *)url
{
    self.sd_imageTransition = [SDWebImageTransition fadeTransition];
    [self sd_setImageWithURL:url];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    self.sd_imageTransition = [SDWebImageTransition fadeTransition];
    [self sd_setImageWithURL:url placeholderImage:placeholder];
}

/**
 因为设置图片是在SDWebImage的SetImageBlock中设置的，往往没有动画的时候在执行completion的时候图片已经设置成功，但当增加动画的时候就会有图片赋值的延时
 但官方解释completedBlock只是说明是网络请求成功后就可以执行，所以就会产生使用动画效果导致我们原有代码的获取图片时有可能为空的情况
 故在有动画的时候需要动画执行完成在进行设置图片成功的block执行。
 
 如上述解释还不能达到使用时的预期，建议不使用动画或者自己实现动画的过程进行手动控制
 总之使用动画效果的时候注意这个坑，不知道后续SDWebImage会不会进行优化，毕竟如下的理解可能会有点歧义。
 
 *     completedBlock    A block called when operation has been completed. This block has no return value
 *                       and takes the requested UIImage as first parameter. In case of error the image parameter
 *                       is nil and the second parameter may contain an NSError. The third parameter is a Boolean
 *                       indicating if the image was retrieved from the local cache or from the network.
 *                       The fourth parameter is the original image url.
 */
- (void)setImageWithURL:(NSURL *)url success:(void (^)(UIImage *image))success failure:(void (^)(NSError *error))failure
{
    __weak UIImageView *weakSelf = self;
    self.sd_imageTransition = [SDWebImageTransition fadeTransition];
    self.sd_imageTransition.completion = ^(BOOL finished) {
        if (success) success(weakSelf.image);
    };
    [self sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!error) {
            if (cacheType != SDImageCacheTypeNone) {
                if (success) success(image);
            }
        } else {
            if (failure) failure(error);
        }
    }];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder success:(void (^)(UIImage *image))success failure:(void (^)(NSError *error))failure
{
    __weak UIImageView *weakSelf = self;
    self.sd_imageTransition = [SDWebImageTransition fadeTransition];
    self.sd_imageTransition.completion = ^(BOOL finished) {
        if (success) success(weakSelf.image);
    };
    [self sd_setImageWithURL:url placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!error) {
            if (cacheType != SDImageCacheTypeNone) {
                if (success) success(image);
            }
        } else {
            if (failure) failure(error);
        }
    }];
}

#pragma mark - 有圆角的的imageView 加载图片时自动切圆角存储

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder failedImage:(UIImage *)failedImage
{
    NSAssert(![self respondsToSelector:@selector(setAnimatedImage:)], @"should not be a FLAnimatedImageView,");
    [self setImageWithURL:url placeholderImage:placeholder failedImage:failedImage downloadTagStr:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder failedImage:(UIImage *)failedImage imgViewMode:(UIViewContentMode)mode
{
    NSAssert(![self respondsToSelector:@selector(setAnimatedImage:)], @"should not be a FLAnimatedImageView,");
    [self setImageWithURL:url placeholderImage:placeholder failedImage:failedImage downloadTagStr:nil];
    [self setContentMode:mode];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder failedImage:(UIImage *)failedImage downloadTagStr:(NSString *)tagStr
{
    NSAssert(![self respondsToSelector:@selector(setAnimatedImage:)], @"should not be a FLAnimatedImageView,");
    self.cacheUrl = nil;
    __weak UIImageView *weakSelf = self;
	NSString *cacheUrl = url.absoluteString;
    if (weakSelf.layer.cornerRadius>0) {
        //FIX: 如果图片初始化宽度和高度还为0的时候获取缓存图片会获取不到的问题
        CGSize size = self.frame.size;
		if (size.width>0 && size.height>0) {
			cacheUrl = [[url absoluteString] stringByAppendingFormat:@"_%.0fx%.0f_o%.0f", size.width, size.height, weakSelf.layer.cornerRadius];
		}
        if ([[SDWebImageManager sharedManager] hasCacheForURLStr:cacheUrl]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImage *image = [[SDWebImageManager sharedManager] cacheImageForURL:[NSURL URLWithString:cacheUrl]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //读缓存图片不加载淡入动画
                    weakSelf.image = image;
                });
            });
            return;
        }
    } else if (weakSelf.layer.cornerRadius==0) {
        if ([[SDWebImageManager sharedManager] hasCacheForURL:url]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImage *image = [[SDWebImageManager sharedManager] cacheImageForURL:url];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //读缓存图片不加载淡入动画
                    weakSelf.image = image;
                });
            });
            return;
        }
    }
    
    [self sd_setImageWithURL:url placeholderImage:placeholder options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        __strong UIImageView *strongSelf = weakSelf;
        if (!strongSelf) return;
        if (error==nil) {
            if (strongSelf.layer.cornerRadius>0) {
                strongSelf.image = placeholder;
                self.cacheUrl = cacheUrl;
                [strongSelf setCornerImage:image cacheUrl:cacheUrl];
                strongSelf.clipsToBounds = NO;
                
            } else {
                [strongSelf setImage:image];
                if (image!=strongSelf.image) {
                    [strongSelf setImage:image];
                }
            }
            //下载的图片 读缓存图片加载淡入动画
            [strongSelf startPushFadeTransition];
        } else {
            if (failedImage) {
                [strongSelf setImage:failedImage];
            }
        }
    }];
}

- (void)setCornerImage:(UIImage *)image cacheUrl:(NSString *)cacheUrl
{
    __block UIImageView *weakSelf = self;
    float cr = weakSelf.layer.cornerRadius;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *result = [SDWebImageManager getImageFrom:image targetSize:self.frame.size corner:cr];
        if (cacheUrl) {
            [[SDImageCache sharedImageCache] storeImage:result forKey:[[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:cacheUrl]] completion:nil];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong UIImageView *strongSelf = weakSelf;
            if (!strongSelf) return;
            if ([strongSelf.cacheUrl isEqualToString:cacheUrl]) {
                strongSelf.image = result;
            }
        });
    });
}

- (void)setCornerImage:(UIImage *)image
{
    [self setCornerImage:image cacheUrl:nil];
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
}

#pragma mark - 网络加载图片并做高斯模糊缓存显示

//- (void)setBlurImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
//{
//    NSAssert(![self respondsToSelector:@selector(setAnimatedImage:)], @"should not be a FLAnimatedImageView,");
//    self.cacheUrl = nil;
//    [self sd_cancelCurrentImageLoad];
//    __weak UIImageView *weakSelf = self;
//    NSString *cacheUrl = [NSString stringWithFormat:@"%@_blur", url.absoluteString];
//    if ([[SDWebImageManager sharedManager] hasCacheForURL:[NSURL URLWithString:cacheUrl]]) {
//        [BPExecutorService addBlockOnBackgroundThread:^{
//            UIImage *blurImage = [[SDWebImageManager sharedManager] cacheImageForURL:[NSURL URLWithString:cacheUrl]];
//            [BPExecutorService addBlockOnMainThread:^{
//                weakSelf.image = blurImage;
//            }];
//        }];
//    } else {
//        [self sd_setImageWithURL:url placeholderImage:placeholder options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
//        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            if (error==nil) {
//                [BPExecutorService addBlockOnBackgroundThread:^{
//                    UIImage *blurImage = [self accelerateBlurWithImage:image];
//                    [[SDWebImageManager sharedManager] saveImageToCache:blurImage forURL:[NSURL URLWithString:cacheUrl]];
//                    [BPExecutorService addBlockOnMainThread:^{
//                        weakSelf.image = blurImage;
//                    }];
//                }];
//            } else {
//                weakSelf.image = placeholder;
//            }
//        }];
//    }
//}
//
//- (void)setBlurDefaultImage:(UIImage *)defaultImage
//{
//    NSString *cacheUrl = @"https://www.chelun.com/default_blur";
//    __weak UIImageView *weakSelf = self;
//    if ([[SDWebImageManager sharedManager] hasCacheForURL:[NSURL URLWithString:cacheUrl]]) {
//        [BPExecutorService addBlockOnBackgroundThread:^{
//            UIImage *blurImage = [[SDWebImageManager sharedManager] cacheImageForURL:[NSURL URLWithString:cacheUrl]];
//            [BPExecutorService addBlockOnMainThread:^{
//                weakSelf.image = blurImage;
//            }];
//        }];
//    } else {
//        [BPExecutorService addBlockOnBackgroundThread:^{
//            UIImage *blurImage = [self accelerateBlurWithImage:defaultImage];
//            [[SDWebImageManager sharedManager] saveImageToCache:blurImage forURL:[NSURL URLWithString:cacheUrl]];
//            [BPExecutorService addBlockOnMainThread:^{
//                weakSelf.image = blurImage;
//            }];
//        }];
//    }
//}

#pragma mark - private

- (void)startPushFadeTransition
{
    CATransition *animation = [CATransition animation];
    [animation setType:kCATransitionFade];
    [animation setDuration:0.3f];
    [animation setRemovedOnCompletion:YES];
    [self.layer addAnimation:animation forKey:@"fade"];
}

//- (UIImage *)accelerateBlurWithImage:(UIImage *)image
//{
//    // R 15  F 1.0  C [UIColor colorWithWhite:0.2f alpha:0.2f]
//    return [image applyBlurWithRadius:15 tintColor:[UIColor colorWithWhite:0.0f alpha:0.3f] saturationDeltaFactor:1.0 maskImage:nil];
//}

@end

