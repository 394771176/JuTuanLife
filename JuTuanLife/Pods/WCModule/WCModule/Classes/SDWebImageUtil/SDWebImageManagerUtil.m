//
//  SDWebImageManager.h
//  Pods
//
//  Created by cheng on 2020/2/24.
//

#import "SDWebImageManagerUtil.h"

@implementation SDWebImageManager (fix)

- (BOOL)hasCacheForURL:(NSURL *)url
{
    return [self hasCacheForURL:url cacheKey:nil];
}

- (BOOL)hasCacheForURLStr:(NSString *)urlStr
{
    if (!urlStr.length) {
        return NO;
    }
    return [self hasCacheForURL:[NSURL URLWithString:urlStr]];
}

- (BOOL)hasCacheForURL:(NSURL *)url cacheKey:(NSString **)cacheKey
{
    NSString *key = [self cacheKeyForURL:url];
    if (cacheKey) {
        *cacheKey = key;
    }
    if ([self.imageCache imageFromMemoryCacheForKey:key] != nil) return YES;
    
    NSString *path = [self.imageCache defaultCachePathForKey:key];
    // this is an exception to access the filemanager on another queue than ioQueue, but we are using the shared instance
    // from apple docs on NSFileManager: The methods of the shared NSFileManager object can be called from multiple threads safely.
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    if (!exists) {
        exists = [[NSFileManager defaultManager] fileExistsAtPath:path.stringByDeletingPathExtension];
    }
    return exists;
}

- (NSString *)cacheImagePathForURLStr:(NSString *)urlStr
{
    if (!urlStr.length) {
        return nil;
    }
    return [self cacheImagePathForURL:[NSURL URLWithString:urlStr]];
}

- (NSString *)cacheImagePathForURL:(NSURL *)url
{
    NSString *key = nil;
    if ([self hasCacheForURL:url cacheKey:&key]) {
        return [self.imageCache defaultCachePathForKey:key];
    }
    return nil;
}

- (UIImage *)cacheImageForURLStr:(NSString *)urlStr
{
    if (!urlStr.length) {
        return nil;
    }
    return [self cacheImageForURL:[NSURL URLWithString:urlStr]];
}

- (UIImage *)cacheImageForURL:(NSURL *)url
{
    return [[SDImageCache sharedImageCache] imageFromCacheForKey:[self cacheKeyForURL:url]];
}

+ (UIImage *)getImageFrom:(UIImage *)image targetSize:(CGSize)size corner:(CGFloat)corner
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:corner] addClip];
    if (!CGSizeEqualToSize(image.size, size)) {
        CGFloat scale = [UIScreen mainScreen].scale;
        CGSize blockSize = CGSizeMake(size.width*scale, size.height*scale);
        CGSize result = CGSizeZero;
        result.width = blockSize.width;
        result.height = blockSize.width*image.size.height/image.size.width;
        if (result.height<blockSize.height) {
            result.height = blockSize.height;
            result.width = blockSize.height*image.size.width/image.size.height;
        }
        UIImage *subImage = [self getSubImage:CGRectMake((result.width/2-blockSize.width/2), (result.height/2-blockSize.height/2), blockSize.width, blockSize.height) withImage:[self resizeToSize:result withImage:image]];
        [subImage drawInRect:rect];
    } else {
        [image drawInRect:rect];
    }
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

+ (UIImage *)getSubImage:(CGRect)rect withImage:(UIImage *)image
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    UIImage *subImage = [UIImage imageWithCGImage:subImageRef];
    CGImageRelease(subImageRef);
    return subImage;
}

+ (UIImage *)resizeToSize:(CGSize)size withImage:(UIImage *)image
{
    if (CGSizeEqualToSize(size, image.size)) {
        return image;
    }
    UIGraphicsBeginImageContext(CGSizeMake(size.width, size.height));
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reSizeImage;
}

@end
