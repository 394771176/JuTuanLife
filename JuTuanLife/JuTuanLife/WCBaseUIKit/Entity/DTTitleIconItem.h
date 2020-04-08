//
//  DTTitleIconItem.h
//  DrivingTest
//
//  Created by cheng on 16/3/18.
//  Copyright © 2016年 eclicks. All rights reserved.
//

#import <WCBaseKit/WCBaseKit.h>

@interface DTTitleIconItem : WCBaseEntity

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImage *icon;

//@property (nonatomic, strong) NSString *text;

@property (nonatomic, assign) NSInteger tag;//tag 为5 为VIP

/// centerItem.type == 1 时，中间固定为 智能答题
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSString *openSchemeUrl;

+ (instancetype)itemWithTitle:(NSString *)title iconName:(NSString *)iconName;

+ (instancetype)itemWithTitle:(NSString *)title iconName:(NSString *)iconName scheme:(NSString *)scheme;

@end

@interface DTTitleContentIcon : DTTitleIconItem

@property (nonatomic, strong) NSString *content;

+ (instancetype)itemWithTitle:(NSString *)title iconName:(NSString *)iconName content:(NSString *)content;

@end

@interface DTTitleIconUrlItem : DTTitleIconItem

// 校验父类 icon
@property (nonatomic, strong) NSString *iconUrl;
@property (nonatomic, strong) NSString *jumpUrl;
/// centerItem.type == 1 时，中间固定为 智能答题
/// @property (nonatomic, assign) NSUInteger type;

+ (DTTitleIconUrlItem *)itemFromConfigDict:(NSDictionary *)dict;
+ (DTTitleIconUrlItem *)itemFromConfig:(NSDictionary *)dict key:(NSString *)key;
+ (DTTitleIconItem *)itemFromConfig:(NSDictionary *)dict key:(NSString *)key withDefault:(DTTitleIconItem * (^)(void))defaultBlock;

@end
