//
//  JTHomeFenrunCell.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/14.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTHomeFenrunCell.h"

@interface JTHomeFenrunCell () <DTTabBarViewDelegate> {
    UIImageView *_bodyView;
    DTTabBarView *_tabBar;
    UILabel *_dateLabel;
    UILabel *_fenRunLabel;
    UILabel *_detailLabel;
    
    NSArray *_fenrunPeriods;
}

@end

@implementation JTHomeFenrunCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //24 * 24, 6 7 8 7
        UIImage *image = [[UIImage imageNamed:@"login_auth_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(12, 12, 11, 11)];
        UICREATEImageTo(_bodyView, UIImageView, 9, 0, self.contentView.width - 18, self.contentView.height, AAWH, CCFill, image, self.contentView);
        _bodyView.userInteractionEnabled = YES;
        
        //64 + 352 + 64 + 40 = 64 + 20 + 176
        UICREATETo(_tabBar, DTTabBarView, _bodyView.width / 2 - 260 / 2, 6 + 4, 260, 44, AALR, _bodyView);
        [_tabBar setNormalColor:COLOR(333333)];
        [_tabBar setSelectColor:COLOR(#FA3F3F)];
        _tabBar.selectedLine.hidden = YES;
        _tabBar.bottomLine.hidden = YES;
        _tabBar.delegate = self;
        _tabBar.fontSize = 18;
        _tabBar.zoomAnimation = YES;
        
        UICREATELabel2To(_dateLabel, UILabel, 10, _tabBar.bottom - 4, _bodyView.width - 20, 30, AAW, TTCenter, nil, @"16", @"999999", _bodyView);
        
        UICREATELabel2To(_fenRunLabel, UILabel, _dateLabel.left, _dateLabel.bottom, _dateLabel.width, 50, AAW, TTCenter, nil, @"32", @"000000", _bodyView);
        
        UICREATELabel2To(_detailLabel, UILabel, _dateLabel.left, _fenRunLabel.bottom + 10, _dateLabel.width, 30, AAW, TTCenter, nil, @"16", @"333333", _bodyView);
        
        [self setSelectionStyleClear];

//        [self.contentView showSubView];
    }
    return self;
}

- (UIImageView *)createArrowImage
{
    UIImageView *v = [super createArrowImage];
    v.frame = CGRectMake(_bodyView.right - (self.contentView.width - v.right) - v.width - 7, _fenRunLabel.top + _bodyView.top, v.width, _fenRunLabel.height);
    v.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    return v;
}

- (void)setOnlyFixPeriod:(BOOL)onlyFixPeriod
{
    _onlyFixPeriod = onlyFixPeriod;
    NSMutableArray *titles = [NSMutableArray array];
    if (onlyFixPeriod) {
        _fenrunPeriods = @[@(JTFenRunPeriodFixDay), @(JTFenRunPeriodFixMonth), @(JTFenRunPeriodFixYear)];
    } else {
        _fenrunPeriods = @[@(JTFenRunPeriodYesterday), @(JTFenRunPeriodWeek), @(JTFenRunPeriodMonth), @(JTFenRunPeriodQuarter), @(JTFenRunPeriodYear)];
    }
    for (id i in _fenrunPeriods) {
        [titles safeAddObject:[JTFenRunOverItem titleForPeriod:[i integerValue]]];
    }
    _tabBar.items = titles;
    
    if (_onlyFixPeriod) {
        //刷新一下布局
        self.item = _item;
    }
}

- (void)setPeriod:(JTFenRunPeriod)period
{
    _period = period;
    if (!_fenrunPeriods) {
        self.onlyFixPeriod = _onlyFixPeriod;
    }
    NSInteger index = [_fenrunPeriods indexOfObject:@(period)];
    if (index == NSNotFound) {
        index = 0;
    }
    _tabBar.selectIndex = index;
    
    if (index < _itemList.count) {
        self.item = [_itemList safeObjectAtIndex:index];
    }
}

- (void)setCellType:(JTFenrunCellType)cellType
{
    _cellType = cellType;
    if (cellType == JTFenrunCellTypeBar) {
        _dateLabel.hidden = YES;
        _fenRunLabel.hidden = YES;
        _detailLabel.hidden = YES;
    } else if (cellType == JTFenrunCellTypeBarDate) {
        _dateLabel.hidden = NO;
        _fenRunLabel.hidden = YES;
        _detailLabel.hidden = YES;
    } else if (cellType == JTFenrunCellTypeNormal) {
        _dateLabel.hidden = NO;
        _fenRunLabel.hidden = NO;
        _detailLabel.hidden = NO;
    }
}

- (void)setItemList:(NSArray *)itemList
{
    _itemList = itemList;
    if (itemList.count) {
        self.period = _period;
    }
}

- (void)setItem:(JTFenRunOverItem *)item
{
    _item = item;
    
    if (_onlyFixPeriod) {
        //item 为nil 仅显示 年月日
        if (item == nil) {
            self.cellType = JTFenrunCellTypeBar;
        } else {
            self.cellType = JTFenrunCellTypeNormal;
        }
    }
    if (item) {
        _dateLabel.text = [item dateStr];
        _fenRunLabel.text = [NSString stringWithFormat:@"%.2f", item.totalCommAmt];
        _detailLabel.text = [NSString stringWithFormat:@"%.2f（自己）+ %.2f（徒弟/孙）", item.myCommAmt, item.descendantCommAmt];
    }
}

#pragma mark - DTTabBarViewDelegate

- (void)tabBarViewDidSelectIndex:(NSInteger)index
{
    self.period = [[_fenrunPeriods safeObjectAtIndex:index] integerValue];
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabBarViewDidSelectIndex:)]) {
        [self.delegate tabBarViewDidSelectIndex:index];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)cellHeightWithItem:(id)item tableView:(UITableView *)tableView
{
    return [self cellHeightWithItem:item tableView:tableView type:JTFenrunCellTypeNormal];
}

+ (CGFloat)cellHeightWithItem:(id)item tableView:(UITableView *)tableView type:(JTFenrunCellType)type
{
    if (type == JTFenrunCellTypeBar) {
        return 70;
    } else if (type == JTFenrunCellTypeBarDate) {
        return 96;
    } else {
        return 198;
    }
}

+ (CGFloat)cellHeightWithItem:(id)item tableView:(UITableView *)tableView onlyFixPeriod:(BOOL)onlyFixPeriod
{
    if (item == nil && onlyFixPeriod) {
        return [self cellHeightWithItem:item tableView:tableView type:JTFenrunCellTypeBar];
    } else {
        return [self cellHeightWithItem:item tableView:tableView type:JTFenrunCellTypeNormal];
    }
}

@end
