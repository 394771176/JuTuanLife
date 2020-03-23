//
//  NSObject+JTHook.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/22.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "NSObject+JTHook.h"

@implementation NSObject (JTHook)

@end


@implementation UIImage (JTHook)

+ (void)load
{
    WC_Swizzle_Class(@selector(imageUrlFromString:size:), @selector(jt_imageUrlFromString:size:));
}

+ (NSString *)jt_imageUrlFromString:(NSString *)urlStr size:(CGSize)size
{
    if (size.width < 60 && size.height < 60) {
        return JTIMAGEURL(urlStr, JTImageType80x80);
    } else if (size.width < 100 && size.height < 100) {
        return JTIMAGEURL(urlStr, JTImageType160x160);
    } else if (size.width < 150 && size.height < 150) {
        return JTIMAGEURL(urlStr, JTImageType240x240);
    } else if (size.width < 321 && size.height < 321) {
        return JTIMAGEURL(urlStr, JTImageType640x640);
    } else {
        return JTIMAGEURL(urlStr, JTImageTypeOrig);
    }
    return urlStr;
}

@end
