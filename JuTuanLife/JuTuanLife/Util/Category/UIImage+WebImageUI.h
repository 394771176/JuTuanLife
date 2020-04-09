//
//  UIImage+WebImageUI.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/22.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (WebImageUI)

+ (UIImage *)imageForName:(NSString *)string;
+ (NSURL *)imageUrlFromString:(NSString *)string;
+ (NSURL *)imageUrlFromString:(NSString *)string size:(CGSize)size;

@end

@interface UIView (WebImageUI) {
    
}

- (NSURL *)urlForStr:(NSString *)string;

@end
