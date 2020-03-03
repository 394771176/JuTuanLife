//
//  CWDaijiaCommentStarView.h
//  ChelunWelfare
//
//  Created by cheng on 15/1/14.
//  Copyright (c) 2015年 Wang Peng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCCommentStarView : UIView

@property (nonatomic) NSInteger star;//1-10, 2为一星， 1为半星， 
@property (nonatomic) BOOL canEdit;//default is NO

/*
 * 正常使用 setCustomStarImages 方法
 * 当需要临时改变 images 里面星星的图片，可以单独设置，优先级别高于 images;
 */
@property (nonatomic, strong) UIImage *emptyImage;
@property (nonatomic, strong) UIImage *fullImage;
@property (nonatomic, strong) UIImage *halfImage;
/**
 * 自定义星级图标
 * 规则：empty 、full 、 half , 
 * half 没有用empty
 */
- (void)setCustomStarImages:(NSArray *)images;

@end
