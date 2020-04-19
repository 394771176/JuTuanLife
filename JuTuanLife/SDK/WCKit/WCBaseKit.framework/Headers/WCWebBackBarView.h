//
//  WCWebBackItem.h
//  JuTuanLife
//
//  Created by cheng on 2020/3/23.
//  Copyright © 2020 cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCWebBackBarView : UIView

/**
 *  是否显示关闭按钮
 */
@property (nonatomic) BOOL showCloseBtn;

/**
 *  后退的图标
 */
@property (nonatomic, strong) UIButton *backBtn;

/**
 *  关闭的图标
 */
@property (nonatomic, strong) UIButton *closeBtn;

+ (WCWebBackBarView *)view;

- (void)addTarget:(id)target withBackAction:(SEL)backAction;
- (void)addTarget:(id)target withCloseAction:(SEL)closeAction;

@end
