//
//  UIImage+WebImageUI.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/22.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "UIImage+WebImageUI.h"

@implementation UIImage (WebImageUI)

+ (UIImage *)imageForName:(NSString *)string
{
    if (!string.length) {
        return nil;
    }
    return [UIImage imageNamed:string];
}

+ (NSURL *)imageUrlFromString:(NSString *)string
{
    return [self imageUrlFromString:string size:CGSizeZero];
}

+ (NSURL *)imageUrlFromString:(NSString *)string size:(CGSize)size
{
    if (!string.length) {
        return nil;
    }
    return [NSURL URLWithString:string];
}

@end

@implementation UIView (WebImageUI)

- (NSURL *)urlForStr:(NSString *)string
{
    if (!string.length) {
        return nil;
    }
    return [UIImage imageUrlFromString:string size:self.frame.size];
}

@end
