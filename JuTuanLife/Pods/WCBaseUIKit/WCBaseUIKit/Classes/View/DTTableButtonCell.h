//
//  DTTableButtonCell.h
//  ChelunWelfare
//
//  Created by cheng on 15/1/8.
//  Copyright (c) 2015年 Wang Peng. All rights reserved.
//

#import "DTTableCustomCell.h"

typedef enum
{
    DTTableButtonStyleRed,
    DTTableButtonStyleBlue,
    DTTableButtonStyleGreen,
    DTTableButtonStyleGray,
    DTTableButtonStyleRedWhite,
    DTTableButtonStyleBlueWhite,
    DTTableButtonStyleGreenWhite,
    DTTableButtonStyleGrayWhite,
}DTTableButtonStyle;

@class DTTableButtonCell;

@protocol DTTableButtonCellDelegate <NSObject>

- (void)tableButtonCellDidClickAction:(DTTableCustomCell *)cell;

@optional
- (void)tableButtonCellDidClickAction:(DTTableCustomCell *)cell button:(UIButton *)sender;

@end

@interface DTTableButtonCell : DTTableCustomCell

@property (nonatomic, weak) id<DTTableButtonCellDelegate> delegate;
@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic) DTTableButtonStyle style;
@property (nonatomic) CGFloat corner;//default is 5.f

- (void)setButtonTop:(CGFloat)top;//默认居中，上下间距相等
- (void)setButtonTitle:(NSString *)title;
- (void)setButtonTitleColor:(UIColor *)color;//default is white
- (void)setButtonBgColorStr:(NSString *)colorStr;
- (void)setButtonImage:(UIImage *)image;

- (void)setButtonTitle:(NSString *)title withTitleColor:(UIColor *)color;

- (void)setButtonTitle:(NSString *)title withBgColorStr:(NSString *)colorStr;
- (void)setButtonBorderColor:(UIColor *)color withBgColorStr:(NSString *)colorStr;

//水平方向 两头的gap
- (void)setButtonHorGap:(CGFloat)gap;

@end
