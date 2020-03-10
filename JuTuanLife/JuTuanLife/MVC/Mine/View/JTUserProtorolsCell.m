//
//  JTUserProtorolsCell.m
//  JuTuanLife
//
//  Created by cheng on 2020/3/10.
//  Copyright © 2020 cheng. All rights reserved.
//

#import "JTUserProtorolsCell.h"

@interface JTUserProtorolsCell () {
    UILabel *_titleLabel;
    
    NSMutableArray<UILabel *> *_protorolsList;
}

@end

@implementation JTUserProtorolsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UICREATELabelTo(_titleLabel, UILabel, 28, 0, self.contentView.width - 56, 64, AAW, nil, @"16", @"333333", self.contentView);
        _titleLabel.numberOfLines = 0;
        
        [self setSelectionStyleNoneLine];
    }
    return self;
}

- (void)setItem:(JTUserProtorols *)item
{
    _item = item;
    
    if (APP_DEBUG) {
        item = [JTUserProtorols new];
        item.list = @[@"《12333333》", @"《3433454555》", @"《454354364536457467》", @"《899999999999999999》"];
        item.date = @"2020-1-20 13:45";
    }
    
    [_titleLabel setText:[NSString stringWithFormat:@"签署人本人于 %@ \n签署了以下协议合同：", item.date] withLineSpace:12];
    
    if (!_protorolsList) {
        _protorolsList = [NSMutableArray array];
    }
    for (NSInteger i = _protorolsList.count; i < item.list.count; i++) {
        UILabel *label = UICREATELabel(UILabel, _titleLabel.left, _titleLabel.bottom + 5 + 36 * i, _titleLabel.width, 36, AAW, nil, @"15", @"999999", self.contentView);
        label.tag = i;
        [label addTarget:self singleTapAction:@selector(protorolClick:)];
        [_protorolsList safeAddObject:label];
    }
    
    [_protorolsList enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.hidden = idx >= item.list.count;
        if (idx < item.list.count) {
            obj.text = [item.list safeObjectAtIndex:idx];
        }
    }];
}

- (void)protorolClick:(UITapGestureRecognizer *)gesture
{
    UIView *label = gesture.view;
    NSString *link = [_item.linkList safeObjectAtIndex:label.tag];
    [JTCoreUtil openWithLink:link];
}

+ (CGFloat)cellHeightWithItem:(JTUserProtorols *)item tableView:(UITableView *)tableView
{
    //todo
    CGFloat height = 64 + 5 + 36 * item.list.count + 40;
    if (APP_DEBUG) {
        height = 64 + 5 + 36 * 4 + 40;
    }
    return height;
}

@end
