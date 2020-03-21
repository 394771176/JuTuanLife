//
//  UIView+Debug.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/20.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "UIView+Debug.h"

@implementation UIView (Debug)

+ (UIColor *) randomColor {
    return [UIColor colorWithRed:arc4random()%256/255.f green:arc4random()%256/255.f blue:arc4random()%256/255.f alpha:1.0];
}

+ (UIColor *) randomAlphaColor {
    return [UIColor colorWithRed:arc4random()%256/255.f green:arc4random()%256/255.f blue:arc4random()%256/255.f alpha:0.2 + arc4random()%50/100.f];
}

- (void)showSubViewLayerborder
{
#ifdef DEBUG
    [self showLayerborder];
    for (UIView *view in self.subviews) {
        [view showSubViewLayerborder];
    }
#endif
}

- (void)showSubView
{
#ifdef DEBUG
    for (UIView *view in self.subviews) {
        view.backgroundColor = [UIView randomColor];
        [view showSubView];
    }
#endif
}

- (void)showLayerborder
{
#ifdef DEBUG
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = [UIView randomColor].CGColor;
#endif
}

+ (void)showImageInWindow:(UIImage *)image
{
    [self debugBlock:^{
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        imgV.image = image;
        imgV.contentMode = UIViewContentModeScaleAspectFit;
        imgV.backgroundColor = [UIColor colorWithString:@"000000" alpha:0.4];
        [imgV addTarget:imgV singleTapAction:@selector(removeFromSuperview)];
        [[UIApplication sharedApplication].keyWindow addSubview:imgV];
    }];
}

- (UIView *)isExistSubView:(Class)subView
{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:subView]) {
            return view;
            break;
        }
    }
    return nil;
}

+ (void)debugBlock:(void (^)(void))block
{
#ifdef DEBUG
    if (block) {
        block();
    }
#endif
}

@end
