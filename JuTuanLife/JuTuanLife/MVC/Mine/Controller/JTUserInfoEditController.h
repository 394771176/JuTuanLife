//
//  JTUserInfoEditController.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/11.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JTUserInfoEditController;

@protocol JTUserInfoEditControllerDelegate <NSObject>

- (void)userInfoEditController:(JTUserInfoEditController *)controller changeText:(NSString *)text;

@end

@interface JTUserInfoEditController : DTTableController

@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) NSString *orignalText;
@property (nonatomic, strong) NSString *tips;

@property (nonatomic) int maxTextLength;//default is 0 , mean 不限字数

@property (nonatomic, weak) id<JTUserInfoEditControllerDelegate> delegate;

@end
