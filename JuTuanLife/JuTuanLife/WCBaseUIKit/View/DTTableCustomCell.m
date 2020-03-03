//
//  DTTableCustomCell.m
//  DrivingTest
//
//  Created by Huang Tao on 1/30/13.
//  Copyright (c) 2013 eclicks. All rights reserved.
//

#import "DTTableCustomCell.h"

@implementation DTTableCustomCell {
    UIImageView *_arrow;
}

//兼容xib的cell --owen
- (void)awakeFromNib
{
    [super awakeFromNib];
//    [self resetCellWidthLayout];
    [self setUp];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    self.backgroundColor = nil;
    self.contentView.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = NO;
    
    UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
    bgView.backgroundColor = [UIColor whiteColor];
    self.backgroundView = bgView;
    
    // 选中背景
    UIView *selBgView = [[UIView alloc] initWithFrame:self.bounds];
    selBgView.backgroundColor = [UIColor colorWithHexString:@"eeeeee" alpha:1.0f];
    self.selectedBackgroundView = selBgView;
    
    _separatorView = [[BPOnePixLineView alloc] initWithFrame:CGRectMake(0.f, self.backgroundView.height-1.f, self.backgroundView.width, 1.f)];
    _separatorView.lineColor = [UIColor colorWithHexString:@"dcdcdc" alpha:1.f];
    _separatorView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.backgroundView addSubview:_separatorView];
    
    _lineGap = 12;
    _lineStyle = DTCellLineBottom;
    
    self.width = self.contentView.width = [UIScreen mainScreen].bounds.size.width;
    
    if (!iOS(7)) {
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        [_separatorView removeFromSuperview];
        [self addSubview:_separatorView];
    }
}

- (void)setLineGap:(CGFloat)lineGap
{
    _lineGap = lineGap;
    [self setLineStyle:_lineStyle];
}

- (void)setLineStyle:(DTCellLineStyle)lineStyle
{
    _lineStyle = lineStyle;
    if (lineStyle==DTCellLineNone) {
        _separatorView.hidden = YES;
    } else {
        _separatorView.hidden = NO;
        if (lineStyle==DTCellLineDefault) {
            [self setSeparatorLineWithLeft:_lineGap andRight:0];
        } else if (lineStyle==DTCellLineCommon){
            [self setSeparatorLineWithLeft:_lineGap];
        } else {
            [self setSeparatorLineWithLeft:0];
        }
    }
}

- (void)setCellStyleBottom:(BOOL)bottom
{
    self.lineStyle = bottom?DTCellLineBottom:DTCellLineDefault;
}

- (void)setSeparatorLineWithLeft:(CGFloat)left
{
    [self setSeparatorLineWithLeft:left andRight:left];
}

- (void)setSeparatorLineWithLeft:(CGFloat)left andRight:(CGFloat)right
{
    if (left > 1 && right < 1) {
        _lineGap = left;
    }
    _separatorView.frame = CGRectMake(left, self.backgroundView.height-_separatorView.height, self.backgroundView.width-left-right, _separatorView.height);
}

- (UIImageView *)createArrowImage
{
    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_common_arrow"]];
    arrow.frame = CGRectMake(self.contentView.width-15-arrow.width, 0, arrow.width, self.contentView.height);
    arrow.contentMode = UIViewContentModeCenter;
    arrow.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
    return arrow;
}

- (void)setArrowWithLeft:(CGFloat)left
{
    if (_arrow==nil) {
        _arrow = [self createArrowImage];
        [self.contentView addSubview:_arrow];
    }
    _arrow.left = left;
}

- (void)setArrowWithRighPadding:(CGFloat)rightPadding
{
    if (_arrow==nil) {
        _arrow = [self createArrowImage];
        [self.contentView addSubview:_arrow];
    }
    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_common_arrow"]];
    _arrow.left = self.contentView.width- rightPadding - arrow.width;
}

- (void)showArrow:(BOOL)show
{
    if (_arrow==nil&&show) {
        _arrow = [self createArrowImage];
        [self.contentView addSubview:_arrow];
    }
    _arrow.hidden = !show;
}

- (BOOL)isShowArrow
{
    return (_arrow&&!_arrow.hidden);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _separatorView.top = self.backgroundView.height-_separatorView.height;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setCellBaseStyle:(DTTableViewCellStyle)cellBaseStyle
{
    _cellBaseStyle = cellBaseStyle;
    if (_cellBaseStyle == DTTableViewCellStyleCommon) {
        _separatorView.hidden = NO;
    } else {
        _separatorView.hidden = YES;
    }
}

- (void)setSelectionStyleNone
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelectionStyleDefault
{
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
}

- (void)setSelectionStyleClear
{
    [self setSelectionStyleNoneLine];
    self.backgroundColor = [UIColor clearColor];
}

- (void)setSelectionStyleNoneLine
{
    [self setSelectionStyleNone];
    [self setLineStyle:DTCellLineNone];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    self.backgroundView.backgroundColor = backgroundColor;
}

+ (CGFloat)cellHeightWithItem:(id)item tableView:(UITableView *)tableView
{
    return 44;
}

@end
