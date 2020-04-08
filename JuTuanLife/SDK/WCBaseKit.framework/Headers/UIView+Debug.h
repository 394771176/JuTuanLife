//
//  UIView+Debug.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/20.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Debug)

+ (UIColor *)randomColor;
+ (UIColor *)randomAlphaColor;

/**
 *  调试用的方法
 */
- (void)showSubViewLayerborder;
- (void)showSubView;
- (void)showLayerborder;

/**判断某个子视图的位置，如果存在则返回该子视图*/
- (UIView *)isExistSubView:(Class)subView;

+ (void)showImageInWindow:(UIImage *)image;

+ (void)debugBlock:(void (^)(void))block;

@end
