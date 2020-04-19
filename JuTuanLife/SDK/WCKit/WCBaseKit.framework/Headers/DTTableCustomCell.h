//
//  DTTableCustomCell.h
//  DrivingTest
//
//  Created by Huang Tao on 1/30/13.
//  Copyright (c) 2013 eclicks. All rights reserved.
//
#import <UIKit/UIKit.h>
//#import "DTTableViewCell.h"
#import "BPOnePixLineView.h"
#import "WCBaseUtil.h"

typedef enum {
    DTTableViewCellStyleCommon,
    DTTableViewCellStyleBottom,
} DTTableViewCellStyle;

/*
 line gap
 default  left= gap , right = 0;
 common  left = right = gap;
 bottom  left = right = 0;
 None : line hidden
 Custom: line show
 */

//默认为 DTCellLineBottom, 无缩进
typedef enum {
    DTCellLineDefault = 0,
    DTCellLineCommon,
    DTCellLineBottom,//目前默认 bottom style
    DTCellLineNone,
    DTCellLineCustom,
} DTCellLineStyle;

@interface DTTableCustomCell : UITableViewCell
{
    @protected
    UIImageView *_arrow;
}
@property (nonatomic, strong, readonly) BPOnePixLineView *separatorView;
@property (nonatomic) DTTableViewCellStyle cellBaseStyle;//旧属性
@property (nonatomic) CGFloat lineGap;//deafult is 12
@property (nonatomic) DTCellLineStyle lineStyle;// default is DTCellLineBottom
@property (nonatomic, readonly) BOOL isShowArrow;//default is NO

- (void)setSeparatorLineWithLeft:(CGFloat)left;//左右缩进相等
- (void)setSeparatorLineWithLeft:(CGFloat)left andRight:(CGFloat)right;
/**
 *  setSelectionStyle:UITableViewCellSelectionStyleNone
 *  backgroundColor = [UICOlor clearColor]
 */

- (void)setSelectionStyleDefault;//默认选中效果
- (void)setSelectionStyleNone;//无选中效果
- (void)setSelectionStyleNoneLine;//无选中效果 + 无底部分割线
- (void)setSelectionStyleClear;//无选中效果 + 无底部分割线 + 无背景色

/**
 控制分割线 lineStyle

 @param bottom if yes will DTCellLineBottom ; no will DTCellLineDefault
 */
- (void)setCellStyleBottom:(BOOL)bottom;
- (UIImage *)cellArrow;
- (UIImageView *)createArrowImage;//若不使用默认箭头，可在子类实现
- (void)setArrowWithLeft:(CGFloat)left;//when need arrow
- (void)setArrowWithRighPadding:(CGFloat)rightPadding;

- (void)showArrow:(BOOL)show;

//右侧边缘距离（包含自身宽度），便于子类计算label 高度
+ (CGFloat)defaultArrowRightEadge;

+ (CGFloat)cellHeightWithItem:(id)item tableView:(UITableView *)tableView;

@end
