//
//  DTTabItem.h
//  DrivingTest
//
//  Created by cheng on 2017/11/30.
//  Copyright © 2017年 eclicks. All rights reserved.
//

#import <WCModel/WCBaseEntity.h>

@interface DTTabItem : WCBaseEntity

@property (nonatomic, strong) NSString *itemId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *icon_selected;
@property (nonatomic, strong) NSString *color;
@property (nonatomic, strong) NSString *color_selected;
@property (nonatomic, assign) NSInteger type;//0图片 + 文字， 1 文字， 2 图片
@property (nonatomic, assign) BOOL beyond_bounds;

@end
