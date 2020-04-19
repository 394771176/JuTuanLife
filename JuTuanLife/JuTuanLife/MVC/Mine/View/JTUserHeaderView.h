//
//  JTUserHeaderView.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/14.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTUserTeamView.h"
#import "JTUser.h"
#import "JTShipItem.h"


@interface JTUserHeaderView : UIView

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) JTUserTeamView *teamView;

@property (nonatomic, strong) JTUser *item;

@property (nonatomic, assign) NSInteger relationType;

@property (nonatomic, assign) BOOL showJobNo;
@property (nonatomic, assign) BOOL showRelationNum;

- (void)setNameFont:(UIFont *)font;
- (CGFloat)getTeamsViewRight;
- (void)setNameMaxWidth:(CGFloat)width;

- (void)setNameRightGap:(CGFloat)gap;

@end

