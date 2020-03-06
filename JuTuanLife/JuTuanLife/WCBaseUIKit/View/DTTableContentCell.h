//
//  DTTableContentCell.h
//  DrivingTest
//
//  Created by cheng on 15/11/27.
//  Copyright © 2015年 eclicks. All rights reserved.
//

#import "DTTableTitleCell.h"

@interface DTTableContentCell : DTTableTitleCell

+ (CGFloat)cellHeightWithItem:(NSString *)item tableView:(UITableView *)tableView withFont:(UIFont *)font;

//加间距，以及最小高度
+ (CGFloat)cellHeightWithItem:(NSString *)item tableView:(UITableView *)tableView withFont:(UIFont *)font gapH:(CGFloat)gapH minH:(CGFloat)minH;

+ (CGFloat)cellHeightWithAttrString:(NSAttributedString *)item tableView:(UITableView *)tableView;

@end
