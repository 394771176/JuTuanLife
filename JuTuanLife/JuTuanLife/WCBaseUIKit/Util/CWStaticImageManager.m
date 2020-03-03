//
//  CLStaticImageManager.m
//  CLCommon
//
//  Created by wangpeng on 14-6-16.
//  Copyright (c) 2014年 eclicks. All rights reserved.
//

#import "CWStaticImageManager.h"
#import "WCUICommon.h"

@interface CWStaticImageManager () {
    NSMutableDictionary *_cache;
}

@end

@implementation CWStaticImageManager

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init
{
    self = [super init];
    if (self) {
        _cache = [[NSMutableDictionary alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}

- (void)enterBackground
{
    [_cache removeAllObjects];
}

- (UIImage *)imageWithColorHex:(NSString *)colorHex size:(CGSize)size corner:(CGFloat)corner
{
    NSString *key = [NSString stringWithFormat:@"%@:%.0fx%.0fo%.0f", colorHex, size.width, size.height, corner];
    UIImage *image = [self imageWithCacheKey:key];
    if (image==nil) {
        image = [UIImage imageWithColorString:colorHex cornerRadius:corner withSize:size];
        [_cache safeSetObject:image forKey:key];
    }
    return image;
}

- (UIImage *)imageWithColorHex:(NSString *)colorHex
{
    NSString *key = [NSString stringWithFormat:@"%@:%.0fx%.0fo%.0f", colorHex, 1.0f, 1.0f, 0.0f];
    UIImage *image = [self imageWithCacheKey:key];
    if (image==nil) {
        image = [UIImage imageWithColor:[UIColor colorWithHexString:colorHex]];
        [_cache safeSetObject:image forKey:key];
    }
    return image;
}

- (UIImage *)imageWithCacheKey:(NSString *)key
{
    if ([[_cache allKeys] containsObject:key]) {
        UIImage *result = [_cache objectForKey:key];
        return result;
    }
    return nil;
}

- (void)setImage:(UIImage *)image withCacheKey:(NSString *)key
{
    [_cache safeSetObject:image forKey:key];
}

+ (CWStaticImageManager *)sharedInstance
{
    static id instance = nil;
    @synchronized (self) {
        if (instance==nil) {
            instance = [[CWStaticImageManager alloc] init];
        }
    }
    return instance;
}

@end
