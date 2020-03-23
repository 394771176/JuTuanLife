//
//  UIButton+WebImage.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/22.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "UIButton+WebImage.h"
#import "UIImage+WebImageUI.h"

@implementation UIButton (WebImage)

- (void)setImageWithURLStr:(NSString *)urlStr placeholderImage:(UIImage *)placeholder
{
    [self setImageWithURL:[self urlForStr:urlStr] placeholderImage:placeholder];
}

- (void)setImageWithURLStr:(NSString *)urlStr placeholderImageName:(NSString *)placeholderName
{
    [self setImageWithURLStr:urlStr placeholderImage:[UIImage imageForName:placeholderName]];
}

- (void)setImageWithURLStr:(NSString *)urlStr placeholderImage:(UIImage *)placeholder failedImage:(UIImage *)failedImage
{
    [self setImageWithURL:[self urlForStr:urlStr] placeholderImage:placeholder failedImage:failedImage];
}

- (void)setImageWithURLStr:(NSString *)urlStr placeholderImageName:(NSString *)placeholderName failedImageName:(NSString *)failedImageName
{
    [self setImageWithURLStr:urlStr placeholderImage:[UIImage imageForName:placeholderName] failedImage:[UIImage imageForName:failedImageName]];
}

@end
