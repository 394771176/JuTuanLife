//
//  UIImageView+WebImage.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/22.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (WebImage)

- (void)setImageWithURLStr:(NSString *)urlStr;

- (void)setImageWithURLStr:(NSString *)urlStr placeholderImage:(UIImage *)placeholder;
- (void)setImageWithURLStr:(NSString *)urlStr placeholderImageName:(NSString *)placeholderImageName;

- (void)setImageWithURLStr:(NSString *)urlStr placeholderImage:(UIImage *)placeholder failedImage:(UIImage *)failedImage;
- (void)setImageWithURLStr:(NSString *)urlStr placeholderImageName:(NSString *)placeholderName failedImageName:(NSString *)failedImageName;

- (void)setImageWithURLStr:(NSString *)urlStr success:(void (^)(UIImage *))success failure:(void (^)(NSError *))failure;

@end
