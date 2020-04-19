//
//  CLStaticImageManager.h
//  CLCommon
//
//  Created by wangpeng on 14-6-16.
//  Copyright (c) 2014年 eclicks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

@interface CWStaticImageManager : NSObject

+ (CWStaticImageManager *)sharedInstance;

- (UIImage *)imageWithColorHex:(NSString *)colorHex;
- (UIImage *)imageWithColorHex:(NSString *)colorHex size:(CGSize)size corner:(CGFloat)corner;

- (UIImage *)imageWithCacheKey:(NSString *)key;
- (void)setImage:(UIImage *)image withCacheKey:(NSString *)key;

@end
