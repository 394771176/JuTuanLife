//
//  DTButton.h
//  DrivingTest
//
//  Created by cheng on 16/9/8.
//  Copyright © 2016年 eclicks. All rights reserved.
//

#import <UIKit/UIKit.h>

//水平布局、垂直布局
typedef enum {
    DTButtonStyleVertical = 0,
    DTButtonStyleHorizontal
}DTButtonStyle;

//图片前置 ， 标题前置
typedef enum {
    DTButtonModeImageTitle = 0,
    DTButtonModeTitleImage
}DTButtonMode;

/**
 * 居中  
 * 靠左（水平）/上(垂直)
 * 靠右（水平）/底(垂直)
 */
typedef enum {
    DTButtonAlignmentCenter = 0,
    DTButtonAlignmentLeftOrTop,
    DTButtonAlignmentRightOrBottom,
    DTButtonAlignmentFillContent,
    DTButtonAlignmentFixCenter,
}DTButtonAlignment;


@interface DTButton : UIButton {

    UIView *_contentView;
    UIImageView *_imageView, *_bgImageView;
    UILabel *_titleLabel;
}

@property (nonatomic) DTButtonStyle style;
@property (nonatomic) DTButtonMode mode;
@property (nonatomic) DTButtonAlignment alignment;
@property (nonatomic) CGFloat gap;//default is 3;
@property (nonatomic) CGFloat leftOrTop;//default is 0; when DTButtonAlignmentCenter or Fill will ignore
@property (nonatomic) UIEdgeInsets edgeInset;//default is 0;
@property (nonatomic, assign) BOOL autoSize;
@property (nonatomic, assign) CGFloat fixFirstCenter;//第一个可变的控件的 中心固定
@property (nonatomic, assign) CGFloat fixLastCenter;//第二个可变的控件的 中心固定

- (UILabel *)titleLabel;
- (UIImageView *)imageView;
- (UIView *)contentView;
- (UIImageView *)bgImageView;

- (void)updateState;
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;

/* 
 *水平 传 宽度， 高度等于控件高度
 *垂直 传 高度， 宽度等于控件宽度
 */
- (void)setImageSize:(CGFloat)imageSize titleSize:(CGFloat)titleSize;
- (void)setLeftOrTop:(CGFloat)leftOrTop gap:(CGFloat)gap;
- (void)setLeftOrTop:(CGFloat)leftOrTop imageSize:(CGFloat)imageSize titleSize:(CGFloat)titleSize;
- (void)setLeftOrTop:(CGFloat)leftOrTop imageSize:(CGFloat)imageSize titleSize:(CGFloat)titleSize gap:(CGFloat)gap;

- (CGSize)getContentRealSize;

+ (instancetype)buttonWithStyle:(DTButtonStyle)style;
+ (instancetype)buttonWithMode:(DTButtonMode)mode;
+ (instancetype)buttonWithStyle:(DTButtonStyle)style mode:(DTButtonMode)mode;

@end
