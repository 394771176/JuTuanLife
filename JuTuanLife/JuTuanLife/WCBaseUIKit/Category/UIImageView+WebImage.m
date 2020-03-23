//
//  UIImageView+WebImage.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/22.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "UIImageView+WebImage.h"
#import "UIImage+WebImageUI.h"

@implementation UIImageView (WebImage)

- (void)setImageWithURLStr:(NSString *)urlStr
{
    [self setImageWithURL:[self urlForStr:urlStr]];
}

- (void)setImageWithURLStr:(NSString *)urlStr placeholderImage:(UIImage *)placeholder
{
    [self setImageWithURL:[self urlForStr:urlStr] placeholderImage:placeholder];
}

- (void)setImageWithURLStr:(NSString *)urlStr placeholderImageName:(NSString *)placeholderImageName
{
    [self setImageWithURLStr:urlStr placeholderImage:[UIImage imageForName:placeholderImageName]];
}

- (void)setImageWithURLStr:(NSString *)urlStr placeholderImage:(UIImage *)placeholder failedImage:(UIImage *)failedImage
{
    [self setImageWithURL:[self urlForStr:urlStr] placeholderImage:placeholder failedImage:failedImage];
}

- (void)setImageWithURLStr:(NSString *)urlStr placeholderImageName:(NSString *)placeholderName failedImageName:(NSString *)failedImageName
{
    [self setImageWithURLStr:urlStr placeholderImage:[UIImage imageForName:placeholderName] failedImage:[UIImage imageForName:failedImageName]];
}

- (void)setImageWithURLStr:(NSString *)urlStr success:(void (^)(UIImage *))success failure:(void (^)(NSError *))failure
{
    [self setImageWithURL:[self urlForStr:urlStr] success:success failure:failure];
}

@end
