//
//  SDWebImageManager.h
//  Pods
//
//  Created by cheng on 2020/2/24.
//

#import <Foundation/Foundation.h>
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "UIImageView+CLWebCache.h"
#import "UIButton+CLWebCache.h"
//#import <WCCategory/WCCategory.h>

@interface SDWebImageManager (fix)

- (BOOL)hasCacheForURL:(NSURL *)url;
- (BOOL)hasCacheForURLStr:(NSString *)urlStr;

- (NSString *)cacheImagePathForURL:(NSURL *)url;
- (NSString *)cacheImagePathForURLStr:(NSString *)urlStr;

- (UIImage *)cacheImageForURL:(NSURL *)url;
- (UIImage *)cacheImageForURLStr:(NSString *)urlStr;

+ (UIImage *)getImageFrom:(UIImage *)image targetSize:(CGSize)size corner:(CGFloat)corner;

@end
