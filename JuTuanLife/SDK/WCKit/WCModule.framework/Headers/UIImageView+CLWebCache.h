//
//  UIImageView+web.h
//  CLCommon
//
//  Created by lin on 13-11-20.
//  Copyright (c) 2013年 eclicks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface UIImageView (CLWebCache)

//additions
/*
 * 下面两个方法需要注意使用，在函数返回后，image并不是立即赋值给UIImageView的，是异步赋值给UIImageView。
 * 简单说就是不允许调用此方法后，立即去操作UIImageView的image，因为此时image肯定为空，加载缓存亦如此
 */
- (void)setImageWithURL:(NSURL *)url;
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;

- (void)setImageWithURL:(NSURL *)url success:(void (^)(UIImage *image))success failure:(void (^)(NSError *error))failure;
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder success:(void (^)(UIImage *image))success failure:(void (^)(NSError *error))failure;

#pragma mark - 有圆角的的UIImageView 加载图片时自动切圆角存储

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder failedImage:(UIImage *)failedImage;
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder failedImage:(UIImage *)failedImage imgViewMode:(UIViewContentMode)mode;
- (void)setCornerImage:(UIImage *)image;

#pragma mark - 网络加载图片并做高斯模糊缓存显示
//对高斯模糊图缓存
//- (void)setBlurImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
//- (void)setBlurDefaultImage:(UIImage *)defaultImage;

@end
