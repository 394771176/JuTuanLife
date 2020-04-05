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

- (void)setItem:(NSArray<JTUserProtorols *> *)item
{
    _item = item;
    
    if (item.count) {
        NSString *dateStr = [item.firstObject signedTime];
        [_titleLabel setText:[NSString stringWithFormat:@"签署人本人于 %@ \n签署了以下协议合同：", dateStr] withLineSpace:12];
    } else {
        _titleLabel.text = @"";
    }
    
    if (!_protorolsList) {
        _protorolsList = [NSMutableArray array];
    }
    for (NSInteger i = _protorolsList.count; i < item.count; i++) {
        UILabel *label = UICREATELabel(UILabel, _titleLabel.left, _titleLabel.bottom + 5 + 36 * i, _titleLabel.width, 36, AAW, nil, @"15", @"333333", self.contentView);
        label.tag = i;
        [label addTarget:self singleTapAction:@selector(protorolClick:)];
        [_protorolsList safeAddObject:label];
    }
    
    [_protorolsList enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.hidden = idx >= item.count;
        if (idx < item.count) {
            JTUserProtorols *pro = [item safeObjectAtIndex:idx];
            obj.text = [NSString stringWithFormat:@"《%@》", pro.name];
        }
    }];
}

- (void)protorolClick:(UITapGestureRecognizer *)gesture
{
    UIView *label = gesture.view;
    JTUserProtorols *item = [_item safeObjectAtIndex:label.tag];
    [JTLinkUtil openWithLink:item.contentUrl];
}

+ (CGFloat)cellHeightWithItem:(NSArray *)item tableView:(UITableView *)tableView
{
    CGFloat height = 64 + 5 + 36 * item.count + 16;
    return height;
}

@end
